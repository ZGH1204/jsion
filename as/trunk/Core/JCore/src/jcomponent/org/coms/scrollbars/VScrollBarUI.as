package jcomponent.org.coms.scrollbars
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class VScrollBarUI extends BasicScrollBarUI
	{
		public function VScrollBarUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.VSCROLL_BAR_PRE;
		}
	}
}