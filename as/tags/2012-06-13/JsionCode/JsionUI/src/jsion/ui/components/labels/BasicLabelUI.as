package jsion.ui.components.labels
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jsion.*;
	import jsion.ui.BasicComponentUI;
	import jsion.ui.Component;
	import jsion.ui.UIUtil;
	import jsion.utils.DisposeUtil;
	
	public class BasicLabelUI extends BasicComponentUI
	{
		private var textField:TextField;
		
		private var viewRect:IntRectangle = new IntRectangle();
		private var textRect:IntRectangle = new IntRectangle();
		
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
			return UIUtil.computeStringSizeWithFont(label.font, label.text);
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var label:Label = Label(component);
			return UIUtil.computeStringSizeWithFont(label.font, label.text);
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintText(component, bounds);
		}
		
		private function paintText(component:Component, bounds:IntRectangle):void
		{
			var label:Label = Label(component);
			
			viewRect.setRect(bounds);
			
			textRect.x = textRect.y = textRect.width = textRect.height = 0;
			
			var text:String = UIUtil.layoutText(label.text, label.font, 
												label.horizontalTextAlginment, 
												label.verticalTextAlginment, 
												viewRect, textRect);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			label.font.apply(textField);
			textField.textColor = label.forecolor.getRGB();
			textField.htmlText = text;
		}
		
		override public function dispose():void
		{
			textField = null;
			
			viewRect = null;
			
			textRect = null;
			
			super.dispose();
		}
	}
}