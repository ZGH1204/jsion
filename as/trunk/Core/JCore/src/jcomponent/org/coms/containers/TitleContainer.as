package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import jcore.org.ddrop.DDropMgr;
	import jcore.org.ddrop.IDragDrop;
	
	public class TitleContainer extends Sprite implements IDragDrop, IDispose
	{
		protected var m_win:Window;
		
		public function TitleContainer(win:Window)
		{
			m_win = win;
			
			DDropMgr.registeDrag(this);
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
			return m_win;
		}
		
//		override public function get x():Number
//		{
//			return m_win.x;
//		}
//		
//		override public function set x(value:Number):void
//		{
//			m_win.x = value;
//		}
//		
//		override public function get y():Number
//		{
//			return m_win.y;
//		}
//		
//		override public function set y(value:Number):void
//		{
//			m_win.y = value;
//		}
		
		override public function localToGlobal(point:Point):Point
		{
			return m_win.localToGlobal(point);
		}
		
		override public function globalToLocal(point:Point):Point
		{
			return m_win.globalToLocal(point);
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
		
		public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			m_win = null;
		}
	}
}