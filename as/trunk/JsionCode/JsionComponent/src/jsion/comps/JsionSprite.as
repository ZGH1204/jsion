package jsion.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.events.ReleaseEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	[Event(name="release", type="jsion.events.ReleaseEvent")]
	[Event(name="releaseOutSide", type="jsion.events.ReleaseEvent")]
	public class JsionSprite extends Sprite implements IDispose
	{
		/**
		 * ReleaseEvent中间变量
		 */		
		private var m_pressedTarget:DisplayObject;
		
		/**
		 * 保存监听本对象事件的监听信息
		 */		
		private var m_listeners:HashMap;
		
		/**
		 * 添加到本显示对象上的所有子显示对象列表
		 */		
		private var m_children:HashMap;
		
		/**
		 * 是否启用本对象的鼠标事件
		 */		
		private var m_enabled:Boolean;
		
		
		
		//========	update state model	========
		
		private var m_model:StateModel;
		
		private var m_rolloverEnabled:Boolean;
		
		//========	update state model	========
		
		
		
		//============  忽略透明像素  ============
		
		private var m_mousePoint:Point;
		
		private var m_bitmapForHit:Bitmap;
		
		private var m_enterFraming:Boolean;
		
		private var m_hited:Boolean;
		
		private var m_threshold:int = 128;
		
		private var m_ignoreTransparents:Boolean;
		
		//============  忽略透明像素  ============
		
		
		public function JsionSprite()
		{
			super();
			
			m_enabled = true;
			
			m_children = new HashMap();
			
			m_listeners = new HashMap();
			
			m_rolloverEnabled = true;
			
			m_mousePoint = new Point();
			
			m_model = new StateModel();
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
			addEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
		}
		
		
		
		
		public function removeAllEventListeners():void
		{
			if(m_listeners == null) return;
			
			var list:Array = m_listeners.getValues();
			
			while(list.length > 0)
			{
				var model:ListenerModel = list.pop() as ListenerModel;
				
				for each(var fn:Function in model.listener)
				{
					removeEventListener(model.type, fn, model.useCapture);
					
					DisposeUtil.free(model);
				}
			}
		}
		
		public function removeChildren():void
		{
			if(m_children == null) return;
			
			var list:Array = m_children.getValues();
			
			for each(var obj:DisplayObject in list)
			{
				removeChild(obj);
			}
		}
		
		public function removeAndFreeChildren():void
		{
			if(m_children == null) return;
			
			var list:Array = m_children.getValues();
			
			DisposeUtil.free(list);
		}
		
		public function bring2Top():void
		{
			DepthUtil.bringToTop(this);
		}
		
		public function bring2Bottom():void
		{
			DepthUtil.bringToBottom(this);
		}
		
		//==========================================		保存事件监听信息			==========================================
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var str:String = type + useCapture;
			
			var model:ListenerModel;
			
			if(m_listeners.containsKey(str))
			{
				model = m_listeners.get(str);
				if(ArrayUtil.containsValue(model.listener, listener) == false)
					model.listener.push(listener);
			}
			else
			{
				model = new ListenerModel();
				
				model.type = type;
				model.listener = [];
				model.listener.push(listener);
				model.useCapture = useCapture;
				
				m_listeners.put(str, model);
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			var str:String = type + useCapture;
			
			if(m_listeners)
			{
				var model:ListenerModel = m_listeners.get(str);
				
				if(model != null)
				{
					ArrayUtil.remove(model.listener, listener);
					
					if(model.listener.length == 0) m_listeners.remove(str);
				}
			}
		}
		
		//==========================================		保存事件监听信息			==========================================
		
		
		
		//==========================================		保存子显示对象		==========================================
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			super.addChild(child);
			
			m_children.put(child, child);
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child == null) return null;
			
			super.addChildAt(child, index);
			
			m_children.put(child, child);
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			super.removeChild(child);
			
			m_children.remove(child);
			
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			if(index < 0 || index >= numChildren) return null;
			
			var child:DisplayObject = super.removeChildAt(index);
			
			m_children.remove(child);
			
			return child;
		}
		
		//==========================================		保存子显示对象		==========================================
		
		
		
		
		
		//==========================================		是否启用本对象的鼠标事件		 ==========================================
		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(m_enabled != value)
			{
				m_enabled = value;
				mouseEnabled = mouseChildren = m_enabled;
				tabEnabled = m_enabled;
			}
			
			
			if(m_model.rollOver && value == false)
			{
				m_model.rollOver = false;
			}
			
			m_model.enabled = value;
		}
		
		//==========================================		是否启用本对象的鼠标事件		 ==========================================
		
		
		
		
		//==========================================		ReleaseEvent实现		 ==========================================
		
		private function __spriteMouseDownListener(e:MouseEvent):void
		{
			m_pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, __stageRemovedFrom);
			}
		}
		
		private function __stageMouseUpListener(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener);
			
			var isOutSide:Boolean = false;
			var target:DisplayObject = e.target as DisplayObject;
			
			if(!(this == target || CompUtil.isAncestorDisplayObject(this, target)))
			{
				isOutSide = true;
			}
			
			dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE, isOutSide, e));
			
			if(isOutSide)
			{
				dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE_OUT_SIDE, isOutSide, e));
			}
			
			m_pressedTarget = null;
		}
		
		private function __stageRemovedFrom(e:Event):void
		{
			m_pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener);
		}
		
		//==========================================		ReleaseEvent实现		 ==========================================
		
		
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, dist, dist, .3, 1, knockout);
		}
		
		
		
		
		
		
		//==================================================		update state model			==================================================
		
		public function get model():StateModel
		{
			return m_model;
		}
		
		public function set model(value:StateModel):void
		{
			m_model = value;
		}
		
		public function get rolloverEnabled():Boolean
		{
			return m_rolloverEnabled;
		}
		
		public function set rolloverEnabled(value:Boolean):void
		{
			m_rolloverEnabled = value;
		}
		
		public function hitTestMouse():Boolean
		{
			if(stage)
				return hitTestPoint(stage.mouseX, stage.mouseY);
			
			return false;
		}
		
		private function __rollOverHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed || !e.buttonDown)
				{
					m_model.rollOver = true;
				}
			}
			
			if(m_model.pressed) m_model.armed = true;
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(rolloverEnabled && hitTestMouse())
			{
				m_model.rollOver = true;
			}
		}
		
		private function __rollOutHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed == false)
				{
					m_model.rollOver = false;
				}
			}
			
			m_model.armed = false;
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			m_model.armed = true;
			m_model.pressed = true;
		}
		
		private function __releaseHandler(e:ReleaseEvent):void
		{
			m_model.pressed = false;
			m_model.armed = false;
			
			if(rolloverEnabled && !hitTestMouse())
			{
				m_model.rollOver = false;
			}
		}
		
		//==================================================		update state model			==================================================
		
		
		
		
		
		
		
		
		
		
		
		//==============================================		忽略透明像素			==============================================
		
		public function get ignoreTransparents():Boolean
		{
			return m_ignoreTransparents;
		}
		
		public function set ignoreTransparents(value:Boolean):void
		{
			if(m_ignoreTransparents != value)
			{
				m_ignoreTransparents = value;
				
				DisposeUtil.free(m_bitmapForHit);
				m_bitmapForHit = null;
				
				if(m_ignoreTransparents)
				{
					m_hited = false;
					m_enterFraming = false;
					mouseEnabled = true;
					
					buttonMode = false;
					
					activateMouseTrap();
				}
				else
				{
					deactivateMouseTrap();
					removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
					removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				}
			}
		}
		
		public function get threshold():int
		{
			return m_threshold;
		}
		
		public function set threshold(value:int):void
		{
			m_threshold = Math.min(value, 255);
		}
		
		protected function activateMouseTrap():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent, false, int.MAX_VALUE);
		}
		
		protected function deactivateMouseTrap():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent);
		}
		
		private function __captureMouseEvent(e:MouseEvent):void
		{
			if(m_enterFraming == false && (e.type == MouseEvent.MOUSE_OVER || e.type == MouseEvent.ROLL_OVER))
			{
				m_enterFraming = true;
				mouseEnabled = false;
				addEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				__trackMouseWhileInBounds();
				addEventListener(MouseEvent.MOUSE_UP, __upHandler);
			}
			
			if(!m_hited)
			{
				//trace("stopImmediatePropagation", e.type);
				e.stopImmediatePropagation();
			}
		}
		
		private function __upHandler(e:MouseEvent):void
		{
			if(m_model && m_model.rollOver == false && bitmapHitTest())
			{
				m_hited = true;
				buttonMode = true;
				mouseEnabled = true;
				deactivateMouseTrap();
				dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
			}
		}
		
		private function __trackMouseWhileInBounds(e:Event = null):void
		{
			if(bitmapHitTest() != m_hited)
			{
				m_hited = !m_hited;
				
				if(m_hited)
				{
					buttonMode = true;
					mouseEnabled = true;
					deactivateMouseTrap();
					
					if(m_model.rollOver == false)
					{
						dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
						dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
					}
				}
				else
				{
					mouseEnabled = false;
					
					buttonMode = false;
					
					if(m_model.rollOver)
					{
						dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
						dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
					}
				}
			}
			
			var globalPoint:Point = m_bitmapForHit.localToGlobal(m_mousePoint);
			if(hitTestPoint(globalPoint.x, globalPoint.y) == false)
			{
				removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
				removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				m_enterFraming = false;
				mouseEnabled = true;
				activateMouseTrap();
			}
		}
		
		protected function bitmapHitTest():Boolean
		{
			if(m_bitmapForHit == null) drawBitmapHit();
			
			m_mousePoint.x = m_bitmapForHit.mouseX;
			m_mousePoint.y = m_bitmapForHit.mouseY;
			
			return m_bitmapForHit.bitmapData.hitTest(CompGlobal.ZeroPoint, m_threshold, m_mousePoint);
		}
		
		protected function drawBitmapHit():void
		{
			if(m_bitmapForHit)
			{
				DisposeUtil.free(m_bitmapForHit);
			}
			
			var b:Rectangle = getBounds(this);
			
			var bmd:BitmapData = new BitmapData(b.width, b.height, true, 0);
			var mx:Matrix = new Matrix();
			mx.translate(-b.left, -b.top);
			bmd.draw(this);
			
			m_bitmapForHit = new Bitmap(bmd);
			m_bitmapForHit.visible = false;
			addChild(m_bitmapForHit);
			m_bitmapForHit.x = b.left;
			m_bitmapForHit.y = b.top;
		}
		
		//==============================================		忽略透明像素			==============================================
		
		
		
		
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
			removeEventListener(Event.REMOVED_FROM_STAGE, __stageRemovedFrom);
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener, false);
			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
			removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
			
			deactivateMouseTrap();
			
			removeAllEventListeners();
			DisposeUtil.free(m_listeners);
			m_listeners = null;
			
			DisposeUtil.free(m_children);
			m_children = null;
			
			DisposeUtil.free(m_model);
			m_model = null;
			
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			m_pressedTarget = null;
			m_mousePoint = null;
		}
	}
}
import jsion.IDispose;
import jsion.utils.ArrayUtil;

class ListenerModel implements IDispose
{
	public var type:String;
	
	public var listener:Array;
	
	public var useCapture:Boolean;
	
	public function dispose():void
	{
		ArrayUtil.removeAll(listener);
		listener = null;
	}
}

