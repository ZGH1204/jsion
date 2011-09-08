package jcomponent.org.coms.scrollbars
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class HScrollBar extends AbstractScrollBar
	{
		public function HScrollBar(value:int=0, min:int=0, max:int=100, prefix:String=null, id:String=null)
		{
			super(HORIZONTAL, value, min, max, prefix, id);
		}
		
		
		
		override public function getUIDefaultBasicClass():Class
		{
			return HScrollBarUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.HSCROLL_BAR_UI;
		}
	}
}