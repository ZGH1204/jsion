package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	
	public class BasicTabPanelUI extends BasicComponentUI
	{
		public function BasicTabPanelUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.TABPANEL_PRE;
		}
		
		override public function install(component:Component):void
		{
			installDefaults(component);
			
			installProperties(component);
		}
		
		protected function installProperties(component:Component):void
		{
			var tp:TabPanel = TabPanel(component);
			var pp:String = getResourcesPrefix(component);
			
			tp.tabsSplitGap = getInt(pp + "tabsSplitGap");
			tp.tabAndPanelGap = getInt(pp + "tabAndPanelGap");
		}
		
		override public function uninstall(component:Component):void
		{
			
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			var tp:TabPanel = component as TabPanel;
			
			paintTabAndPanel(tp);
		}
		
		protected function paintTabAndPanel(tp:TabPanel):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(tp.getSize());
			
			var tabsRect:IntRectangle = new IntRectangle();
			tabsRect.setSize(tp.getTabContainerSize());
			
			if(tp.tabsDir == TabPanel.LEFT || tp.tabsDir == TabPanel.RIGHT)
			{
				JUtil.layoutPosition(viewRect, tp.tabsDir, tp.tabsVAlign, 0, tp.tabsVGap, tabsRect);
			}
			else //if(tp.tabsDir == TabPanel.TOP || tp.tabsDir == TabPanel.BOTTOM)
			{
				JUtil.layoutPosition(viewRect, tp.tabsHAlign, tp.tabsDir, tp.tabsHGap, 0, tabsRect);
			}
			
			tp.setTabContainerLocation(tabsRect.x, tabsRect.y);
			
			var panleSize:IntDimension = tp.getPanelContainerSize();
			
			if(tp.tabsDir == TabPanel.BOTTOM)
			{
				tp.setPanelContainerLocation(0, tabsRect.y - panleSize.height - tp.tabAndPanelGap);
			}
			else if(tp.tabsDir == TabPanel.LEFT)
			{
				tp.setPanelContainerLocation(tabsRect.x + tabsRect.width + tp.tabAndPanelGap, 0);
			}
			else if(tp.tabsDir == TabPanel.RIGHT)
			{
				tp.setPanelContainerLocation(tabsRect.x - panleSize.width - tp.tabAndPanelGap);
			}
			else //if(tp.tabsDir == TabPanel.TOP)
			{
				tp.setPanelContainerLocation(0, tabsRect.y + tabsRect.height + tp.tabAndPanelGap);
			}
		}
		
		override public function dispose():void
		{
			
			
			super.dispose();
		}
	}
}