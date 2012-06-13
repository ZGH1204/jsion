package jsion.ui.components.containers
{
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	
	public class BasicRootPanelUI extends BasicComponentUI
	{
		public function BasicRootPanelUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			
		}
		
		override public function uninstall(component:Component):void
		{
			
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.ROOT_PANEL_PRE;
		}
	}
}