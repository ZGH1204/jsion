package jcomponent.org.coms.buttons
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	
	import jutils.org.util.DisposeUtil;
	
	public class BasicButtonUI extends BasicComponentUI
	{
		private var textField:TextField;
		
		private var viewRect:IntRectangle = new IntRectangle();
		private var textRect:IntRectangle = new IntRectangle();
		
		public function BasicButtonUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			textField = new TextField();
			textField.wordWrap = false;
			textField.multiline = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			component.addChild(textField);
		}
		
		override public function uninstall(component:Component):void
		{
			DisposeUtil.free(textField);
			textField = null;
			
			viewRect = null;
			textRect = null;
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintText(component, bounds);
		}
		
		private function paintText(component:Component, bounds:IntRectangle):void
		{
			var btn:AbstractButton = AbstractButton(component);
			
			viewRect.setRect(bounds);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			
			var text:String = JUtil.layoutText(btn.text, btn.font, 
				btn.horizontalTextAlginment, 
				btn.verticalTextAlginment, 
				viewRect, textRect);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			textField.text = text;
			btn.font.apply(textField);
			textField.textColor = btn.forecolor.getRGB();
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			return getPreferredSize(component);
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var btn:AbstractButton = AbstractButton(component);
			
			JUtil.layoutText(btn.text, btn.font, 
				btn.horizontalTextAlginment, 
				btn.verticalTextAlginment, 
				viewRect, textRect);
			
			return textRect.getSize();
		}
	}
}