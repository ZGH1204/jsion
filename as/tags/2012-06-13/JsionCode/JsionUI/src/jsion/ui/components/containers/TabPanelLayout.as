package jsion.ui.components.containers
{
	import jsion.*;
	import jsion.ui.Container;
	import jsion.ui.UIUtil;
	import jsion.ui.layouts.EmptyLayout;
	
	public class TabPanelLayout extends EmptyLayout
	{
		public function TabPanelLayout()
		{
			super();
		}
		
		override public function layoutContainer(target:Container):void
		{
			var tp:TabPanel = target as TabPanel;
			
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(tp.getSize());
			
			var tabsRect:IntRectangle = new IntRectangle();
			tabsRect.setSize(tp.getTabContainerSize());
			
			if(tp.tabsDir == TabPanel.LEFT || tp.tabsDir == TabPanel.RIGHT)
			{
				UIUtil.layoutPosition(viewRect, tp.tabsDir, tp.tabsVAlign, 0, tp.tabsVGap, tabsRect);
			}
			else //if(tp.tabsDir == TabPanel.TOP || tp.tabsDir == TabPanel.BOTTOM)
			{
				UIUtil.layoutPosition(viewRect, tp.tabsHAlign, tp.tabsDir, tp.tabsHGap, 0, tabsRect);
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
				tp.setPanelContainerLocation(tabsRect.x - panleSize.width - tp.tabAndPanelGap, 0);
			}
			else //if(tp.tabsDir == TabPanel.TOP)
			{
				tp.setPanelContainerLocation(0, tabsRect.y + tabsRect.height + tp.tabAndPanelGap);
			}
		}
	}
}