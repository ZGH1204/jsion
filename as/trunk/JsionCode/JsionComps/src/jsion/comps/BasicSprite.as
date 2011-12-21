package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.comps.events.ReleaseEvent;
	import jsion.comps.events.UIEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	[Event(name="resize", type="jsion.comps.events.UIEvent")]
	[Event(name="draw", type="jsion.comps.events.UIEvent")]
	[Event(name="release", type="jsion.comps.events.ReleaseEvent")]
	[Event(name="releaseOutSide", type="jsion.comps.events.ReleaseEvent")]
	public class BasicSprite extends Sprite implements IDispose
	{
		private var pressedTarget:DisplayObject;
		
		private var m_width:Number = 0;
		
		private var m_height:Number = 0;
		
		private var m_listeners:HashMap;
		
		private var m_children:HashMap;
		
		private var m_enabled:Boolean;
		
		private var m_stopPropagation:Boolean;
		
		
		public function BasicSprite()
		{
			m_enabled = true;
			
			m_children = new HashMap();
			
			m_listeners = new HashMap();
			
			super();
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
			
			addEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
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
				}
			}
		}
		
		public function removeAllChildren():void
		{
			if(m_children == null) return;
			
			var list:Array = m_children.getValues();
			
			m_children.removeAll();
			
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
		
		public function pack():void
		{
			setSize(originalWidth, originalHeight);
		}
		
		//==========================================		覆盖重写方法			==========================================
		
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
			
			var model:ListenerModel = m_listeners.get(str);
			
			if(model != null)
			{
				ArrayUtil.remove(model.listener, listener);
				
				if(model.listener.length == 0) m_listeners.remove(str);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			
			m_children.put(child, child);
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			
			m_children.put(child, child);
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			
			m_children.remove(child);
			
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			
			m_children.remove(child);
			
			return child;
		}
		
		//==========================================		覆盖重写方法			==========================================
		
		
		
		
		
		
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
				alpha = m_enabled ? 1.0 : 0.5;
			}
		}
		
		
		public function get originalWidth():Number
		{
			return super.width;
		}
		
		public function get originalHeight():Number
		{
			return super.height;
		}
		
		
		public function get stopPropagation():Boolean
		{
			return m_stopPropagation;
		}
		
		public function set stopPropagation(value:Boolean):void
		{
			m_stopPropagation = value;
		}
		
		
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		public function move(xPos:Number, yPos:Number):void
		{
			x = xPos;
			y = yPos;
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set width(value:Number):void
		{
			if(m_width != value && value > 0)
			{
				m_width = value;
				invalidate();
				dispatchEvent(new UIEvent(UIEvent.RESIZE));
			}
		}
		
		override public function get height():Number
		{
			return m_height;
		}
		
		override public function set height(value:Number):void
		{
			if(m_height != value && value > 0)
			{
				m_height = value;
				invalidate();
				dispatchEvent(new UIEvent(UIEvent.RESIZE));
			}
		}
		
		public function get autoPack():Boolean
		{
			return true;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(w > 0 && h > 0 && (w != m_width || h != m_height))
			{
				m_width = w;
				m_height = h;
				dispatchEvent(new UIEvent(UIEvent.RESIZE));
				invalidate();
			}
		}
		
		
		
		
		
		private function __spriteMouseDownListener(e:MouseEvent):void
		{
			pressedTarget = e.target as DisplayObject;
			
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
			
			pressedTarget = null;
		}
		
		private function __stageRemovedFrom(e:Event):void
		{
			pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener);
		}
		
		
		
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(stopPropagation)
			{
				e.stopPropagation();
			}
		}
		
		
		
		
		
		
		
		protected function invalidate():void
		{
			addEventListener(Event.ENTER_FRAME, __invalidate);
		}
		
		private function __invalidate(e:Event):void
		{
			drawAtOnce();
		}
		
		public function drawAtOnce():void
		{
			removeEventListener(Event.ENTER_FRAME, __invalidate);
			draw();
		}
		
		public function draw():void
		{
			//if(autoPack) pack();
			
			dispatchEvent(new UIEvent(UIEvent.DRAW));
		}
		
		
		
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		
		
		
		
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener, false);
				removeEventListener(Event.REMOVED_FROM_STAGE, __stageRemovedFrom);
			}
			
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(Event.ENTER_FRAME, __invalidate);
			
			removeAllEventListeners();
			m_listeners = null;
			
			removeAllChildren();
			m_children = null;
			
			pressedTarget = null;
		}
	}
}

class ListenerModel
{
	public var type:String;
	
	public var listener:Array;
	
	public var useCapture:Boolean;
}

