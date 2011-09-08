package jcomponent.org.coms.sliders
{
	import jcomponent.org.basic.DefaultConfigKeys;
	

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