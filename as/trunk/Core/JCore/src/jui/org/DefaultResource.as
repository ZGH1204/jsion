package jui.org
{
	import flash.display.DisplayObject;
	
	import jui.org.defres.JColorUIResource;
	import jui.org.defres.JFontUIResource;
	import jui.org.defres.UIStyleTune;

	public class DefaultResource implements Icon, IBorder, ICanUpdateProvider, IUIResource
	{
		public static const INSTANCE:DefaultResource = new DefaultResource();
		
		public static const DEFAULT_BACKGROUND_COLOR:JColorUIResource = new JColorUIResource(0);
		public static const DEFAULT_FOREGROUND_COLOR:JColorUIResource = new JColorUIResource(0xFFFFFF);
		public static const DEFAULT_MIDEGROUND_COLOR:JColorUIResource = new JColorUIResource(0x1987FF);
		
		public static const DEFAULT_FONT:JFontUIResource = new JFontUIResource();
		public static const NULL_FONT:JFont = new JFont();
		
		public static const NULL_COLOR:JColor = new JColor(0, 1);
		
		public static const DEFAULT_STYLE_TUNE:UIStyleTune = new UIStyleTune();
		public static const NULL_STYLE_TUNE:StyleTune = new StyleTune(0, 0, 0);
		
		public function getDisplay(c:Component):DisplayObject
		{
			return null;
		}	
		
		/**
		 * return 0
		 */
		public function getIconWidth(c:Component):int
		{
			return 0;
		}
		
		/**
		 * return 0
		 */
		public function getIconHeight(c:Component):int
		{
			return 0;
		}
		
		/**
		 * do nothing
		 */
		public function updateIcon(com:Component, g:Graphics2D, x:int, y:int):void
		{
		}	
		
		
		/**
		 * do nothing
		 */
		public function updateBorder(com:Component, g:Graphics2D, bounds:IntRectangle):void
		{
		}
		
		/**
		 * return new Insets(0,0,0,0)
		 */
		public function getBorderInsets(com:Component, bounds:IntRectangle):Insets
		{
			return new Insets(0,0,0,0);
		}
		
		/**
		 * do nothing
		 */
		public function update(com:Component, g:Graphics2D, bounds:IntRectangle):void
		{
		}
	}
}