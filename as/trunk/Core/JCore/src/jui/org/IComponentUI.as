package jui.org
{
	public interface IComponentUI extends IDispose
	{
		function installUI(component:Component):void;
		
		function uninstallUI(component:Component):void;
		
		function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void;
		
		function getPreferredSize(c:Component):IntDimension;
		
		function getMinimumSize(c:Component):IntDimension;
		
		function getMaximumSize(c:Component):IntDimension;
		
		
		
		
		function putDefault(key:String, value:*):void;
		
		function containsDefaultsKey(key:String):Boolean;
		
		function containsKey(key:*):Boolean;
		
		function getConstructor(key:String):Class;
		
		function getInstance(key:String):*;
		
		function getBoolean(key:String):Boolean;
		
		function getNumber(key:String):Number;
		
		function getInt(key:String):int;
		
		function getUint(key:String):uint;
		
		function getString(key:String):String;
		
		function getUI(target:Component):IComponentUI;
		
		function getBorder(key:String):IBorder;
		
		function getIcon(key:String):Icon;
		
		function getCanUpdateProvider(key:String):ICanUpdateProvider;
		
		function getColor(key:String):JColor;
		
		function getFont(key:String):JFont;
		
		function getInsets(key:String):Insets;
		
		function getStyleTune(key:String):StyleTune;
	}
}