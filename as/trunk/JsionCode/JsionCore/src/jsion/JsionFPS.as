package jsion
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.getTimer;
	
	/**
	 * 显示FPS和其他相关环境信息
	 * @author Jsion
	 */	
	public class JsionFPS extends Sprite
	{
		static private  var instance:JsionFPS;
		private var m_style:StyleSheet;
		private var m_textField:TextField;
		
		
		
		private var tfTimer:int;
		
		private var tfDelay:int = 0;
		
		private var m_fixStr:String;
		
		static private  const tfDelayMax:int = 10;
		
		public function JsionFPS()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
		}
		
		private function __addToStageHandler(e:Event):void
		{
			if(instance) return;
			
			m_fixStr = "";
			
			m_fixStr += "<os>OS: " + Capabilities.os + "  " + Capabilities.language + "</os>";
			m_fixStr += "<audio>Audio: " + Capabilities.hasAudio + "</audio>";
			m_fixStr += "<player>Player: " + Capabilities.playerType + "</player>";
			m_fixStr += "<debug>Debug: " + Capabilities.isDebugger + "</debug>";
			
			var css:String = "";
			
			css += "fps{display: block; fontSize: 10; color: #FFFFFF;}";
			css += "mem{display: block; fontSize: 10; color: #FFFFFF;}";
			css += "os{display: block; fontSize: 10; color: #FFFFFF;}";
			css += "player{display: block; fontSize: 10; color: #FFFFFF;}";
			css += "audio{display: block; fontSize: 10; color: #FFFFFF;}";
			css += "debug{display: block; fontSize: 10; color: #FFFFFF;}";
			
			m_style = new StyleSheet();
			m_style.parseCSS(css);
			
			m_textField = new TextField();
			m_textField.selectable = false;
			m_textField.type = TextFieldType.DYNAMIC;
			m_textField.styleSheet = m_style;
			m_textField.autoSize = TextFieldAutoSize.LEFT;
			m_textField.background = true;
			m_textField.backgroundColor = 0x0;//0xFF8040;
			m_textField.alpha = 0.5;
			addChild(m_textField);
			
			mouseChildren = mouseEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			tfDelay++;
			
			if (tfDelay >= tfDelayMax)
			{
				
				tfDelay = 0;
				
				m_textField.htmlText = getString();
				
				tfTimer = getTimer();
			}
		}
		
		private function getString():String
		{
			var str:String = "";
			
			str += "<fps>FPS:   " + int(1000 * tfDelayMax / (getTimer() - tfTimer)) + " / " + stage.frameRate + "</fps>";
			str += "<mem>Mem: " + bytesToString(System.totalMemory) + "</mem>";
			str += m_fixStr;
			
			return str;
		}
		
		private function bytesToString(memory:uint):String
		{
			
			var _str:String;
			
			if (memory < 1024)
			{
				_str = String(memory) + "B";
				
			}
			else if (memory < 10240)
			{
				_str = Number(memory / 1024).toFixed(2) + "KB";
				
			}
			else if (memory < 102400)
			{
				_str = Number(memory / 1024).toFixed(1) + "KB";
				
			}
			else if (memory < 1048576)
			{
				_str =int(memory / 1024) + "KB";
				
			}
			else if (memory < 10485760)
			{
				_str = Number(memory / 1048576).toFixed(2) + "MB";
				
			}
			else if (memory < 104857600)
			{
				_str = Number(memory / 1048576).toFixed(1) + "MB";
				
			}
			else
			{
				_str = int(memory / 1048576) + "MB";
				
			}
			
			return _str;
		}
	}
}