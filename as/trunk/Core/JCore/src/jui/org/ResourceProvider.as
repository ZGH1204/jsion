package jui.org
{
	import jui.org.errors.ImpMissError;

	public class ResourceProvider implements IDispose
	{
		public function getDefaults():UIDefaults
		{
			throw new ImpMissError();
			return null;
		}
		
		public static function installColors(component:Component, componentUIPrefix:String, 
											 	defaultBgName:String = DefaultUI.DefaultBackgroundName, 
												defaultFgName:String = DefaultUI.DefaultForegroundName, 
												defaultMgName:String = DefaultUI.DefaultMidegroundName):void
		{
			if(component == null) return;
			
			var bgc:JColor = component.getBackground();
			
			if(bgc == null || bgc is IUIResource)
			{
				component.setBackground(component.getUI().getColor(componentUIPrefix + defaultBgName));
			}
			
			var fgc:JColor = component.getForeground();
			
			if(fgc == null || fgc is IUIResource)
			{
				component.setForeground(component.getUI().getColor(componentUIPrefix + defaultFgName));
			}
			
			var mgc:JColor = component.getMideground();
			
			if(mgc == null || mgc is IUIResource)
			{
				component.setBackground(component.getUI().getColor(componentUIPrefix + defaultMgName));
			}
		}
		
		public static function installFonts(component:Component, componentUIPrefix:String, defaultFontName:String = DefaultUI.DefaultFontName):void
		{
			if(component == null) return;
			
			var f:JFont = component.getFont();
			
			if(f == null || f is IUIResource)
			{
				component.setFont(component.getUI().getFont(componentUIPrefix + defaultFontName));
			}
		}
		
		public static function installStyleTune(component:Component, componentUIPrefix:String, defaultCaName:String = DefaultUI.DefaultStyleTuneName):void
		{
			if(component == null) return;
			
			var st:StyleTune = component.getStyleTune();
			
			if(st == null || st is IUIResource)
			{
				component.setStyleTune(component.getUI().getStyleTune(componentUIPrefix + defaultCaName));
			}
		}
		
		public static function installCorlorsAndFonts(component:Component, componentUIPrefix:String, 
													  	 defaultBgName:String = DefaultUI.DefaultBackgroundName, 
														 defaultFgName:String = DefaultUI.DefaultForegroundName, 
														 defaultMgName:String = DefaultUI.DefaultMidegroundName, 
														 defaultFontName:String = DefaultUI.DefaultFontName, 
														 defaultCaName:String = DefaultUI.DefaultStyleTuneName):void
		{
			installColors(component, componentUIPrefix, defaultBgName, defaultFgName, defaultMgName);
			
			installFonts(component, componentUIPrefix, defaultFontName);
			
			installStyleTune(component, componentUIPrefix, defaultCaName);
		}
		
		
		public static function installBorderAndBFProvider(component:Component, componentUIPrefix:String, 
														  	 defaultBorderName:String = DefaultUI.DefaultBorderName, 
															 defaultBackgroundProviderName:String = DefaultUI.DefaultBackgroundProviderName, 
															 defaultForegroundProviderName:String = DefaultUI.DefaultForegroundProviderName):void
		{
			if(component == null) return;
			
			var b:IBorder = component.getBorder();
			
			if(b is IUIResource)
			{
				component.setBorder(component.getUI().getBorder(componentUIPrefix + defaultBorderName));
			}
			
			var bg:ICanUpdateProvider = component.getBackgroundProvider();
			
			if(bg is IUIResource)
			{
				component.setBackgroundProvider(component.getUI().getCanUpdateProvider(componentUIPrefix + defaultBackgroundProviderName));
			}
			
			var fg:ICanUpdateProvider = component.getForegroundProvider();
			
			if(fg is IUIResource)
			{
				component.setForegroundProvider(component.getUI().getCanUpdateProvider(componentUIPrefix + defaultForegroundProviderName));
			}
		}
		
		public static function uninstallBorderAndBFProvider(component:Component):void
		{
			if(component == null) return;
			
			if(component.getBorder() is IUIResource)
			{
				component.setBorder(DefaultResource.INSTANCE);
			}
			
			if(component.getBackgroundProvider() is IUIResource)
			{
				component.setBackgroundProvider(DefaultResource.INSTANCE);
			}
			
			if(component.getForegroundProvider() is IUIResource)
			{
				component.setForegroundProvider(DefaultResource.INSTANCE);
			}
		}
		
		
		public function dispose():void
		{
			
		}
	}
}