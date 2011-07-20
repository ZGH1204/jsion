package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TextTest extends Sprite
	{
		private var textField:TextField;
		public function TextTest()
		{
			super();
			
			textField = new TextField();
			
			textField.type = TextFieldType.INPUT;
			textField.multiline = true;
			textField.background = true;
			textField.backgroundColor = 0xFFFFFF;
			textField.border = true;
			textField.borderColor = 0x000000;
			
			
			var tf:TextFormat = new TextFormat("宋体","13",0x0070dd);
			
			textField.defaultTextFormat = tf;
			
			addChild(textField);
			
//			stage.addEventListener(MouseEvent.CLICK, __click);
		}
		
		private function __click(e:MouseEvent):void
		{
			textField.text += "123";
			var tf:TextFormat = new TextFormat("宋体","13",0x0070dd);
			textField.defaultTextFormat = tf;
		}
		
	}
}