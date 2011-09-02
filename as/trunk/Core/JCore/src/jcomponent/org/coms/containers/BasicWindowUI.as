package jcomponent.org.coms.containers
{
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
			
			win.titleBar = new TitleBar();
			
			win.titleBar.setup(component);
		}
		
		protected function installCloseButton(component:Component):void
		{
			var pp:String = getResourcesPrefix(component);
			
			var win:Window = Window(component);
			
			win.closeBtn = new ImageButton(null, DefaultConfigKeys.WINDOW_CLOSE_BUTTON);
			
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
	}
}