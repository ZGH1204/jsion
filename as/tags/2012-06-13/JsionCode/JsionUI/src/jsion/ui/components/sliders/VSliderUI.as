package jsion.ui.components.sliders
{
	import jsion.ui.DefaultConfigKeys;
	

	public class VSliderUI extends BasicSliderUI
	{
		public function VSliderUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.VSLIDER_PRE;
		}
	}
}