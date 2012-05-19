package jsion.ddrop
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import jsion.Constant;
	import jsion.utils.DepthUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	//import jsion.utils.*;

	/**
	 * 拖拽管理
	 * @author Jsion
	 * 
	 */	
	public class DDropMgr
	{
		private static const Default_Group:String = "default";
		
		private static var _useFPS:Boolean;
		
		private static var _draging:Boolean;
		private static var _transData:*;
		private static var _dragger:IDragDrop;
		private static var _dragIcon:DisplayObject;
		private static var _dragingGroup:DDGroup;
		
		private static var _dragStartGlobarPoint:Point = new Point();
		private static var _dragStartPoint:Point = new Point();
		private static var _dragIconStartPoint:Point;
		
		private static var _groups:Dictionary = new Dictionary();
		
		private static var _stage:Stage;
		
		public static function setup(stage:Stage):void
		{
			if(_stage == stage) return;
			
			_stage = stage;
		}
		
		/**
		 * 是否使用EnterFrame事件进入拖动
		 */		
		public static function get useFPS():Boolean
		{
			return _useFPS;
		}
		public static function set useFPS(value:Boolean):void
		{
			_useFPS = value;
		}
		
		/**
		 * 是否正在拖动中 
		 */		
		public static function get draging():Boolean
		{
			return _draging;
		}
		
		/**
		 * 注册拖拽
		 * @param dragger 要注册的对象
		 * @param group 拖拽分组
		 * @param isClickDrag true表示鼠标点击后拖动,false表示鼠标按下后拖动.
		 */		
		public static function registeDrag(dragger:IDragDrop, group:String = null):void
		{
			if(dragger == null) return;
			
			if(_stage == null)
			{
				throw new Error("请先执行DDropMgr.setup(Stage)方法初始化拖拽管理后再使用.");
				return;
			}
			
			var g:DDGroup = getDDGroup(group);
			
			if(g.contains(dragger)) return;
			
			g.add(dragger);
			
			if(dragger.isClickDrag) dragger.addEventListener(MouseEvent.CLICK, __dragStartHandler);
			else dragger.addEventListener(MouseEvent.MOUSE_DOWN, __dragStartHandler);
		}
		
		/**
		 * 取消拖拽
		 * @param dragger 要取消的对象
		 * @param group 拖拽分组
		 */		
		public static function unregisteDrag(dragger:IDragDrop):void
		{
			if(dragger == null) return;
			
			var g:DDGroup = getDDGroupByDragger(dragger);
			
			if(g) g.remove(dragger);
			
			removeDragEvent(dragger);
			
			if(_draging && _dragger == dragger)
			{
				stopDraging();
			}
		}
		
		/**
		 * 清除指定分组
		 * @param group 分组名称,null或空字符串表示默认分组.
		 */		
		public static function clearGroup(group:String = null):void
		{
			if(StringUtil.isNullOrEmpty(group)) group = Default_Group;
			
			for each(var item:DDGroup in _groups)
			{
				if(item.group == group)
				{
					item.each(removeDragEvent);
					DictionaryUtil.delKey(_groups, group);
					break;
				}
			}
		}
		
		/**
		 * 清除所有分组
		 */		
		public static function clearGroups():void
		{
			for each(var item:DDGroup in _groups)
			{
				item.each(removeDragEvent);
			}
			
			DisposeUtil.free(_groups);
		}
		
		/**
		 * 获取拖拽分组,无分组时自动创建.
		 * @param group 分组名称
		 * @return 分组对象
		 * @private
		 */		
		private static function getDDGroup(group:String):DDGroup
		{
			if(StringUtil.isNullOrEmpty(group)) group = Default_Group;
			
			if(_groups[group] == null) _groups[group] = new DDGroup(group);
			
			return _groups[group] as DDGroup;
		}
		
		/**
		 * 通过拖拽对象查找分组
		 * @param dragger 拖拽对象
		 * @return 拖拽分组
		 */		
		private static function getDDGroupByDragger(dragger:Object):DDGroup
		{
			for each(var item:DDGroup in _groups)
			{
				if(item.contains(dragger))
				{
					return item;
				}
			}
			
			return null;
		}
		
		/**
		 * 移除拖动监听
		 * @param dragger 拖动对象
		 */		
		private static function removeDragEvent(dragger:IEventDispatcher):void
		{
			if(dragger == null) return;
			dragger.removeEventListener(MouseEvent.CLICK, __dragStartHandler);
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, __dragStartHandler);
		}
		
		/**
		 * 释放拖动,清除拖动时产生的所有数据.
		 */		
		private static function stopDraging():void
		{
			if(_draging == false) return;
			
			_draging = false;
			
//			if(_dragIcon != _dragger)
//				DisposeUtil.free(_dragIcon);
			
			if(_dragger.freeDragingIcon)
				DisposeUtil.free(_dragIcon);
			
			_dragger = null;
			_transData = null;
			_dragingGroup = null;
			
			_dragIcon = null;
			_dragIconStartPoint = null;
		}
		
		/**
		 * 移除拖拽中的事件监听
		 */		
		private static function removeDragingEvent():void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, __dragingHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, __dragingHandler);
			_stage.removeEventListener(MouseEvent.CLICK, __dropHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, __dropHandler);
			_stage.removeEventListener(Event.DEACTIVATE, __dropAbortHandler);
			_stage.removeEventListener(Event.MOUSE_LEAVE, __dropAbortHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_OUT, __dropAbortHandler);
			//_stage.removeEventListener(MouseEvent.ROLL_OUT, __dropAbortHandler);
		}
		
		/**
		 * 正常拖动放下后检测是否有碰撞当前拖拽分组内的对象
		 */		
		private static function checkDropHits():void
		{
			if(_draging == false || _dragger == null || _dragingGroup == null || _dragingGroup == getDDGroup(Default_Group)) return;
			
			var list:Array = _dragingGroup.toArray();
			
			var dropPoint:Point = new Point(_stage.mouseX, _stage.mouseY);
			
			var objects:Array = _stage.getObjectsUnderPoint(dropPoint);
			
			
			
			
			
			var dropHitList:Array = [];
			
			for each(var display:DisplayObject in objects)
			{
				if(display == _dragger || display == _dragIcon) continue;
				
				for each(var item:IDragDrop in list)
				{
					if(item.contains(display) && dropHitList.indexOf(item) == -1)
					{
						dropHitList.push(item);
						break;
					}
				}
			}
			
			if(dropHitList.length == 0)
			{
				return;
			}
			else if(dropHitList.length == 1)
			{
				IDragDrop(dropHitList[0]).dropHitCallback(_dragger, _transData);
			}
			else
			{
				var topDis:DisplayObject = null;
				
				for(var i:int = 0; i < dropHitList.length; i++)
				{
					if(topDis == null)
					{
						topDis = dropHitList[i] as DisplayObject;
						continue;
					}
					
					var tmpDis:DisplayObject = dropHitList[i] as DisplayObject;
					
					if(tmpDis != null && DepthUtil.isBelow(topDis, tmpDis))
					{
						topDis = tmpDis;
					}
				}
				
				IDragDrop(topDis).dropHitCallback(_dragger, _transData);
			}
			
			
			
			
			
//			var rect:Rectangle = new Rectangle();
//			
//			var tmpRect:Rectangle = new Rectangle();
//			
//			var bmd:BitmapData = new BitmapData(1, 1, true, 0);
//			
//			for each(var ddragger:IDragDrop in list)
//			{
//				rect = StageRef.getBounds(_dragger as DisplayObject);
//				
//				if(rect.containsPoint(dropPoint))
//				{
//					bmd.fillRect(bmd.rect, 0);
//					StageRef.drawTo(bmd, rect.x, rect.y);
//					var stageColor:uint = bmd.getPixel32(0, 0);
//					
//					bmd.fillRect(bmd.rect, 0);
//					var point:Point = _dragger.globalToLocal(dropPoint);
//					var matrix:Matrix = new Matrix();
//					matrix.translate(point.x, point.y);
//					bmd.draw(_dragger as IBitmapDrawable, matrix);
//					var draggerColor:uint = bmd.getPixel32(0, 0);
//					
//					if(stageColor == draggerColor)
//						ddragger.dropHitCallback(_dragger, _transData);
//				}
//			}
		}
		
		private static function __dragStartHandler(e:MouseEvent):void
		{
			if(_draging) return;// || e.currentTarget != e.target) return;
			
			_draging = true;
			
			//保存拖动数据
			_dragger = IDragDrop(e.currentTarget);
			_transData = _dragger.transData;
			_dragingGroup = getDDGroupByDragger(_dragger);
			
			//更新视图处理
			_dragIcon = _dragger.dragingIcon;
			if(_dragIcon == null)
			{
				stopDraging();
				return;
			}
			_dragStartPoint.x = _dragger.x;
			_dragStartPoint.y = _dragger.y;
			_dragStartGlobarPoint.x = _stage.mouseX;
			_dragStartGlobarPoint.y = _stage.mouseY;
			_dragIconStartPoint = _dragger.localToGlobal(Constant.ZeroPoint);
			if(_dragIcon != _dragger && _dragIcon.parent == null && _dragger.contains(_dragIcon) == false)
			{
				if(_dragIcon.parent == null)
				{
					_dragIconStartPoint.x += _dragIcon.x;
					_dragIconStartPoint.y += _dragIcon.y;
				}
				
				_dragIcon.x = _dragIconStartPoint.x;
				_dragIcon.y = _dragIconStartPoint.y;
				_stage.addChild(_dragIcon);
			}
			
			if(_dragger.lockCenter)
			{
				_dragIcon.x = _dragStartGlobarPoint.x - _dragIcon.width / 2;
				_dragIcon.y = _dragStartGlobarPoint.y - _dragIcon.height / 2;
				
				_dragIconStartPoint.x = _dragIcon.x;
				_dragIconStartPoint.y = _dragIcon.y;
				
				_dragStartPoint.x = _dragStartPoint.x - _dragIcon.width / 2;
				_dragStartPoint.y = _dragStartPoint.y - _dragIcon.height / 2;
			}
			
			//添加拖动是的事件监听
			if(_useFPS) _stage.addEventListener(Event.ENTER_FRAME, __dragingHandler);
			else _stage.addEventListener(MouseEvent.MOUSE_MOVE, __dragingHandler);
			if(e.type == MouseEvent.CLICK)
			{
				_stage.addEventListener(MouseEvent.CLICK, __dropHandler);
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
			else
			{
				_stage.addEventListener(MouseEvent.MOUSE_UP, __dropHandler);
			}
			_stage.addEventListener(Event.DEACTIVATE, __dropAbortHandler);
			_stage.addEventListener(Event.MOUSE_LEAVE, __dropAbortHandler);
			_stage.addEventListener(MouseEvent.MOUSE_OUT, __dropAbortHandler);
			//_stage.addEventListener(MouseEvent.ROLL_OUT, __dropAbortHandler);
			
			//回调
			_dragger.startDragCallback();
			
			if(_dragingGroup)
			{
				var count:int = _dragingGroup.count;
				
				for(var i:int = 0; i < count; i++)
				{
					var obj:IDragDrop = _dragingGroup.get(i);
					
					if(obj) obj.groupDragCallback(_dragger, _transData);
				}
			}
		}
		
		private static function __dragingHandler(e:Event):void
		{
			if(_dragIcon == null) return;
			
			if(_dragIcon != _dragger)
			{
				_dragIcon.x = _dragIconStartPoint.x + _stage.mouseX - _dragStartGlobarPoint.x;
				_dragIcon.y = _dragIconStartPoint.y + _stage.mouseY - _dragStartGlobarPoint.y;
			}
			else
			{
				_dragIcon.x = _dragStartPoint.x + _stage.mouseX - _dragStartGlobarPoint.x;
				_dragIcon.y = _dragStartPoint.y + _stage.mouseY - _dragStartGlobarPoint.y;
			}
			
			//回调
			_dragger.dragingCallback();
			
			if(e is MouseEvent) MouseEvent(e).updateAfterEvent();
		}
		
		private static function __dropHandler(e:MouseEvent):void
		{
			if(_dragger.reviseInStage)
			{
				if(_stage.mouseX > _stage.stageWidth)
				{
					_dragIcon.x = (_dragIcon != _dragger ? _dragIconStartPoint.x : _dragStartPoint.x) + _stage.stageWidth - _dragStartGlobarPoint.x - 5;
				}
				else if(_stage.mouseX < 0)
				{
					_dragIcon.x = (_dragIcon != _dragger ? _dragIconStartPoint.x : _dragStartPoint.x) + 0 - _dragStartGlobarPoint.x + 5;
				}
				
				if(_stage.mouseY > _stage.stageHeight)
				{
					_dragIcon.y = (_dragIcon != _dragger ? _dragIconStartPoint.y : _dragStartPoint.y) + _stage.stageHeight - _dragStartGlobarPoint.y - 5;
				}
				else if(_stage.mouseY < 0)
				{
					_dragIcon.y = (_dragIcon != _dragger ? _dragIconStartPoint.y : _dragStartPoint.y) + 0 - _dragStartGlobarPoint.y + 5;
				}
			}
			
			_dragger.dropCallback();
			
			if(_dragingGroup)
			{
				var count:int = _dragingGroup.count;
				
				for(var i:int = 0; i < count; i++)
				{
					var obj:IDragDrop = _dragingGroup.get(i);
					
					if(obj) obj.groupDropCallback(_dragger, _transData);
				}
			}
			
			checkDropHits();
			stopDraging();
			removeDragingEvent();
		}
		
		private static function __dropAbortHandler(e:Event):void
		{
			if(_dragger.isClickDrag == false) return;
			if(e.type == MouseEvent.MOUSE_OUT && MouseEvent(e).relatedObject != null) return;
			stopDraging();
			removeDragingEvent();
		}
		
		
	}
}