package jsion.ui.components.containers
{
	import flash.display.Sprite;
	
	import jsion.*;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;

	public class BasicFrameUI extends BasicWindowUI
	{
		public function BasicFrameUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			super.install(component);
			
			installPos(component);
		}
		
		protected function installPos(component:Component):void
		{
			var frame:Frame = Frame(component);
			
			var pp:String = getResourcesPrefix(component);
			
			frame.contentX = getInt(pp + DefaultConfigKeys.FRAME_CONTENT_X);
			frame.contentY = getInt(pp + DefaultConfigKeys.FRAME_CONTENT_Y);
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.FRAME_PRE;
		}
	}
}