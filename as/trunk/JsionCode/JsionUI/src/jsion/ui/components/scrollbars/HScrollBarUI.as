package jsion.ui.components.scrollbars
{
	import jsion.ui.DefaultConfigKeys;

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