package jsion.ui.components.sliders
{
	import jsion.ui.DefaultConfigKeys;

	public class HSlider extends AbstractSlider
	{
		public function HSlider(prefix:String=null, id:String=null)
		{
			super(HORIZONTAL, prefix, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return HSliderUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.HSLIDER_UI;
		}
	}
}