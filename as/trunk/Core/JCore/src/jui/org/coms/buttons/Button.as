package jui.org.coms.buttons
{
	import flash.display.SimpleButton;
	
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.UIConstants;
	import jui.org.uis.buttons.BasicButtonUI;
	import jui.org.uis.buttons.SimpleButtonIcon;
	
	public class Button extends AbstractButton
	{
		public function Button(text:String = "", icon:Icon = null)
		{
			super(text, icon);
			
			setName("Button");
			
			setModel(new DefaultButtonModel());
		}
		
		public function isDefaultButton():Boolean
		{
//			var rootPane:JRootPane = getRootPaneAncestor();
//			if(rootPane != null){
//				return rootPane.getDefaultButton() == this;
//			}
			
			return false;
		}
		
		override public function wrapSimpleButton(btn:SimpleButton):AbstractButton
		{
			mouseChildren = true;
			drawTransparentTrigger = false;
			setShiftOffset(0);
			setIcon(new SimpleButtonIcon(btn));
			setBorder(null);
			setMargin(new Insets());
			setBackgroundProvider(null);
			setHorizontalTextPosition(UIConstants.CENTER);
			setVerticalTextPosition(UIConstants.CENTER);
			
			return this;
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicButtonUI;
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.ButtonUI;
		}
	}
}