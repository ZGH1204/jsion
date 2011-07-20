package jsion.factory
{
	import com.utils.StringHelper;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.controls.Button;

	public class ControlFactory
	{
		public static function createButtonAndText(up:DisplayObject, over:DisplayObject, posX:Number, posY:Number, txt:String, font:String, size:int, color:uint, bold:Boolean, italic:Boolean, txtX:Number = 0, txtY:Number = 0):Button
		{
			var btn:Button = createButton(up, over, posX, posY);
			
			var textField:TextField = createTextField(txt, font, size, color, bold, italic, txtX, txtY);
			
			btn.x = posX;
			btn.y = posY;
			btn.txt = textField;
			
			return btn;
		}
		
		public static function createButton(up:DisplayObject, over:DisplayObject, posX:Number = 0, posY:Number = 0):Button
		{
			var btn:Button = new Button(up, over);
			btn.x = posX;
			btn.y = posY;
			
			return btn
		}
		
		public static function createTextField(txt:String, font:String, size:int, color:uint, bold:Boolean, italic:Boolean, posX:Number, posY:Number):TextField
		{
			var textField:TextField = new TextField();
			
			if(StringHelper.isNullOrEmpty(font)) font = "宋体";
			if(size <= 0) size = 13;
			
			var tf:TextFormat = new TextFormat(font, size, color, bold, italic);
			
			textField.type = TextFieldType.DYNAMIC;
			textField.defaultTextFormat = tf;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = true;
			textField.x = posX;
			textField.y = posY;
			textField.htmlText = txt;
			textField.selectable = false;
			textField.mouseEnabled = false;
			
			return textField;
		}
	}
}