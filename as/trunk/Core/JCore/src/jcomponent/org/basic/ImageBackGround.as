package jcomponent.org.basic
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jcomponent.org.coms.images.AbstractImage;
	import jcomponent.org.coms.images.ScaleImageTile;
	
	import jutils.org.util.DisposeUtil;

	public class ImageBackGround extends BasicGroundDecorator
	{
		protected var image:AbstractImage;
		
		protected var setuped:Boolean;
		
		public function ImageBackGround(freeBitmapData:Boolean = false)
		{
			super();
		}
		
		protected function setup(component:Component):void
		{
			if(setuped) return;
			
			setuped = true;
			
			var ui:IComponentUI = component.UI;
			var pp:String = ui.getResourcesPrefix(component);
			
			var bmd:BitmapData = ui.getBitmapData(pp + DefaultConfigKeys.BACKGROUND_IMAGE);
			var insets:Insets = ui.getInsets(pp + DefaultConfigKeys.BACKGROUND_INSETS);
			
			if(bmd == null) return;
			if(insets == null) insets = new Insets();
			image = new ScaleImageTile(bmd, insets);
			image.pack();
		}
		
		override public function updateDecorator(component:Component, bounds:IntRectangle):void
		{
			setup(component);
			if(image) image.setSizeWH(bounds.width, bounds.height);
		}
		
		override public function getDisplay(component:Component):DisplayObject
		{
			setup(component);
			return image;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(image);
			image = null;
			
			super.dispose();
		}
	}
}