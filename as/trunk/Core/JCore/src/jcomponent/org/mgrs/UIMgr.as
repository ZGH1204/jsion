package jcomponent.org.mgrs
{
	import jcomponent.org.basic.ASColor;
	import jcomponent.org.basic.ASFont;
	import jcomponent.org.basic.BasicLookAndFeel;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.basic.IGroundDecorator;
	import jcomponent.org.basic.IICON;
	import jcomponent.org.basic.IUIResources;
	import jcomponent.org.basic.LookAndFeel;
	import jcomponent.org.basic.StyleTune;
	import jcomponent.org.basic.borders.IBorder;

	public class UIMgr
	{
		private static var resources:IUIResources;
		private static var lookAndFeel:LookAndFeel;
		
		public static function getLookAndFeel():LookAndFeel
		{
			checkLookAndFeel();
			return lookAndFeel;
		}
		
		public static function setLookAndFeel(laf:LookAndFeel):void
		{
			lookAndFeel = laf;
			setLookAndFeelResources(laf.getDefaults());
		}
		
		public static function getResources():IUIResources
		{
			return getLookAndFeelResources();
		}
		
		public static function getLookAndFeelResources():IUIResources
		{
			checkLookAndFeel();
			return resources;
		}
		
		public static function setLookAndFeelResources(resource:IUIResources):void
		{
			resources = resource;
		}
		
		private static function checkLookAndFeel():void
		{
			if(lookAndFeel == null)
			{
				setLookAndFeel(new BasicLookAndFeel());
			}
		}
		
		
		
		
		
		
		public static function getUI(target:Component):IComponentUI
		{
			return getResources().getUI(target);
		}
		
		public static function getBoolean(key:String):Boolean
		{
			return getResources().getBoolean(key);
		}
		
		public static function getNumber(key:String):Number
		{
			return getResources().getNumber(key);
		}
		
		public static function getInt(key:String):int
		{
			return getResources().getInt(key);
		}
		
		public static function getUint(key:String):uint
		{
			return getResources().getUint(key);
		}
		
		public static function getString(key:String):String
		{
			return getResources().getString(key);
		}
		
		public static function getBorder(key:String):IBorder
		{
			return getResources().getBorder(key);
		}
		
		public static function getIcon(key:String):IICON
		{
			return getResources().getIcon(key);
		}
		
		public static function getGroundDecorator(key:String):IGroundDecorator
		{
			return getResources().getGroundDecorator(key);
		}
		
		public static function getColor(key:String):ASColor
		{
			return getResources().getColor(key);
		}
		
		public static function getFont(key:String):ASFont
		{
			return getResources().getFont(key);
		}
		
		public static function getInsets(key:String):Insets
		{
			return getResources().getInsets(key);
		}
		
		public static function getStyleTune(key:String):StyleTune
		{
			return getResources().getStyleTune(key);
		}
		
		public static function getConstructor(key:String):Class
		{
			return getResources().getConstructor(key);
		}
		
		public static function getInstance(key:String):*
		{
			return getResources().getInstance(key);
		}
	}
}