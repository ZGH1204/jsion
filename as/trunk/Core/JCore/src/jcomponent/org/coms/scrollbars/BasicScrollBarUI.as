package jcomponent.org.coms.scrollbars
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IComponentUI;
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
		
		protected var hDirHGap:int;
		protected var hDirVGap:int;
		
		protected var vDirHGap:int;
		protected var vDirVGap:int;
		
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
			var pp:String = getResourcesPrefix(component);
			
			hDirHGap = getInt(pp + "hDirHGap");
			hDirVGap = getInt(pp + "hDirVGap");
			
			vDirHGap = getInt(pp + "vDirHGap");
			vDirVGap = getInt(pp + "vDirVGap");
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
			
//			thumb = new Thumb(pp + "Thumb.");
//			thumb.pack();
//			
//			bar.addChild(thumb);
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
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(component.getSize());
			
			var btnRect:IntRectangle = new IntRectangle();
			
			if(scrollBar.dir == ScrollBar.HORIZONTAL)
			{
				btnRect.setSize(leftBtn.getSize());
				
				JUtil.layoutPosition(viewRect, UIConstants.LEFT, UIConstants.MIDDLE, hDirHGap, hDirVGap, btnRect);
				leftBtn.setLocation(btnRect.getLocation());
				
				btnRect.x = btnRect.y = 0;
				JUtil.layoutPosition(viewRect, UIConstants.RIGHT, UIConstants.MIDDLE, hDirHGap, hDirVGap, btnRect);
				rightBtn.setLocation(btnRect.getLocation());
			}
			else
			{
				btnRect.setSize(topBtn.getSize());
				
				JUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.TOP, vDirHGap, vDirVGap, btnRect);
				topBtn.setLocation(btnRect.getLocation());
				
				btnRect.x = btnRect.y = 0;
				JUtil.layoutPosition(viewRect, UIConstants.CENTER, UIConstants.BOTTOM, vDirHGap, vDirVGap, btnRect);
				bottomBtn.setLocation(btnRect.getLocation());
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