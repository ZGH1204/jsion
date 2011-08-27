package jcomponent.org.basic
{
	import jcomponent.org.basic.borders.IBorder;

	public interface IUIResources extends IDispose
	{
		function putResources(keyValueList:Array):void;
		
		function getUI(target:Component):IComponentUI;
		
		function getBoolean(key:String):Boolean;
		
		function getNumber(key:String):Number;
		
		function getInt(key:String):int;
		
		function getUint(key:String):uint;
		
		function getString(key:String):String;
		
		function getBorder(key:String):IBorder;
		
		function getIcon(key:String):IICON;
		
		function getGroundDecorator(key:String):IGroundDecorator;
		
		function getColor(key:String):ASColor;
		
		function getFont(key:String):ASFont;
		
		function getInsets(key:String):Insets;
		
		function getStyleTune(key:String):StyleTune;
		
		function getConstructor(key:String):Class;
		
		function getInstance(key:String):*;
	}
}