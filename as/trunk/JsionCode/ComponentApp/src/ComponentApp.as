package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import jsion.JsionFPS;
	
	[SWF(width="1000", height="650", frameRate="30")]
	public class ComponentApp extends Sprite
	{
		private var m_tf:TextField;
		
		private var m_style:StyleSheet;
		
		public function ComponentApp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			m_style = new StyleSheet();
			
			var str:String = "jsion{display: block;fontSize: 13;} br{display: block;}";
			
			m_style.parseCSS(str);
			
			m_tf = new TextField();
			m_tf.x = m_tf.y = 200;
			m_tf.styleSheet = m_style;
			m_tf.background = true;
			m_tf.backgroundColor = 0x006699;
			m_tf.autoSize = TextFieldAutoSize.LEFT;
			m_tf.htmlText = "<jsion>第一行</jsion><jsion>第二行</jsion><br />sdfsdfsdfsdfsdfsdf";
			addChild(m_tf);
			trace("width:", m_tf.width, "height:", m_tf.height);
			trace("textWidth:", m_tf.textWidth, "textHeight:", m_tf.textHeight);
			
			var tf:TextField = new TextField();
			tf.y = 300;
			tf.width = 200;
			var tmp:String;
			tf.text = "width:" + m_tf.width + "height:" + m_tf.height + "\r";
			tf.appendText("textWidth:" + m_tf.textWidth + "textHeight:" + m_tf.textHeight + "\r");
			
			addChild(tf);
			
			addChild(new JsionFPS);
		}
	}
}