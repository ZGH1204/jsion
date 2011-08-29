package jcomponent.org.basic
{
	import jcomponent.org.basic.borders.IBorder;

	public class LookAndFeel
	{
		public function getResources():IUIResources
		{
			throw new Error("Subclass should override this method to do implementation!!");
			return null;
		}
		
		public static function installColors(component:Component, prefix:String):void
		{
			var ui:IComponentUI = component.UI;
			
			var bg:ASColor = ui.getColor(prefix + DefaultConfigKeys.BACKGROUND_COLOR_RES);
			if(bg != null && bg != DefaultRes.DEFAULT_COLOR) component.backcolor = bg;
			
			var fg:ASColor = ui.getColor(prefix + DefaultConfigKeys.FOREGROUND_COLOR_RES);
			if(fg != null && bg != DefaultRes.DEFAULT_COLOR) component.forecolor = fg;
		}
		
		public static function installFonts(component:Component, prefix:String):void
		{
			var ui:IComponentUI = component.UI;
			
			var font:ASFont = ui.getFont(prefix + DefaultConfigKeys.COMPONENT_FONT_RES);
			if(font != null && font != DefaultRes.DEFAULT_FONT) component.font = font;
		}
		
		public static function installBorderAndDecorators(component:Component, prefix:String):void
		{
			var ui:IComponentUI = component.UI;
			
			var b:IBorder = ui.getBorder(prefix + DefaultConfigKeys.COMPONENT_BORDER_RES);
			if(b != null && b != DefaultRes.DEFAULT_BORDER) component.border = b;
			
			var bg:IGroundDecorator = ui.getGroundDecorator(prefix + DefaultConfigKeys.BACKGROUND_DECORATOR_RES);
			if(bg != null && bg != DefaultRes.DEFAULT_GROUNDDECORATOR) component.backgroundDecorator = bg;
			
			var fg:IGroundDecorator = ui.getGroundDecorator(prefix + DefaultConfigKeys.FOREGROUND_DECORATOR_RES);
			if(fg != null && fg != DefaultRes.DEFAULT_GROUNDDECORATOR) component.foregroundDecorator = fg;
		}
		
//		public static function uninstallBorderAndDecorators(component:Component):void
//		{
//			
//		}
	}
}