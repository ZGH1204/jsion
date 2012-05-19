package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jsion.JsionFPS;
	import jsion.debug.DEBUG;
	import jsion.debug.Debugger;
	import jsion.display.Label;
	import jsion.utils.ObjectUtil;
	
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
			
			var tft:TextFormat = new TextFormat(null, 25, 0xff8040, true);
			
//			m_tf = new TextField();
//			m_tf.x = m_tf.y = 200;
//			m_tf.defaultTextFormat = tft;
//			m_tf.background = true;
//			m_tf.backgroundColor = 0x006699;
//			m_tf.autoSize = TextFieldAutoSize.LEFT;
//			m_tf.styleSheet = m_style;
//			m_tf.htmlText = "<jsion>第一行</jsion><jsion>第二行</jsion>sdfsdfsdfs\rdfsdfsdf";
//			addChild(m_tf);
//			trace("width:", m_tf.width, "height:", m_tf.height);
//			trace("textWidth:", m_tf.textWidth, "textHeight:", m_tf.textHeight);
//			
//			var tf:TextField = new TextField();
//			tf.y = 300;
//			tf.width = 800;
//			var tmp:String;
//			tf.text = "width:" + m_tf.width + "height:" + m_tf.height + "\r";
//			tf.appendText("textWidth:" + m_tf.textWidth + "textHeight:" + m_tf.textHeight + "\r");
//			tf.appendText("text:" + m_tf.htmlText + "\r");
//			
//			addChild(tf);
			
			var label:Label = new Label();
			label.x = 200;
			label.beginChanges();
			label.text = "<jsion>第一行</jsion><jsion>第二行</jsion>sdfsdfsdfsdfsdfsdf ";
			label.styleSheet = m_style;
			label.textFormat = tft;
			label.commitChanges();
			addChild(label);
			
			
			var tf:TextField = new TextField();
			tf.y = 300;
			tf.width = 800;
			var tmp:String;
			tf.text = "width:" + label.width + "           height:" + label.height + "\n";
			
			addChild(tf);
			
			stage.addChild(new JsionFPS);
			
			
			var t:Template = new Template();
			
			t.tid = 2;
			t.tname = "sdfsdf";
			t.lv=20;
			t.sex = 1;
			t.nick = "5454";
			
			DEBUG.setup(stage, 300);
			
			DEBUG.loadCSS("debug.css");
			
			DEBUG.info("sdlfjasdlfhaslkjdhfklshadfkhjsdlfjasdlfhaslkjdhfklshadfkhjsdlfjasdlfhaslkjdhfklshadfkhj");
			DEBUG.debug("654sdf654sd65fsd65f456s4df654sdf654sd65f4s65df4s6d54f6s5d4f");
			DEBUG.warn("sdf654g897h98rtyu7i987k.65h4j.3g1jk654hj697yh31fgh3210hj2gjhk1321h.+");
			DEBUG.error("错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示");
			
			DEBUG.info("sdlfjasdlfhaslkjdhfklshadfkhjsdlfjasdlfhaslkjdhfklshadfkhjsdlfjasdlfhaslkjdhfklshadfkhj");
			DEBUG.debug("654sdf654sd65fsd65f456s4df654sdf654sd65f4s65df4s6d54f6s5d4f");
			DEBUG.warn("sdf654g897h98rtyu7i987k.65h4j.3g1jk654hj697yh31fgh3210hj2gjhk1321h.+");
			DEBUG.error("错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示错误提示");
			DEBUG.info(t);
		}
	}
}