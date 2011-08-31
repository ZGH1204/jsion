package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.UIConstants;

	public class RadioButton extends CheckBox
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		public function RadioButton(text:String = null, textDir:int = LEFT, prefix:String = null, id:String = null)
		{
			super(text, textDir, prefix, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return RadioButtonUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.CHECK_BOX_UI;
		}
	}
}