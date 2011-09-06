package jcomponent.org.coms.scrollbars
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.coms.buttons.ScaleImageButton;
	
	import jcore.org.ddrop.DDropMgr;
	import jcore.org.ddrop.IDragDrop;
	
	public class Thumb extends ScaleImageButton implements IDragDrop
	{
		protected var m_startPoint:IntPoint = new IntPoint();
		
		protected var m_rect:IntRectangle = new IntRectangle();
		
		protected var m_minX:int = int.MIN_VALUE;
		protected var m_maxX:int = int.MAX_VALUE;
		
		protected var m_minY:int = int.MIN_VALUE;
		protected var m_maxY:int = int.MAX_VALUE;
		
		public function Thumb(prefix:String=null, id:String=null)
		{
			super(null, prefix, id);
			
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
			return false;
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
			if(x < m_minX) x = m_minX;
			else if(x > m_maxX) x = m_maxX;
			
			if(y < m_minY) y = m_minY;
			else if(y > m_maxY) y = m_maxY;
		}
		
		public function dropCallback():void
		{
		}
		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		override public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			super.dispose();
		}

		public function get startPoint():IntPoint
		{
			return m_startPoint;
		}

		public function set startPoint(value:IntPoint):void
		{
			if(value && !value.equals(m_startPoint))
			{
				m_startPoint = value;
				
				calcRect();
			}
		}

		public function get rect():IntRectangle
		{
			return m_rect;
		}

		public function set rect(value:IntRectangle):void
		{
			if(value && !value.equals(m_rect))
			{
				m_rect = value;
				
				calcRect();
			}
		}

		protected function calcRect():void
		{
			if(m_rect && (m_rect.width != 0 || m_rect.height != 0))
			{
				m_minX = m_startPoint.x + m_rect.x;
				m_maxX = m_startPoint.x + m_rect.x;
				m_maxX += m_rect.width;
				
				m_minY = m_startPoint.y + m_rect.y;
				m_maxY = m_startPoint.y + m_rect.y;
				m_maxY += m_rect.height;
			}
		}
	}
}