package jsion.ui.components.buttons
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jsion.ui.Component;
	import jsion.ui.IComponentUI;
	import jsion.ui.components.images.ScaleImageTile;

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
				throw new Error(pp + extName + "的九宫格边距" + pp + insetsName + "必需配置!!!");
				return null;
			}
			
			var img:ScaleImageTile = new ScaleImageTile(bmd, insets);
			
			img.pack();
			
			return img;
		}
	}
}