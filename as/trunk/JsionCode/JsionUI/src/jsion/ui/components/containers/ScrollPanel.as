package jsion.ui.components.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.ui.Container;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.components.scrollbars.AbstractScrollBar;
	import jsion.ui.events.ComponentEvent;
	
	import jsion.utils.DisposeUtil;
	
	public class ScrollPanel extends Container
	{
		protected var m_container:Sprite;
		
		protected var m_innerSize:IntDimension = new IntDimension();
		
		protected var m_hScrollBar:AbstractScrollBar;
		
		protected var m_vScrollBar:AbstractScrollBar;
		
		protected var m_enabledHScrollBar:Boolean;
		protected var m_enabledVScrollBar:Boolean;
		
		public function ScrollPanel(prefix:String=null, id:String=null)
		{
			super(prefix, id);
			
			m_container = new Sprite();
			addChild(m_container);
		}
		
		public function setContentSize(w:int, h:int):void
		{
			if(m_hScrollBar) h += m_hScrollBar.height;
			if(m_vScrollBar) w += m_vScrollBar.width;
			
			setSizeWH(w, h);
		}
		
		public function addToContent(child:DisplayObject):DisplayObject
		{
			if(child)
			{
				m_innerSize.width = Math.max(m_innerSize.width, child.x + child.width + (m_vScrollBar == null ? 0 : m_vScrollBar.width));
				m_innerSize.height = Math.max(m_innerSize.height, child.y + child.height + (m_hScrollBar == null ? 0 : m_hScrollBar.height));
			}
			
			m_container.addChild(child);
			
			bringToTopBelowForeground(m_hScrollBar);
			bringToTopBelowForeground(m_vScrollBar);
			
			return child;
		}
		
		public function getInnerWidth():int
		{
			return m_innerSize.width;
		}
		
		public function getInnerHeight():int
		{
			return m_innerSize.height;
		}

		public function get hScrollBar():AbstractScrollBar
		{
			return m_hScrollBar;
		}

		public function set hScrollBar(value:AbstractScrollBar):void
		{
			if(m_hScrollBar != value)
			{
				if(m_hScrollBar) m_hScrollBar.removeStateListener(__hScrollBarStateChangeHandler);
				
				DisposeUtil.free(m_hScrollBar);
				
				m_hScrollBar = value;
				
				if(m_hScrollBar) m_hScrollBar.addStateListener(__hScrollBarStateChangeHandler);
				
				if(m_hScrollBar && m_hScrollBar.dir != AbstractScrollBar.HORIZONTAL) throw new Error("The hScrollBar property must be HORIZONTAL scrollbar");
				
				if(m_hScrollBar) addChild(m_hScrollBar);
				
				m_enabledHScrollBar = true;
				
				invalidate();
			}
		}
		
		protected function __hScrollBarStateChangeHandler(e:ComponentEvent):void
		{
			m_container.x = -m_hScrollBar.value;
		}

		public function get vScrollBar():AbstractScrollBar
		{
			return m_vScrollBar;
		}

		public function set vScrollBar(value:AbstractScrollBar):void
		{
			if(m_vScrollBar != value)
			{
				if(m_vScrollBar) m_vScrollBar.removeStateListener(__vScrollBarStateChangeHandler);
				
				DisposeUtil.free(m_vScrollBar);
				
				m_vScrollBar = value;
				
				if(m_vScrollBar) m_vScrollBar.addStateListener(__vScrollBarStateChangeHandler);
				
				if(m_vScrollBar && m_vScrollBar.dir != AbstractScrollBar.VERTICAL) throw new Error("The vScrollBar property must be VERTICAL scrollbar");
				
				if(m_vScrollBar)
				{
					addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
					addChild(m_vScrollBar);
				}
				else
				{
					removeEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
				}
				
				m_enabledVScrollBar = true;
				
				invalidate();
			}
		}
		
		protected function __mouseWheelHandler(e:MouseEvent):void
		{
			if(m_vScrollBar) m_vScrollBar.scroll(-e.delta * m_vScrollBar.autoScrollStep);
		}
		
		protected function __vScrollBarStateChangeHandler(e:ComponentEvent):void
		{
			m_container.y = -m_vScrollBar.value;
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicScrollPanelUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCROLL_PANEL_UI;
		}

		public function get enabledVScrollBar():Boolean
		{
			return m_enabledVScrollBar;
		}

		public function set enabledVScrollBar(value:Boolean):void
		{
			if(m_enabledVScrollBar != value)
			{
				m_enabledVScrollBar = value;
				
				invalidate();
			}
		}

		public function get enabledHScrollBar():Boolean
		{
			return m_enabledHScrollBar;
		}

		public function set enabledHScrollBar(value:Boolean):void
		{
			if(m_enabledHScrollBar != value)
			{
				m_enabledHScrollBar = value;
				
				invalidate();
			}
		}

		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
			
			if(m_hScrollBar) m_hScrollBar.removeStateListener(__hScrollBarStateChangeHandler);
			if(m_vScrollBar) m_vScrollBar.removeStateListener(__vScrollBarStateChangeHandler);
			
			DisposeUtil.free(m_hScrollBar);
			m_hScrollBar = null;
			
			DisposeUtil.free(m_vScrollBar);
			m_vScrollBar = null;
			
			DisposeUtil.free(m_container);
			m_container = null;
			
			m_innerSize = null;
			
			super.dispose();
		}
	}
}