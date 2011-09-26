package jsion.ui.components.scrollbars
{
	import jsion.ui.DefaultConfigKeys;

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