package jcomponent.org.coms.scrollbars
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	
	import jcore.org.ddrop.DDropMgr;
	import jcore.org.ddrop.IDragDrop;
	
	public class Thumb extends ScaleImageButton implements IDragDrop
	{
		protected var m_startPoint:IntPoint = new IntPoint();
		
		protected var m_dir:int;
		protected var m_rang:int;
		
		protected var m_minX:int = int.MIN_VALUE;
		protected var m_maxX:int = int.MAX_VALUE;
		
		protected var m_minY:int = int.MIN_VALUE;
		protected var m_maxY:int = int.MAX_VALUE;
		
		protected var m_dragingFn:Function;
		protected var m_canCallback:Boolean = true;
		
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
			check();
			
			if(m_dir == UIConstants.HORIZONTAL)
			{
				if(m_dragingFn != null && m_canCallback) m_dragingFn(x - m_startPoint.x, m_rang);
				
				if(x == m_maxX) m_canCallback = false;
				else if(x == m_minX) m_canCallback = false;
				else m_canCallback = true;
			}
			else
			{
				if(m_dragingFn != null && m_canCallback) m_dragingFn(y - m_startPoint.y, m_rang);
				
				if(y == m_maxY) m_canCallback = false;
				else if(y == m_minY) m_canCallback = false;
				else m_canCallback = true;
			}
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
			
			m_dragingFn = null;
			
			super.dispose();
		}
		
		public function check():void
		{
			if(x < m_minX) x = m_minX;
			else if(x > m_maxX) x = m_maxX;
			
			if(y < m_minY) y = m_minY;
			else if(y > m_maxY) y = m_maxY;
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

		protected function calcRect():void
		{
			if(m_dir == UIConstants.HORIZONTAL)
			{
				m_minX = m_startPoint.x;
				m_maxX = m_startPoint.x + m_rang;
				
				m_minY = m_maxY = m_startPoint.y;
			}
			else
			{
				m_minX = m_maxX = m_startPoint.x;
				
				m_minY = m_startPoint.y;
				m_maxY = m_startPoint.y + m_rang;
			}
		}

		public function get dir():int
		{
			return m_dir;
		}

		public function set dir(value:int):void
		{
			if(m_dir != value)
			{
				m_dir = value;
				
				calcRect();
			}
		}

		public function get rang():int
		{
			return m_rang;
		}

		public function set rang(value:int):void
		{
			if(m_rang != value)
			{
				m_rang = value;
				
				calcRect();
			}
		}

		public function get dragingFn():Function
		{
			return m_dragingFn;
		}

		public function set dragingFn(value:Function):void
		{
			m_dragingFn = value;
		}
		
		
	}
}