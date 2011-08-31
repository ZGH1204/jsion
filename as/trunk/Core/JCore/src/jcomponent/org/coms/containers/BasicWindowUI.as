package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class BasicWindowUI extends BasicRootPanelUI
	{
		public function BasicWindowUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.WINDOW_PRE;
		}
	}
}