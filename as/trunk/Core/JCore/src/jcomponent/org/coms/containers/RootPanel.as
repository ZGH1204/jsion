package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.DefaultConfigKeys;
	
	public class RootPanel extends Container
	{
		public function RootPanel(id:String=null)
		{
			super(id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicRootPanelUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.ROOT_PANEL_UI;
		}
	}
}