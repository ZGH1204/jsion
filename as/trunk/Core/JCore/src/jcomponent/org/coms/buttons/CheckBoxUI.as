package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IGroundDecorator;

	public class CheckBoxUI extends BasicButtonUI
	{
		private var boxRect:IntRectangle = new IntRectangle();
		
		public function CheckBoxUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.CHECK_BOX_PRE;
		}
	}
}