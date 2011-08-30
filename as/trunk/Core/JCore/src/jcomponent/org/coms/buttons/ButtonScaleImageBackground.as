package jcomponent.org.coms.buttons
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.coms.images.ScaleImageTile;

	public class ButtonScaleImageBackground extends ButtonImageBackground
	{
		public function ButtonScaleImageBackground()
		{
			super(true);
		}
		
		override protected function getAsset(component:Component, ui:IComponentUI, extName:String, insetsName:String):DisplayObject
		{
			var pp:String = ui.getResourcesPrefix(component);
			
			var bmd:BitmapData = ui.getBitmapData(pp + extName);
			
			if(bmd == null) return null;
			
			var insets:Insets = ui.getInsets(pp + insetsName);
			
			if(insets == null)
			{
				throw new Error("九宫格边距必需配置!!!");
				return null;
			}
			
			var img:ScaleImageTile = new ScaleImageTile(bmd, insets);
			
			//img.pack();
			
			return img;
		}
	}
}