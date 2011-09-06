package jcomponent.org.coms.scrollbars
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IGroundDecorator;
	import jcomponent.org.basic.LookAndFeel;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	
	import jutils.org.util.DisposeUtil;
	
	public class BasicScrollBarUI extends BasicComponentUI
	{
		protected var scrollBar:ScrollBar;
		
		protected var leftBtn:ScaleImageButton;
		protected var rightBtn:ScaleImageButton;
		
		protected var topBtn:ScaleImageButton;
		protected var bottomBtn:ScaleImageButton;
		
		protected var thumb:Thumb;
		
		public function BasicScrollBarUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			scrollBar = ScrollBar(component);
			
			installDefaults(component);
			installProperties(component);
			installComponents(scrollBar);
		}
		
		protected function installDefaults(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			LookAndFeel.installColors(component, pp);
			LookAndFeel.installFonts(component, pp);
			LookAndFeel.installBorderAndDecorators(component, pp);
		}
		
		protected function installProperties(component:Component):void
		{
			var bar:ScrollBar = ScrollBar(component);
			var pp:String = getResourcesPrefix(component);
			
			bar.hDirHGap = getInt(pp + "hDirHGap");
			bar.hDirVGap = getInt(pp + "hDirVGap");
			
			bar.vDirHGap = getInt(pp + "vDirHGap");
			bar.vDirVGap = getInt(pp + "vDirVGap");
			
			bar.hThumbHGap = getInt(pp + "hThumbHGap");
			bar.hThumbVGap = getInt(pp + "hThumbVGap");
			
			bar.vThumbHGap = getInt(pp + "vThumbHGap");
			bar.vThumbVGap = getInt(pp + "vThumbVGap");
		}
		
		protected function installComponents(component:Component):void
		{
			var bar:ScrollBar = ScrollBar(component);
			var pp:String = getResourcesPrefix(component);
			
			if(bar.dir == ScrollBar.HORIZONTAL)
			{
				leftBtn = new ScaleImageButton(null, pp + "LeftButton.");
				leftBtn.pack();
				
				rightBtn = new ScaleImageButton(null, pp + "RightButton.");
				rightBtn.pack();
				
				bar.addChild(leftBtn);
				bar.addChild(rightBtn);
			}
			else
			{
				topBtn = new ScaleImageButton(null, pp + "TopButton.");
				topBtn.pack();
				
				bottomBtn = new ScaleImageButton(null, pp + "BottomButton.");
				bottomBtn.pack();
				
				bar.addChild(topBtn);
				bar.addChild(bottomBtn);
			}
			
			thumb = new Thumb(pp + "Thumb.");
			thumb.pack();
			
			bar.addChild(thumb);
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
			var bar:ScrollBar = ScrollBar(component);
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(component.getSize());
			
			var btnRect:IntRectangle = new IntRectangle();
			var scale:Number;
			
			if(scrollBar.dir == ScrollBar.HORIZONTAL)
			{
				if(bar.margin != int.MIN_VALUE)
				{
					scale = viewRect.height - bar.margin * 2;
					scale /= leftBtn.height;
					
					leftBtn.width *= scale;
					leftBtn.height *= scale;
					
					rightBtn.width *= scale;
					rightBtn.height *= scale;
					
					thumb.height *= scale;
				}
				
				btnRect.setSize(leftBtn.getSize());
				
				JUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, bar.hDirHGap, bar.hDirVGap, btnRect);
				leftBtn.setLocation(btnRect.getLocation());
				
				btnRect.x = btnRect.y = 0;
				JUtil.layoutPosition(viewRect, UIConstants.RIGHT, UIConstants.MIDDLE, bar.hDirHGap, bar.hDirVGap, btnRect);
				rightBtn.setLocation(btnRect.getLocation());
				
				var hgap:int = leftBtn.x + leftBtn.width;
				hgap += bar.hThumbHGap;
				btnRect.x = btnRect.y = 0;
				btnRect.setSize(thumb.getSize());
				JUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, hgap, bar.hThumbVGap, btnRect);
				
				thumb.setLocation(btnRect.getLocation());
				thumb.startPoint = btnRect.getLocation();
				thumb.rect = new IntRectangle(0, 0, rightBtn.x - thumb.startPoint.x - thumb.width, 0);
			}
			else
			{
				if(bar.margin != int.MIN_VALUE)
				{
					scale = viewRect.width - bar.margin * 2;
					scale /= topBtn.width;
					
					topBtn.width *= scale;
					topBtn.height *= scale;
					
					bottomBtn.width *= scale;
					bottomBtn.height *= scale;
					
					thumb.width *= scale;
				}
				
				btnRect.setSize(topBtn.getSize());
				
				JUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, bar.vDirHGap, bar.vDirVGap, btnRect);
				topBtn.setLocation(btnRect.getLocation());
				
				btnRect.x = btnRect.y = 0;
				JUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.BOTTOM, bar.vDirHGap, bar.vDirVGap, btnRect);
				bottomBtn.setLocation(btnRect.getLocation());
				
				var vgap:int = topBtn.y + topBtn.height;
				vgap += bar.vThumbVGap;
				btnRect.x = btnRect.y = 0;
				btnRect.setSize(thumb.getSize());
				JUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, bar.vThumbHGap, vgap, btnRect);
				
				thumb.setLocation(btnRect.getLocation());
				thumb.startPoint = btnRect.getLocation();
				thumb.rect = new IntRectangle(0, 0, 0, bottomBtn.y - thumb.startPoint.y - thumb.height);
			}
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCROLL_BAR_PRE;
		}
		
		override public function dispose():void
		{
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