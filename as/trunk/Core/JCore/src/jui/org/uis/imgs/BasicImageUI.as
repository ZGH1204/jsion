package jui.org.uis.imgs
{
	import flash.display.Bitmap;
	
	import jui.org.Component;
	import jui.org.coms.img.Image;
	import jui.org.uis.BaseComponentUI;
	
	import jutils.org.util.DisposeUtil;
	
	public class BasicImageUI extends BaseComponentUI
	{
		public function BasicImageUI()
		{
			super();
		}
		
		override public function installUI(component:Component):void
		{
			var img:Image = Image(component);
			
			var bmp:Bitmap = img.getAsset();
			
			if(bmp.parent == null) img.addChild(bmp);
		}
		
		override public function uninstallUI(component:Component):void
		{
			var img:Image = Image(component);
			
			var bmp:Bitmap = img.getAsset();
			
			if(bmp != null)
				DisposeUtil.free(bmp, bmp.bitmapData != img.getSourceBmd());
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}