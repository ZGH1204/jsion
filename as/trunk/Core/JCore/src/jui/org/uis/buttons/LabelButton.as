package jui.org.uis.buttons
{
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.JColor;
	import jui.org.UIConstants;
	import jui.org.coms.buttons.AbstractButton;
	import jui.org.coms.buttons.DefaultButtonModel;
	
	public class LabelButton extends AbstractButton
	{
		protected var rolloverColor:JColor;
		protected var pressedColor:JColor;
		
		public function LabelButton(text:String = "", icon:Icon = null, horizontalAlignment:int = UIConstants.CENTER)
		{
			super(text, icon);
			
			setName("LabelButton");
			setModel(new DefaultButtonModel());
			setHorizontalAlignment(horizontalAlignment);
		}
		
		public function getRollOverColor():JColor
		{
			return rolloverColor;
		}
		
		public function setRollOverColor(c:JColor):void
		{
			if(c != rolloverColor)
			{
				rolloverColor = c;
				repaint();
			}
		}
		
		public function getPressedColor():JColor
		{
			return pressedColor;
		}
		
		public function setPressedColor(c:JColor):void
		{
			if(c != pressedColor)
			{
				pressedColor = c;
				repaint();
			}
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicLabelButtonUI;
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.LabelButtonUI;
		}
	}
}