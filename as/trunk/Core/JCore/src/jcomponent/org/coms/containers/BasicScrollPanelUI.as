package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.coms.scrollbars.AbstractScrollBar;
	import jcomponent.org.coms.scrollbars.HScrollBar;
	import jcomponent.org.coms.scrollbars.VScrollBar;
	
	public class BasicScrollPanelUI extends BasicComponentUI
	{
		protected static const DEFAULT_WIDTH:int = 200;
		protected static const DEFAULT_HEIGHT:int = 200;
		
		public function BasicScrollPanelUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCROLL_PANEL_PRE;
		}
		
		
		override public function install(component:Component):void
		{
			var panel:ScrollPanel = ScrollPanel(component);
			
			installDefaults(panel);
		}
		
		override public function uninstall(component:Component):void
		{
			dispose();
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			var panel:ScrollPanel = ScrollPanel(component);
			
			paintScrollBar(panel);
			
			locateScrollBar(panel);
		}
		
		protected function paintScrollBar(panel:ScrollPanel):void
		{
			var pp:String;
			var bar:AbstractScrollBar;
			
			if(panel.enabledHScrollBar)
			{
				if(panel.hScrollBar == null)
				{
					pp = getResourcesPrefix(panel);
					
					var hScrollBarPre:String = getString(pp + DefaultConfigKeys.SCROLL_PANEL_HSCROLL_BAR);
					
					bar = new HScrollBar(0, 0, 100, hScrollBarPre);
					bar.pack();
					
					panel.hScrollBar = bar;
				}
			}
			else
			{
				panel.hScrollBar = null;
			}
			
			if(panel.enabledVScrollBar)
			{
				if(panel.vScrollBar == null)
				{
					pp = getResourcesPrefix(panel);
					
					var vScrollBarPre:String = getString(pp + DefaultConfigKeys.SCROLL_PANEL_VSCROLL_BAR);
					
					bar = new VScrollBar(0, 0, 100, vScrollBarPre);
					bar.pack();
					
					panel.vScrollBar = bar;
				}
			}
			else
			{
				panel.vScrollBar = null;
			}
		}
		
		protected function locateScrollBar(panel:ScrollPanel):void
		{
			var vBar:AbstractScrollBar = panel.vScrollBar;
			
			var hBar:AbstractScrollBar = panel.hScrollBar;
			
			if(vBar)
			{
				vBar.x = panel.width - vBar.width;
				vBar.y = 0;
				
				if(hBar)
				{
					vBar.height = panel.height - hBar.height;
					
					vBar.scrollLength = panel.getInnerHeight() - hBar.height;
				}
				else
				{
					vBar.height = panel.height;
					
					vBar.scrollLength = panel.getInnerHeight();
				}
			}
			
			if(hBar)
			{
				hBar.x = 0;
				hBar.y = panel.height - hBar.height;
				
				if(vBar)
				{
					hBar.width = panel.width - vBar.width;
					
					hBar.scrollLength = panel.getInnerWidth() - vBar.width;
				}
				else
				{
					hBar.width = panel.width;
					
					hBar.scrollLength = panel.getInnerWidth();
				}
			}
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var s:IntDimension = new IntDimension();
			
			var panel:ScrollPanel = ScrollPanel(component);
			
			if(panel.vScrollBar)
			{
				s.width = Math.max(DEFAULT_WIDTH, panel.getInnerWidth());
				s.height = panel.vScrollBar.height;
			}
			
			if(panel.hScrollBar)
			{
				s.width = panel.hScrollBar.width;
				s.height = Math.max(DEFAULT_HEIGHT, panel.getInnerHeight());
			}
			
			if(s.width <= 0) s.width = DEFAULT_WIDTH;
			if(s.height <= 0) s.height = DEFAULT_HEIGHT;
			
			return s;
		}
	}
}