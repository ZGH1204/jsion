package jsion.ui.components.scrollbars
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IBoundedRangeModel;
	import jsion.ui.IGroundDecorator;
	import jsion.ui.UIConstants;
	import jsion.ui.UIUtil;
	import jsion.ui.components.buttons.ScaleImageButton;
	import jsion.ui.events.ComponentEvent;
	import jsion.ui.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
	public class BasicScrollBarUI extends BasicComponentUI
	{
		protected var scrollBar:AbstractScrollBar;
		
		protected var leftBtn:ScaleImageButton;
		protected var rightBtn:ScaleImageButton;
		
		protected var topBtn:ScaleImageButton;
		protected var bottomBtn:ScaleImageButton;
		
		protected var thumb:Thumb;
		
		private var m_cur:int;
		private var m_val:int;
		
		public function BasicScrollBarUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			scrollBar = AbstractScrollBar(component);
			
			installDefaults(component);
			installProperties(component);
			installComponents(component);
			installListener(component);
		}
		
		protected function installProperties(component:Component):void
		{
			var bar:AbstractScrollBar = AbstractScrollBar(component);
			var pp:String = getResourcesPrefix(component);
			
			bar.hDirHGap = getInt(pp + DefaultConfigKeys.SCROLL_BAR_HDIR_HGAP);
			bar.hDirVGap = getInt(pp + DefaultConfigKeys.SCROLL_BAR_HDIR_VGAP);
			
			bar.hThumbHGap = getInt(pp + DefaultConfigKeys.HSCROLL_BAR_HTHUMB_HGAP);
			bar.hThumbVGap = getInt(pp + DefaultConfigKeys.HSCROLL_BAR_HTHUMB_VGAP);
			
			
			
			bar.vDirHGap = getInt(pp + DefaultConfigKeys.SCROLL_BAR_VDIR_HGAP);
			bar.vDirVGap = getInt(pp + DefaultConfigKeys.SCROLL_BAR_VDIR_VGAP);
			
			bar.vThumbHGap = getInt(pp + DefaultConfigKeys.VSCROLL_BAR_VTHUMB_HGAP);
			bar.vThumbVGap = getInt(pp + DefaultConfigKeys.VSCROLL_BAR_VTHUMB_VGAP);
			
			
			
			bar.autoScrollDelay = getInt(pp + DefaultConfigKeys.SCROLL_BAR_SCROLL_DELAY);//单位:毫秒
			bar.autoScrollStep = getNumber(pp + DefaultConfigKeys.SCROLL_BAR_SCROLL_STEP);
			
			bar.thumbMinSize = getInt(pp + DefaultConfigKeys.SCROLL_BAR_THUMB_MIN_SIZE);
		}
		
		protected function installComponents(component:Component):void
		{
			var bar:AbstractScrollBar = AbstractScrollBar(component);
			var pp:String = getResourcesPrefix(component);
			
			if(bar.dir == AbstractScrollBar.HORIZONTAL)
			{
				leftBtn = new ScaleImageButton(null, pp + DefaultConfigKeys.HScroll_BAR_LEFT_BUTTON_PRE);
				leftBtn.pack();
				
				rightBtn = new ScaleImageButton(null, pp + DefaultConfigKeys.HScroll_BAR_RIGHT_BUTTON_PRE);
				rightBtn.pack();
				
				bar.addChild(leftBtn);
				bar.addChild(rightBtn);
			}
			else
			{
				topBtn = new ScaleImageButton(null, pp + DefaultConfigKeys.VScroll_BAR_TOP_BUTTON_PRE);
				topBtn.pack();
				
				bottomBtn = new ScaleImageButton(null, pp + DefaultConfigKeys.VScroll_BAR_BOTTOM_BUTTON_PRE);
				bottomBtn.pack();
				
				bar.addChild(topBtn);
				bar.addChild(bottomBtn);
			}
			
			thumb = new Thumb(pp + DefaultConfigKeys.SCROLL_BAR_THUMB_PRE);
			thumb.dir = bar.dir;
			thumb.dragingFn = dragingCallback;
			thumb.pack();
			
			bar.addChild(thumb);
		}
		
		protected function installListener(component:Component):void
		{
			var bar:AbstractScrollBar = AbstractScrollBar(component);
			
			bar.addStateListener(__stateChangeHandler);
			
			if(leftBtn)
			{
				leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, __scrollLeftHandler);
				leftBtn.addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			if(rightBtn)
			{
				rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, __scrollRightHandler);
				rightBtn.addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			
			if(topBtn)
			{
				topBtn.addEventListener(MouseEvent.MOUSE_DOWN, __scrollUpHandler);
				topBtn.addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			if(bottomBtn)
			{
				bottomBtn.addEventListener(MouseEvent.MOUSE_DOWN, __scrollDownHandler);
				bottomBtn.addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			
			bar.addEventListener(MouseEvent.CLICK, __clickHandler);
			bar.addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			var block:Number;
			
			if(scrollBar.dir == AbstractScrollBar.HORIZONTAL)
			{
				if(scrollBar.scrollLength <= 0 || scrollBar.scrollLength <= scrollBar.width) return;
				
				block = getModelUnit();
				
				block = scrollBar.width / block;
				
				if(e.localX < thumb.x) block *= -1;
			}
			else
			{
				if(scrollBar.scrollLength <= 0 || scrollBar.scrollLength <= scrollBar.height) return;
				
				block = getModelUnit();
				
				block = scrollBar.height / block;
				
				if(e.localY < thumb.y) block *= -1;
			}
			
			scrollBar.scroll(block);
			
			e.stopPropagation();
		}
		
		private function getModelUnit():Number
		{
			if(scrollBar.dir == AbstractScrollBar.HORIZONTAL)
			{
				return (scrollBar.scrollLength - scrollBar.width) / (scrollBar.maximum - scrollBar.minimum);
			}
			else
			{
				return (scrollBar.scrollLength - scrollBar.height) / (scrollBar.maximum - scrollBar.minimum);
			}
		}
		
		private function getThumbUnit():Number
		{
			if(scrollBar.dir == AbstractScrollBar.HORIZONTAL)
			{
				return (scrollBar.scrollLength - scrollBar.width) / thumb.rang;
			}
			else
			{
				return (scrollBar.scrollLength - scrollBar.height) / thumb.rang;
			}
		}
		
		private function __mouseWheelHandler(e:MouseEvent):void
		{
			if(e.buttonDown) return;
			
			scrollBar.scroll(-e.delta * scrollBar.autoScrollStep);
		}
		
		private function __releaseHandler(e:ReleaseEvent):void
		{
			m_cur = 0;
			StageRef.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			m_cur++;
			
			if(m_cur <= scrollBar.autoScrollDelayFrameCount) return;
			
			scrollBar.scroll(m_val);
			
			if(scrollBar.value >= scrollBar.maximum) StageRef.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __scrollLeftHandler(e:MouseEvent):void
		{
			m_cur = 0;
			m_val = -scrollBar.autoScrollStep;
			scrollBar.scroll(m_val);
			StageRef.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __scrollRightHandler(e:MouseEvent):void
		{
			m_cur = 0;
			m_val = scrollBar.autoScrollStep;
			scrollBar.scroll(m_val);
			StageRef.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __scrollUpHandler(e:MouseEvent):void
		{
			m_cur = 0;
			m_val = -scrollBar.autoScrollStep;
			scrollBar.scroll(m_val);
			StageRef.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __scrollDownHandler(e:MouseEvent):void
		{
			m_cur = 0;
			m_val = scrollBar.autoScrollStep;
			scrollBar.scroll(m_val);
			StageRef.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		protected function uninstallListener(component:Component):void
		{
			var bar:AbstractScrollBar = AbstractScrollBar(component);
			
			StageRef.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			if(bar)
			{
				bar.removeStateListener(__stateChangeHandler);
				bar.removeEventListener(MouseEvent.CLICK, __clickHandler);
				bar.removeEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
			}
			
			if(leftBtn)
			{
				leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollLeftHandler);
				leftBtn.removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			if(rightBtn)
			{
				rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollRightHandler);
				rightBtn.removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			
			if(topBtn)
			{
				topBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollUpHandler);
				topBtn.removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
			if(bottomBtn)
			{
				bottomBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollDownHandler);
				bottomBtn.removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			}
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var bg:IGroundDecorator = component.backgroundDecorator;
			
			if(bg && bg.getDisplay(component))
			{
				var dis:DisplayObject = bg.getDisplay(component);
				if(dis && dis.width > 1 && dis.height > 1)
					return new IntDimension(dis.width, dis.height);
			}
			
			return thumb.getSize();
		}
		
		override public function uninstall(component:Component):void
		{
			dispose();
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			var bar:AbstractScrollBar = AbstractScrollBar(component);
			
			if(scrollBar.dir == AbstractScrollBar.HORIZONTAL) paintHorizontalScrollBar(bar);
			else paintVerticalScrollBar(bar);
			
			locateThumb(bar);
		}
		
		private function __stateChangeHandler(e:ComponentEvent):void
		{
			locateThumb(scrollBar);
		}
		
		protected function locateThumb(bar:AbstractScrollBar):void
		{
			if(scrollBar.needChangeThumb == false) return;
			
			var model:IBoundedRangeModel = bar.model;
			
			var modelUnit:Number = getModelUnit();
			
			var thumbUnit:Number = getThumbUnit();
			
			var tExtent:int = model.getValue() * modelUnit;
			
			tExtent /= thumbUnit;
			
			if(bar.dir == AbstractScrollBar.HORIZONTAL)
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
		
		protected function paintHorizontalScrollBar(bar:AbstractScrollBar):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(bar.getSize());
			
			var tmpRect:IntRectangle = new IntRectangle();
			
			if(bar.margin != int.MIN_VALUE)
			{
				var scale:Number = viewRect.height - bar.margin * 2;
				scale /= leftBtn.height;
				
				leftBtn.setSizeWH(leftBtn.width * scale, leftBtn.height * scale);
				
				rightBtn.setSizeWH(rightBtn.width * scale, rightBtn.height * scale);
				
				thumb.height *= scale;
			}
			
			tmpRect.setSize(leftBtn.getSize());
			
			UIUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, bar.hDirHGap, bar.hDirVGap, tmpRect);
			leftBtn.setLocation(tmpRect.getLocation());
			
			tmpRect.x = tmpRect.y = 0;
			UIUtil.layoutPosition(viewRect, UIConstants.RIGHT, UIConstants.MIDDLE, bar.hDirHGap, bar.hDirVGap, tmpRect);
			rightBtn.setLocation(tmpRect.getLocation());
			
			var hgap:int = leftBtn.x + leftBtn.width;
			hgap += bar.hThumbHGap;
			
			if(bar.scrollLength > viewRect.width)
			{
				var i:Number = viewRect.width / bar.scrollLength;
				
				var tmp:int = rightBtn.x - hgap;
				
				thumb.width = Math.max(tmp * i, bar.thumbMinSize);
				
				if(bar.enabled)
					thumb.visible = true;
				else
					thumb.visible = false;
			}
			else
			{
				thumb.visible = false;
			}
			
			tmpRect.x = tmpRect.y = 0;
			tmpRect.setSize(thumb.getSize());
			UIUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, hgap, bar.hThumbVGap, tmpRect);
			thumb.setLocation(tmpRect.getLocation());
			
			thumb.startPoint = tmpRect.getLocation();
			thumb.rang = rightBtn.x - thumb.startPoint.x - thumb.width;
			
			if(leftBtn) leftBtn.enabled = bar.enabled;
			if(rightBtn) rightBtn.enabled = bar.enabled;
		}
		
		protected function paintVerticalScrollBar(bar:AbstractScrollBar):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(bar.getSize());
			
			var tmpRect:IntRectangle = new IntRectangle();
			
			if(bar.margin != int.MIN_VALUE)
			{
				var scale:Number = viewRect.width - bar.margin * 2;
				scale /= topBtn.width;
				
				topBtn.setSizeWH(topBtn.width * scale, topBtn.height * scale);
				
				bottomBtn.setSizeWH(bottomBtn.width * scale, bottomBtn.height * scale);
				
				thumb.width *= scale;
			}
			
			tmpRect.setSize(topBtn.getSize());
			
			UIUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, bar.vDirHGap, bar.vDirVGap, tmpRect);
			topBtn.setLocation(tmpRect.getLocation());
			
			tmpRect.x = tmpRect.y = 0;
			UIUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.BOTTOM, bar.vDirHGap, bar.vDirVGap, tmpRect);
			bottomBtn.setLocation(tmpRect.getLocation());
			
			
			var vgap:int = topBtn.y + topBtn.height;
			vgap += bar.vThumbVGap;
			
			if(bar.scrollLength > viewRect.width)
			{
				var j:Number = viewRect.height / bar.scrollLength;
				
				var tmp:int = bottomBtn.y - vgap;
				
				thumb.height = Math.max(tmp * j, bar.thumbMinSize);
				//thumb.height = 100;
				
				if(bar.enabled)
					thumb.visible = true;
				else
					thumb.visible = false;
			}
			else
			{
				thumb.visible = false;
			}
			
			tmpRect.x = tmpRect.y = 0;
			tmpRect.setSize(thumb.getSize());
			UIUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, bar.vThumbHGap, vgap, tmpRect);
			
			thumb.setLocation(tmpRect.getLocation());
			thumb.startPoint = tmpRect.getLocation();
			thumb.rang = bottomBtn.y - thumb.startPoint.y - thumb.height;
			
			if(topBtn) topBtn.enabled = bar.enabled;
			if(bottomBtn) bottomBtn.enabled = bar.enabled;
		}
		
		protected function dragingCallback(extent:int, range:int):void
		{
			var percent:Number = extent / range;
			var val:Number = scrollBar.maximum - scrollBar.minimum;
			val *= percent;
			scrollBar.setValueUnChangeThumb(val);
			//trace("Percent pos: " + scrollBar.value);
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCROLL_BAR_PRE;
		}
		
		override public function dispose():void
		{
			uninstallListener(scrollBar);
			
			DisposeUtil.free(leftBtn);
			leftBtn = null;
			
			DisposeUtil.free(rightBtn);
			rightBtn = null;
			
			DisposeUtil.free(topBtn);
			topBtn = null;
			
			DisposeUtil.free(bottomBtn);
			bottomBtn = null;
			
			DisposeUtil.free(thumb);
			thumb = null;
			
			scrollBar = null;
		}
	}
}