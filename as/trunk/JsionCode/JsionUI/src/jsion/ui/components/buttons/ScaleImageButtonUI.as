package jsion.ui.components.buttons
{
	import flash.display.DisplayObject;
	
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IGroundDecorator;

	public class ScaleImageButtonUI extends BasicButtonUI
	{
		public function ScaleImageButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_BUTTON_PRE;
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var s:IntDimension = super.getPreferredSize(component);
			
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 0 && dis.height > 0)
				{
					s.width = Math.max(dis.width, s.width);
					s.height = Math.max(dis.height, s.height);
				}
			}
			
			return s;
		}
	}
}