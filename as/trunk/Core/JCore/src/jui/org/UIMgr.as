package jui.org
{
	public class UIMgr
	{
		private static var provider:ResourceProvider;
		private static var providerDefaults:UIDefaults;
		
		public static function getProvider():ResourceProvider
		{
			return provider;
		}
		
		public static function setProvider(p:ResourceProvider):void
		{
			provider = p;
			setProviderDefaults(p.getDefaults());
		}
		
		public static function getDefaults():UIDefaults
		{
			return getProviderDefaults();
		}
		
		public static function getProviderDefaults():UIDefaults
		{
			checkProvider();
			return providerDefaults;
		}
		
		private static function setProviderDefaults(ud:UIDefaults):void
		{
			providerDefaults = ud;
		}
		
		private static function checkProvider():void
		{
			if(provider == null)
			{
				setProvider(new BasicProvider());
			}
		}
		
		
		
		
		
		
		
		
		
		
		public static function getConstructor(key:String):Class
		{
			return getDefaults().getConstructor(key);
		}
		
		public static function getInstance(key:String):*
		{
			return getDefaults().getInstance(key);
		}
		
		public static function getBoolean(key:String):Boolean
		{
			return getDefaults().getBoolean(key);
		}
		
		public static function getNumber(key:String):Number
		{
			return getDefaults().getNumber(key);
		}
		
		public static function getInt(key:String):int
		{
			return getDefaults().getInt(key);
		}
		
		public static function getUint(key:String):uint
		{
			return getDefaults().getUint(key);
		}
		
		public static function getString(key:String):String
		{
			return getDefaults().getString(key);
		}
		
		public static function getUI(target:Component):IComponentUI
		{
			return getDefaults().getUI(target);
		}
		
		public static function getBorder(key:String):IBorder
		{
			return getDefaults().getBorder(key);
		}
		
		public static function getIcon(key:String):Icon
		{
			return getDefaults().getIcon(key);
		}
		
		public static function getCanUpdateProvider(key:String):ICanUpdateProvider
		{
			return getDefaults().getCanUpdateProvider(key);
		}
		
		public static function getColor(key:String):JColor
		{
			return getDefaults().getColor(key);
		}
		
		public static function getFont(key:String):JFont
		{
			return getDefaults().getFont(key);
		}
		
		public static function getInsets(key:String):Insets
		{
			return getDefaults().getInsets(key);
		}
		
		public static function getStyleTune(key:String):StyleTune
		{
			return getDefaults().getStyleTune(key);
		}
	}
}