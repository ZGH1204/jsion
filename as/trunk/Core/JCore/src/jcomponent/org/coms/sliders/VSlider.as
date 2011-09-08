package jcomponent.org.coms.sliders
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class VSlider extends AbstractSlider
	{
		public function VSlider(prefix:String=null, id:String=null)
		{
			super(VERTICAL, prefix, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return VSliderUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.VSLIDER_UI;
		}
	}
}