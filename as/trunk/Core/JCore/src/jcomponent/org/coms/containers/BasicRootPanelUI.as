package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	
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