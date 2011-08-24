package jui.org.uis.buttons
{
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.Graphics2D;
	import jui.org.IButtonModel;
	import jui.org.IUIResource;
	import jui.org.JColor;
	import jui.org.StyleResult;
	import jui.org.brushs.SolidBrush;
	import jui.org.coms.buttons.AbstractButton;

	public class BasicLabelButtonUI extends BasicButtonUI
	{
		public function BasicLabelButtonUI()
		{
			super();
		}
		
		override protected function getPrefix():String
		{
			return DefaultUI.LabelButtonResourcePrefix;
		}
		
		override protected function installDefaults(bb:AbstractButton):void
		{
			super.installDefaults(bb);
			bb.buttonMode = true;
		}
		
		override protected function getTextPaintColor(bb:AbstractButton):JColor
		{
			var b:LabelButton = bb as LabelButton;
			var cl:JColor = bb.getForeground();
			var colors:StyleResult = new StyleResult(cl, bb.getStyleTune());
			
			var overColor:JColor = b.getRollOverColor();
			
			if(overColor == null || overColor is IUIResource)
			{
				overColor = colors.clight;
			}
			
			var downColor:JColor = b.getPressedColor();
			
			if(downColor == null || downColor is IUIResource)
			{
				downColor = colors.cdark;
			}
			
			if(b.isEnabled())
			{
				var model:IButtonModel = b.getModel();
				
				if(model.isSelected() || (model.isPressed() && model.isArmed()))
				{
					return downColor;
				}
				else if(b.isRollOverEnabled() && model.isRollOver())
				{
					return overColor;
				}
				
				return cl;
			}
			else
			{
				return JUtil.getDisabledColor(b);
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