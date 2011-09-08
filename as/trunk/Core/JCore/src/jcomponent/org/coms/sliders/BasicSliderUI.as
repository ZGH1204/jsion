package jcomponent.org.coms.sliders
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IGroundDecorator;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	import jcomponent.org.coms.scrollbars.Thumb;
	
	public class BasicSliderUI extends BasicComponentUI
	{
		protected var slider:Slider;
		
		protected var thumb:SliderThumb;
		
		public function BasicSliderUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SLIDER_PRE;
		}
		
		override public function install(component:Component):void
		{
			slider = Slider(component);
			
			installDefaults(component);
			
			installComponents(component);
		}
		
		protected function installComponents(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			thumb = new SliderThumb(pp + "Thumb.");
			thumb.dir = slider.dir;
			thumb.dragingFn = dragingCallback;
			thumb.pack();
			slider.addChild(thumb);
		}
		
		protected function dragingCallback(extent:int, range:int):void
		{
			//trace("extent:", extent, "range:", range);
			var percent:Number = extent / range;
			var val:Number = slider.maximum - slider.minimum;
			val *= percent;
			slider.setValueUnChangeThumb(val);
			trace("Slider value: " + slider.value);
		}
		
		override public function uninstall(component:Component):void
		{
			dispose();
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			var s:IntDimension = new IntDimension();
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 1 && dis.height > 1)
					return new IntDimension(dis.width, dis.height);
			}
			
			return thumb.getSize();
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			paintSlider(component);
		}
		
		protected function paintSlider(component:Component):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(slider.getSize());
			
			thumb.startPoint = new IntPoint();
			
			if(slider.dir == Slider.HORIZONTAL)
			{
				thumb.rang = viewRect.width - thumb.width;
			}
			else
			{
				thumb.rang = viewRect.height - thumb.height;
			}
		}
		
	}
}