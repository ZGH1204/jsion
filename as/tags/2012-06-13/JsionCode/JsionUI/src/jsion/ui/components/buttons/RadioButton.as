package jsion.ui.components.buttons
{
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.UIConstants;

	public class RadioButton extends ToggleButton
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		public function RadioButton(text:String = null, textDir:int = LEFT, prefix:String = null, id:String = null)
		{
			m_iconDir = iconDir;
			
			super(text, prefix, id);
			
			m_horizontalTextAlginment = LEFT;
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