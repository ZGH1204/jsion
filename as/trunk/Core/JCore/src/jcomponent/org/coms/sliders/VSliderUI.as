package jcomponent.org.coms.sliders
{
	import jcomponent.org.basic.DefaultConfigKeys;
	

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