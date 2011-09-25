package jsion.core.ddrop
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DDropHelper implements IDragDrop, IDispose
	{
		protected var m_trigger:DisplayObject;
		protected var m_dragger:DisplayObject;
		
		protected var m_dragData:*;
		
		public function DDropHelper(trigger:DisplayObject, dragger:DisplayObject, dragData:* = null)
		{
			m_trigger = trigger;
			m_dragger = dragger;
			m_dragData = dragData;
		}
		
		public function get x():Number
		{
			return m_dragger.x;
		}
		
		public function set x(value:Number):void
		{
		}
		
		public function get y():Number
		{
			return m_dragger.y;
		}
		
		public function set y(value:Number):void
		{
		}
		
		public function get width():Number
		{
			return m_dragger.width;
		}
		
		public function get height():Number
		{
			return m_dragger.height;
		}
		
		public function contains(child:DisplayObject):Boolean
		{
			return false;
		}
		
		public function localToGlobal(point:Point):Point
		{
			return m_dragger.localToGlobal(point);
		}
		
		public function globalToLocal(point:Point):Point
		{
			return m_dragger.globalToLocal(point);
		}
		
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
			return m_dragData;
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
			return m_dragger;
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
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			m_trigger.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			m_trigger.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return m_trigger.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return m_trigger.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return m_trigger.willTrigger(type);
		}
		
		
		
		public function dispose():void
		{
			m_trigger = null;
			m_dragger = null;
		}
	}
}