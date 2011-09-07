package jcomponent.org.coms.scrollbars
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class VScrollBar extends AbstractScrollBar
	{
		public function VScrollBar(value:int=0, min:int=0, max:int=100, prefix:String=null, id:String=null)
		{
			super(VERTICAL, value, min, max, prefix, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return VScrollBarUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.VSCROLL_BAR_UI;
		}
	}
}