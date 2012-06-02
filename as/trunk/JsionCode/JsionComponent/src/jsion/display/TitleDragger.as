package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.ddrop.DDropMgr;
	import jsion.ddrop.IDragDrop;
	
	internal class TitleDragger extends Sprite implements IDragDrop, IDispose
	{
		private var m_window:Window;
		
		public function TitleDragger(window:Window)
		{
			m_window = window;
			
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
			return m_window;
		}
		
		public function groupDragCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function groupDropCallback(dragger:IDragDrop, data:*):void
		{
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
		
		
		
		public function drawTrigger(xPos:Number, yPos:Number, w:Number, h:Number):void
		{
			graphics.clear();
			graphics.beginFill(0x0, 0);
			graphics.drawRect(xPos, yPos, w, h);
			graphics.endFill();
		}
		
		public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			m_window = null;
		}
	}
}