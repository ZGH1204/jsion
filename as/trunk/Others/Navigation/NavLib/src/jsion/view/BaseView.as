package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.ActionManager;
	import jsion.ProvinceMgr;
	import jsion.Util;
	import jsion.actions.AlphaAction;
	import jsion.actions.MaskCloseAction;
	import jsion.actions.MaskShowAction;
	import jsion.actions.MoveAction;
	import jsion.actions.ScaleAction;
	import jsion.controls.Button;
	import jsion.factory.ControlFactory;
	
	public class BaseView extends Sprite implements IDispose
	{
		protected var _data:Object;
		
		protected var _top:DisplayObject;
		protected var _bottom:DisplayObjectContainer;
		protected var _container:Sprite;
		
		protected var _list:Array;
		
		protected var _clickTarget:DisplayObject;
		
		protected var _targetX:Number = 0;
		protected var _targetY:Number = 0;
		
		protected var shape:Shape;
		
		protected var _shadowLayer:Sprite;
		
		protected var _closeTargetPoint:Point;
		protected var _closeTargetRect:Rectangle;
		protected var _closeCallback:Function;
		
		protected var _parentShadowLayer:Sprite;
		
		public function BaseView()
		{
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(value == null) return;
			_data = value;
			
			_shadowLayer = new Sprite();
			
			initTop();
			initBottom();
			initView();
			addEvent();
			addChildren();
		}
		
		public function get parentShadowLayer():Sprite
		{
			return _parentShadowLayer;
		}
		
		public function set parentShadowLayer(value:Sprite):void
		{
			_parentShadowLayer = value;
		}
		
		protected function initTop():void
		{
			_top = Util.createDisplay(_data.topPic, _data.topPicX, _data.topPicY);
			if(_top && _top.hasOwnProperty("mouseEnabled")) _top["mouseEnabled"] = false;
		}
		
		protected function initBottom():void
		{
			_bottom = Util.createDisplay(_data.bottomPic, _data.bottomPicX, _data.bottomPicY) as DisplayObjectContainer;
		}
		
		protected function initView():void
		{
			DisposeHelper.dispose(_container);
			_container = new Sprite();
			
			DisposeHelper.dispose(shape);
			shape = new Shape();
			
			if(_top)
			{
				_container.x = _top.x;
				_container.y = _top.y;
			}
			
			removeEvent();
			DisposeHelper.dispose(_list);
			_list = [];
		}
		
		protected function addEvent():void
		{
			for each(var btn:DisplayObject in _list)
			{
				btn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			}
		}
		
		protected function addChildren():void
		{
			if(shape) addChild(shape);
			if(_bottom) addChild(_bottom);
			if(_container) addChild(_container);
			if(_top) addChild(_top);
		}
		
		protected function removeEvent():void
		{
			for each(var btn:DisplayObject in _list)
			{
				btn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			}
		}
		
		private function __btnClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if(_clickTarget) return;
			
			_clickTarget = e.currentTarget as DisplayObject;
			
			onClickHandler();
		}
		
		protected function onClickHandler():void
		{
			ProvinceMgr.Instance.showView(_shadowLayer);
			
			if(_shadowLayer)
			{
				_shadowLayer.graphics.clear();
				_shadowLayer.graphics.beginFill(0x0, 1);
				_shadowLayer.graphics.drawRect(0, 0, StageReference.stage.stageWidth, StageReference.stage.stageHeight);
				_shadowLayer.graphics.endFill();
			}
		}
		
		protected function createViewBtn(up:String, over:String, x:Number, y:Number, txt:String, txtFont:String, txtSize:int, txtColor:uint, txtBold:Boolean, txtItalic:Boolean, txtX:Number, txtY:Number, container:DisplayObjectContainer):void
		{
			var upView:DisplayObject = Util.createDisplay(up);
			var overView:DisplayObject = Util.createDisplay(over);
			var btn:Button = ControlFactory.createButtonAndText(upView, overView, x, y, txt, txtFont, txtSize, txtColor, txtBold, txtItalic, txtX, txtY);
			
			if(btn.isExists)
			{
				var p:Point = localToGlobal(new Point(btn.x, btn.y))
				p = container.globalToLocal(p);
				btn.x = p.x;
				btn.y = p.y;
				container.addChild(btn);
				_list.push(btn);
			}
			else
			{
				DisposeHelper.dispose(btn);
			}
		}
		
		private function __closeClichHandler(e:MouseEvent):void
		{
			beginClose();
		}
		
		public function beginClose():void
		{
			if(_closeTargetPoint == null || _closeTargetRect == null)
			{
				closeAlphaCallback();
				return;
			}
			
			mouseEnabled = mouseChildren = false;
			
			setStartCloseBottom();
		}
		
		protected function setStartClosePos(xPos:Number, yPos:Number):void
		{
			if(_container)
			{
				ActionManager.Instance.act(new MoveAction(_container, new Point(xPos, yPos)));
			}
			
			if(_top)
			{
				ActionManager.Instance.act(new MoveAction(_top, new Point(xPos, yPos)));
			}
		}
		
		protected function setStartCloseSize(scalX:Number, scalY:Number):void
		{
			if(_container)
			{
				ActionManager.Instance.act(new ScaleAction(_container, scalX, scalY));
			}
			
			if(_top)
			{
				ActionManager.Instance.act(new ScaleAction(_top, scalX, scalY));
			}
		}
		
		protected function setStartCloseAlpha():void
		{
			if(_container)
			{
				ActionManager.Instance.act(new AlphaAction(_container, 0, closeAlphaCallback));
			}
			
			if(_top)
			{
				ActionManager.Instance.act(new AlphaAction(_top, 0, null));
			}
			
			if(_parentShadowLayer)
			{
				ActionManager.Instance.act(new AlphaAction(_parentShadowLayer, 0, null));
			}
		}
		
		private function closeAlphaCallback():void
		{
			if(_closeCallback != null) _closeCallback();
			DisposeHelper.dispose(this);
		}
		
		protected function setStartCloseBottom():void
		{
			if(_bottom)
			{
				ActionManager.Instance.act(new MaskCloseAction(_bottom.mask as Shape, closeBottomCallback));
			}
			else
			{
				closeAlphaCallback();
			}
		}
		
		private function closeBottomCallback():void
		{
			setStartClosePos(_closeTargetPoint.x, _closeTargetPoint.y);
			setStartCloseSize(_closeTargetRect.x, _closeTargetRect.x);
			setStartCloseAlpha();
		}
		
		public function beginShow(point:Point, w:Number, h:Number, closeCallback:Function):void
		{
			_closeCallback = closeCallback;
			
			mouseEnabled = mouseChildren = false;
			
			_closeTargetPoint = point;
			_closeTargetRect = new Rectangle(0, 0, w, h);
			
			setStartShowPos(point.x, point.y);
			setStartShowSize(w, h);
			setStartShowAlpha();
			setStartShowBottom();
			
			addEventListener(MouseEvent.CLICK, __closeClichHandler);
		}
		
		protected function setStartShowPos(xPos:Number, yPos:Number):void
		{
			if(_container)
			{
				_targetX = _container.x;
				_targetY = _container.y;
				_container.x = xPos;
				_container.y = yPos;
				ActionManager.Instance.act(new MoveAction(_container, new Point(_targetX, _targetY)));
			}
			
			if(_top)
			{
				_targetX = _top.x;
				_targetY = _top.y;
				_top.x = xPos;
				_top.y = yPos;
				ActionManager.Instance.act(new MoveAction(_top, new Point(_targetX, _targetY)));
			}
		}
		
		protected function setStartShowSize(w:Number, h:Number):void
		{
			if(_container)
			{
				_container.width = w;
				_container.height = h;
				
				if(_closeTargetRect)
				{
					_closeTargetRect.x = _container.scaleX;
					_closeTargetRect.y = _container.scaleY;
				}
				
				ActionManager.Instance.act(new ScaleAction(_container, 1, 1));
			}
			
			if(_top)
			{
				_top.width = w;
				_top.height = h;
				
				ActionManager.Instance.act(new ScaleAction(_top, 1, 1));
			}
		}
		
		protected function setStartShowAlpha():void
		{
			if(_container)
			{
				_container.alpha = 0;
				ActionManager.Instance.act(new AlphaAction(_container, 1, upAlphaActionCallback));
			}
			if(_top)
			{
				_top.alpha = 0;
				ActionManager.Instance.act(new AlphaAction(_top, 1, null));
			}
			if(_parentShadowLayer)
			{
				_parentShadowLayer.alpha = 0;
				ActionManager.Instance.act(new AlphaAction(_parentShadowLayer, 0.60, null));
			}
		}
		
		private function upAlphaActionCallback():void
		{
			if(_bottom && _bottom.mask) ActionManager.Instance.act(new MaskShowAction(_bottom.mask as Shape, maskShowActionCallback));
		}
		
		private function maskShowActionCallback():void
		{
			mouseEnabled = mouseChildren = true;
		}
		
		protected function setStartShowBottom():void
		{
			if(_bottom)
			{
				_bottom.mask = shape;
			}
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, __closeClichHandler);
			
			removeEvent();
			
			DisposeHelper.dispose(_shadowLayer);
			_shadowLayer = null;
			
			DisposeHelper.dispose(_container);
			_container = null;
			
			DisposeHelper.dispose(_list);
			_list = null;
			
			DisposeHelper.dispose(_top);
			_top = null;
			
			if(_bottom) _bottom.mask = null;
			DisposeHelper.dispose(_bottom);
			_bottom = null;
			
			DisposeHelper.dispose(shape);
			shape = null;
			
			DisposeHelper.dispose(_clickTarget);
			_clickTarget = null;
			
			_closeTargetPoint = null;
			_closeTargetRect = null;
			_closeCallback = null;
			_data = null;
			_parentShadowLayer = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}