package jsion.ui.components.sliders
{
	import jsion.ui.DefaultConfigKeys;
	

	public class HSliderUI extends BasicSliderUI
	{
		public function HSliderUI()
		{
			super();
		}
		
		
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.HSLIDER_PRE;
		}
	}
}