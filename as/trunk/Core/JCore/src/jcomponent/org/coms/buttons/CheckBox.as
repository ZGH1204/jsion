package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.UIConstants;

	public class CheckBox extends ToggleButton
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		
		public function CheckBox(text:String = null, iconDir:int = LEFT, prefix:String = null, id:String = null)
		{
			m_iconDir = iconDir;
			
			super(text, prefix, id);
			
			m_horizontalTextAlginment = LEFT;
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return CheckBoxUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.CHECK_BOX_UI;
		}
	}
}