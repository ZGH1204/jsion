package jui.org.uis.radios
{
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.Graphics2D;
	import jui.org.Icon;
	import jui.org.brushs.SolidBrush;
	import jui.org.coms.buttons.AbstractButton;
	import jui.org.uis.buttons.BasicToggleButtonUI;
	
	public class BasicRadioButtonUI extends BasicToggleButtonUI
	{
		protected var defaultIcon:Icon;
		
		public function BasicRadioButtonUI()
		{
			super();
		}
		
		override protected function installDefaults(b:AbstractButton):void
		{
			super.installDefaults(b);
			
			defaultIcon = getIcon(getPrefix() + DefaultUI.Icon);
		}
		
		override protected function uninstallDefaults(b:AbstractButton):void
		{
			super.uninstallDefaults(b);
			
			if(defaultIcon.getDisplay(b))
			{
				if(button.contains(defaultIcon.getDisplay(b)))
				{
					button.removeChild(defaultIcon.getDisplay(b));
				}
			}
		}
		
		override protected function getPrefix():String
		{
			return DefaultUI.RadioButtonPrefix;
		}
		
		public function getDefaultIcon():Icon
		{
			return defaultIcon;
		}
		
		override protected function getIconToLayout():Icon
		{
			if(button.getIcon() == null)
			{
				if(defaultIcon.getDisplay(button))
				{
					if(!button.contains(defaultIcon.getDisplay(button)))
					{
						button.addChild(defaultIcon.getDisplay(button));
					}
				}
				return defaultIcon;
			}
			else
			{
				return button.getIcon();
			}
		}
		
		override protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void
		{
			if(c.isOpaque())
			{
				g.fillRect(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
			}
		}
	}
}