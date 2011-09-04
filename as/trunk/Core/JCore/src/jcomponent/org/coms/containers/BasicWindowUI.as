package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.LookAndFeel;
	import jcomponent.org.coms.buttons.ImageButton;

	public class BasicWindowUI extends BasicRootPanelUI
	{
		public function BasicWindowUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.WINDOW_PRE;
		}
		
		override public function install(component:Component):void
		{
			installDefaults(component);
			installTitleBar(component);
			installCloseButton(component);
			installAlignAndGap(component);
		}
		
		protected function installDefaults(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			LookAndFeel.installFonts(component, pp);
			LookAndFeel.installColors(component, pp);
			LookAndFeel.installBorderAndDecorators(component, pp);
		}
		
		protected function installTitleBar(component:Component):void
		{
			var win:Window = Window(component);
			
			var title:ITitleBar = new TitleBar();
			
			win.titleBar = title;
			
			title.setup(component);
		}
		
		protected function installCloseButton(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			var win:Window = Window(component);
			
			win.closeBtn = new ImageButton(null, pp + DefaultConfigKeys.WINDOW_CLOSE_BUTTON_PRE);
			
			win.closeBtn.pack();
		}
		
		protected function installAlignAndGap(component:Component):void
		{
			var win:Window = Window(component);
			
			win.hTitleAlign = getInt(DefaultConfigKeys.WINDOW_TITLE_HALIGN);
			win.vTitleAlign = getInt(DefaultConfigKeys.WINDOW_TITLE_VALIGN);
			win.hTitleGap = getInt(DefaultConfigKeys.WINDOW_TITLE_HGAP);
			win.vTitleGap = getInt(DefaultConfigKeys.WINDOW_TITLE_VGAP);
			
			win.hCloseAlign = getInt(DefaultConfigKeys.WINDOW_CLOSE_HALIGN);
			win.vCloseAlign = getInt(DefaultConfigKeys.WINDOW_CLOSE_VALIGN);
			win.hCloseGap = getInt(DefaultConfigKeys.WINDOW_CLOSE_HGAP);
			win.vCloseGap = getInt(DefaultConfigKeys.WINDOW_CLOSE_VGAP);
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintTitleBar(component, bounds);
			
			paintCloseButton(component, bounds);
		}
		
		protected function paintTitleBar(component:Component, bounds:IntRectangle):void
		{
			var win:Window = Window(component);
			
			if(win.titleBar)
			{
				win.titleBar.setTitle(win.title);
				
				var dis:DisplayObject = win.titleBar.getDisplay(component);
				
				var viewRect:IntRectangle = new IntRectangle();
				viewRect.width = bounds.width;
				viewRect.height = bounds.height;
				
				var titleRect:IntRectangle = new IntRectangle();
				
				if(win.titleBar)
				{
					titleRect.setSize(win.titleBar.getSize());
					
					JUtil.layoutPosition(viewRect, win.hTitleAlign, win.vTitleAlign, win.hTitleGap, win.vTitleGap, titleRect);
					
					win.titleBar.updateTitleBar(component, titleRect.x, titleRect.y);
				}
			}
		}
		
		protected function paintCloseButton(component:Component, bounds:IntRectangle):void
		{
			var win:Window = Window(component);
			var closeRect:IntRectangle = new IntRectangle();
			
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.width = bounds.width;
			viewRect.height = bounds.height;
			
			if(win.closeBtn)
			{
				closeRect.width = win.closeBtn.width;
				closeRect.height = win.closeBtn.height;
				
				JUtil.layoutPosition(viewRect, win.hCloseAlign, win.vCloseAlign, win.hCloseGap, win.vCloseGap, closeRect);
				
				win.closeBtn.setLocationXY(closeRect.x, closeRect.y);
			}
		}
	}
}