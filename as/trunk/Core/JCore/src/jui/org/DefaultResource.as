package jui.org
{
	import jui.org.defres.JColorUIResource;
	import jui.org.defres.JFontUIResource;
	import jui.org.defres.UIStyleTune;

	public class DefaultResource
	{
		public static const DEFAULT_BACKGROUND_COLOR:JColorUIResource = new JColorUIResource(0);
		public static const DEFAULT_FOREGROUND_COLOR:JColorUIResource = new JColorUIResource(0xFFFFFF);
		public static const DEFAULT_MIDEGROUND_COLOR:JColorUIResource = new JColorUIResource(0x1987FF);
		
		public static const DEFAULT_FONT:JFontUIResource = new JFontUIResource();
		public static const NULL_FONT:JFont = new JFont();
		
		public static const NULL_COLOR:JColor = new JColor(0, 1);
		
		public static const DEFAULT_STYLE_TUNE:UIStyleTune = new UIStyleTune();
		public static const NULL_STYLE_TUNE:StyleTune = new StyleTune(0, 0, 0);
	}
}