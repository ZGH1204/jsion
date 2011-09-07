package jcomponent.org.coms.scrollbars
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class HScrollBarUI extends BasicScrollBarUI
	{
		public function HScrollBarUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.HSCROLL_BAR_PRE;
		}
	}
}