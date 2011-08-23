package jui.org
{
	import jui.org.defres.InsetsUIResource;
	import jui.org.defres.JColorUIResource;
	import jui.org.defres.JFontUIResource;
	import jui.org.defres.UIStyleTune;

	public class EmptyUIResources
	{
		public static const BORDER:IBorder = DefaultResource.INSTANCE;
		
		public static const ICON:Icon = DefaultResource.INSTANCE;
		
		public static const CANUPDATEPROVIDER:ICanUpdateProvider = DefaultResource.INSTANCE;
		
		public static const INSETS:InsetsUIResource = new InsetsUIResource();
		
		public static const FONT:JFontUIResource = new JFontUIResource();
		
		public static const COLOR:JColorUIResource = new JColorUIResource();
		
		public static const STYLE_TUNE:UIStyleTune = new UIStyleTune();
	}
}