package jsion.ui.components.buttons
{
	import jsion.*;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IGroundDecorator;

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