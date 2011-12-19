package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.comps.events.ReleaseEvent;
	import jsion.core.ddrop.DDropMgr;
	import jsion.core.ddrop.IDragDrop;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	
	[Event(name="release", type="jsion.comps.events.ReleaseEvent")]
	[Event(name="releaseOutSide", type="jsion.comps.events.ReleaseEvent")]
	public class ComSprite extends Sprite implements IDragDrop, IDispose
	{
		private var pressedTarget:DisplayObject;
		
		private var m_enableDrag:Boolean;
		
		private var m_listeners:HashMap;
		
		private var m_children:HashMap;
		
		
		
		public function ComSprite()
		{
			super();
			
			m_children = new HashMap();
			
			m_listeners = new HashMap();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
		}
		
		
		public function get enableDrag():Boolean
		{
			return m_enableDrag;
		}
		
		public function set enableDrag(value:Boolean):void
		{
			if(m_enableDrag != value)
			{
				if(m_enableDrag) DDropMgr.unregisteDrag(this);
				
				m_enableDrag = value;
				
				if(m_enableDrag) DDropMgr.registeDrag(this);
			}
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
		
		
		private function __jSpriteMouseDownListener(e:MouseEvent):void
		{
			pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, __jStageRemovedFrom);
			}
		}
		
		private function __jStageMouseUpListener(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
			
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
		
		private function __jStageRemovedFrom(e:Event):void
		{
			pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener);
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
		
		
		
		
		//==============================================		IDragDrop member		==============================================
		
		public function get isClickDrag():Boolean
		{
			return false;
		}
		
		public function get lockCenter():Boolean
		{
			return false;
		}
		
		public function set lockCenter(value:Boolean):void
		{
		}
		
		public function get transData():*
		{
			return null;
		}
		
		public function get reviseInStage():Boolean
		{
			return true;
		}
		
		public function get freeDragingIcon():Boolean
		{
			return false;
		}
		
		public function get dragingIcon():DisplayObject
		{
			return this;
		}
		
		public function startDragCallback():void
		{
		}
		
		public function dragingCallback():void
		{
		}
		
		public function dropCallback():void
		{
		}
		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		//==============================================		IDragDrop member		==============================================
		
		
		public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, __jSpriteMouseDownListener);
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, __jStageMouseUpListener, false);
				removeEventListener(Event.REMOVED_FROM_STAGE, __jStageRemovedFrom);
			}
			
			removeAllEventListeners();
			m_listeners = null;
			
			removeAllChildren();
			m_children = null;
		}
	}
}

class ListenerModel
{
	public var type:String;
	
	public var listener:Array;
	
	public var useCapture:Boolean;
}

