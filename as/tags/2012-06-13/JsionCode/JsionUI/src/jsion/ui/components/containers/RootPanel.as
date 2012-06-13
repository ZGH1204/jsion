package jsion.ui.components.containers
{
	import jsion.ui.Container;
	import jsion.ui.DefaultConfigKeys;
	
	public class RootPanel extends Container
	{
		public function RootPanel(prefix:String = null, id:String=null)
		{
			super(prefix, id);
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