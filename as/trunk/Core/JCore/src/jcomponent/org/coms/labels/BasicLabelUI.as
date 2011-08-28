package jcomponent.org.coms.labels
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jcomponent.org.basic.BasicComponentUI;
	import jcomponent.org.basic.Component;
	
	import jutils.org.util.DisposeUtil;
	
	public class BasicLabelUI extends BasicComponentUI
	{
		private var textField:TextField;
		
		public function BasicLabelUI()
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
			
			//component.opaque = true;
		}
		
		override public function uninstall(component:Component):void
		{
			DisposeUtil.free(textField);
			textField = null;
			
			viewRect = null;
			textRect = null;
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var label:Label = Label(component);
			return JUtil.computeStringSizeWithFont(label.font, label.text);
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var label:Label = Label(component);
			return JUtil.computeStringSizeWithFont(label.font, label.text);
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintText(component, bounds);
		}
		
		private var viewRect:IntRectangle = new IntRectangle();
		private var textRect:IntRectangle = new IntRectangle();
		
		private function paintText(component:Component, bounds:IntRectangle):void
		{
			var label:Label = Label(component);
			
			viewRect.setRect(bounds);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			
			var text:String = JUtil.layoutText(label.text, label.font, 
												label.horizontalTextAlginment, 
												label.verticalTextAlginment, 
												viewRect, textRect);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			textField.text = text;
			label.font.apply(textField);
			textField.textColor = label.forecolor.getRGB();
		}
	}
}