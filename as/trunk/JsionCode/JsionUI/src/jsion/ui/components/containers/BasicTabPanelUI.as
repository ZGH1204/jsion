package jsion.ui.components.containers
{
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	
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
			
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var tp:TabPanel = component as TabPanel;
			
			var rlt:IntDimension = new IntDimension();
			var tabSize:IntDimension = tp.getTabContainerSize();
			
			rlt.setSize(tp.pSize);
			
			if(tp.tabsDir == TabPanel.LEFT || tp.tabsDir == TabPanel.RIGHT)
			{
				rlt.width += tabSize.width;
				rlt.width += tp.tabAndPanelGap;
			}
			else //if(tp.tabsDir == TabPanel.TOP || tp.tabsDir == TabPanel.BOTTOM)
			{
				rlt.height += tabSize.height;
				rlt.height += tp.tabAndPanelGap;
			}
			
			return rlt;
		}
		
		override public function dispose():void
		{
			
			
			super.dispose();
		}
	}
}