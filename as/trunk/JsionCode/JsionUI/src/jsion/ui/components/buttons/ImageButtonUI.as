package jsion.ui.components.buttons
{
	import flash.display.DisplayObject;
	
	import jsion.*;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IGroundDecorator;

	public class ImageButtonUI extends BasicButtonUI
	{
		public function ImageButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.IMAGE_BUTTON_PRE;
		}
		
		override public function install(component:Component):void
		{
			super.install(component);
			
			if(component.backgroundDecorator == null)
			{
				var pp:String = getDefaultPrefix();
				
				var bg:IGroundDecorator = getGroundDecorator(pp + DefaultConfigKeys.BACKGROUND_DECORATOR_RES);
				
				component.backgroundDecorator = bg;
			}
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 0 && dis.height > 0)
				{
					return new IntDimension(dis.width, dis.height);
				}
			}
			
			return super.getPreferredSize(component);
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 0 && dis.height > 0)
				{
					return new IntDimension(dis.width, dis.height);
				}
			}
			
			return super.getMinimumSize(component);
		}
		
		override public function getMaximumSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 0 && dis.height > 0)
				{
					return new IntDimension(dis.width, dis.height);
				}
			}
			
			return super.getMaximumSize(component);
		}
	}
}