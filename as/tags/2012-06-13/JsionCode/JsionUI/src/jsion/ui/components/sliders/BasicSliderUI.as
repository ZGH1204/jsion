package jsion.ui.components.sliders
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import jsion.*;
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IBoundedRangeModel;
	import jsion.ui.IGroundDecorator;
	import jsion.ui.UIConstants;
	import jsion.ui.UIUtil;
	import jsion.ui.events.ComponentEvent;
	import jsion.utils.DisposeUtil;
	
	public class BasicSliderUI extends BasicComponentUI
	{
		protected var slider:AbstractSlider;
		
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
			slider = AbstractSlider(component);
			
			installDefaults(component);
			
			installProperties(component);
			
			installComponents(component);
			
			installListener(component);
		}
		
		protected function installProperties(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			slider.hThumbHGap = getInt(pp + DefaultConfigKeys.HSLIDER_HTHUMB_HGAP);
			slider.hThumbVGap = getInt(pp + DefaultConfigKeys.HSLIDER_HTHUMB_VGAP);
			
			slider.vThumbHGap = getInt(pp + DefaultConfigKeys.VSLIDER_VTHUMB_HGAP);
			slider.vThumbVGap = getInt(pp + DefaultConfigKeys.VSLIDER_VTHUMB_VGAP);
			
			slider.autoScrollStep = getNumber(pp + DefaultConfigKeys.SLIDER_STEP);
		}
		
		protected function installComponents(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			thumb = new SliderThumb(pp + DefaultConfigKeys.SLIDER_THUMB_PRE);
			thumb.dir = slider.dir;
			thumb.dragingFn = dragingCallback;
			thumb.pack();
			slider.addChild(thumb);
		}
		
		protected function installListener(component:Component):void
		{
			slider.addStateListener(__sliderStateChangeHandler);
			slider.addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
			slider.addEventListener(MouseEvent.CLICK, __clickHandler);
		}
		
		protected function __clickHandler(e:MouseEvent):void
		{
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				thumb.x = e.localX - thumb.width / 2;
				
				thumb.check();
				dragingCallback(thumb.x - thumb.startPoint.x, thumb.rang);
			}
			else
			{
				thumb.y = e.localY - thumb.height / 2;
				
				thumb.check();
				dragingCallback(thumb.y - thumb.startPoint.y, thumb.rang);
			}
			
			e.stopPropagation();
		}
		
		protected function __mouseWheelHandler(e:MouseEvent):void
		{
			if(e.buttonDown) return;
			
			if(e.delta > 0)
			{
				slider.scroll(-slider.autoScrollStep);
			}
			else
			{
				slider.scroll(slider.autoScrollStep);
			}
		}
		
		protected function __sliderStateChangeHandler(e:ComponentEvent):void
		{
			locateThumb(slider);
		}
		
		protected function locateThumb(s:AbstractSlider):void
		{
			if(s.needChangeThumb == false) return;
			
			var model:IBoundedRangeModel = s.model;
			
			var modelUnit:Number = getModelUnit();
			
			var thumbUnit:Number = getThumbUnit();
			
			var tExtent:int = model.getValue() * modelUnit;
			
			tExtent /= thumbUnit;
			
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				tExtent += thumb.startPoint.x;
				thumb.x = tExtent;
			}
			else
			{
				tExtent += thumb.startPoint.y;
				thumb.y = tExtent;
			}
		}
		
		private function getModelUnit():Number
		{
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				return (slider.width - thumb.width) / (slider.maximum - slider.minimum);
			}
			else
			{
				return (slider.height - thumb.height) / (slider.maximum - slider.minimum);
			}
		}
		
		private function getThumbUnit():Number
		{
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				return (slider.width - thumb.width) / thumb.rang;
			}
			else
			{
				return (slider.height - thumb.height) / thumb.rang;
			}
		}
		
		protected function dragingCallback(extent:int, range:int):void
		{
			var percent:Number = extent / range;
			var val:Number = slider.maximum - slider.minimum;
			val *= percent;
			slider.setValueUnChangeThumb(val);
			//trace("Slider value: " + slider.value);
		}
		
		override public function uninstall(component:Component):void
		{
			dispose();
		}
		
		protected function uninstallListener(component:Component):void
		{
			if(slider)
			{
				slider.removeStateListener(__sliderStateChangeHandler);
				slider.removeEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
				slider.removeEventListener(MouseEvent.CLICK, __clickHandler);
			}
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			var s:IntDimension;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 1 && dis.height > 1)
				{
					s = new IntDimension();
					
					if(slider.dir == AbstractSlider.HORIZONTAL)
					{
						s.width = dis.width;
						
						s.height = Math.max(thumb.height, dis.height);
					}
					else
					{
						s.width = Math.max(thumb.width, dis.width);
						
						s.height = dis.height;
					}
					
					return s;
				}
			}
			
			s = thumb.getSize();
			
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				s.width += 100;
			}
			else
			{
				s.height += 100;
			}
			
			return s;
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintSlider(component);
			
			locateBackground(component);
			
			locateThumb(slider);
		}
		
		protected function paintSlider(component:Component):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(slider.getSize());
			
			var tmpRect:IntRectangle = new IntRectangle();
			tmpRect.setSize(thumb.getSize());
			
			if(slider.dir == AbstractSlider.HORIZONTAL)
			{
				UIUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, slider.hThumbHGap, slider.hThumbVGap, tmpRect);
				
				thumb.rang = viewRect.width - thumb.width;
			}
			else
			{
				UIUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, slider.vThumbHGap, slider.vThumbVGap, tmpRect);
				
				thumb.rang = viewRect.height - thumb.height;
			}
			
			thumb.setLocation(tmpRect.getLocation());
			thumb.startPoint = tmpRect.getLocation();
			
			thumb.enabled = slider.enabled;
		}
		
		protected function locateBackground(component:Component):void
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var viewRect:IntRectangle = new IntRectangle();
				viewRect.setSize(component.getSize());
				
				var bgRect:IntRectangle = new IntRectangle();
				
				var dis:DisplayObject = bg.getDisplay(component);
				
				if(dis && dis.width > 1 && dis.height > 1)
				{
					bgRect.width = dis.width;
					bgRect.height = dis.height;
					
					if(slider.dir == AbstractSlider.HORIZONTAL)
					{
						UIUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, 0, 0, bgRect);
					}
					else
					{
						UIUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, 0, 0, bgRect);
					}
					
					bgRect.x = bgRect.x;
					bgRect.y = bgRect.y;
				}
			}
		}
		
		override public function dispose():void
		{
			uninstallListener(slider);
			
			DisposeUtil.free(thumb);
			thumb = null;
			
			slider = null;
			
			super.dispose();
		}
	}
}