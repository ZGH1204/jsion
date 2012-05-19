package jsion.debug
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import jsion.utils.ArrayUtil;
	import jsion.utils.ObjectUtil;
	import jsion.utils.StringUtil;
	
	public class Debugger extends Sprite
	{
		public static const TRACER_TAG:String = "tracer";
		public static const INFO_TAG:String = "info";
		public static const DEBUG_TAG:String = "debug";
		public static const WARN_TAG:String = "warn";
		public static const ERROR_TAG:String = "error";
		
		private static const UNLOAD:int = 0;
		private static const LOADING:int = 1;
		private static const COMPLETE:int = 2;
		
		private var m_list:Array;
		
		private var m_style:StyleSheet;
		
		private var m_loader:URLLoader;
		
		private var m_loadState:int;
		
		private var m_textField:TextField;
		
		private var m_btn:Sprite;
		
		private var m_width:int;
		
		private var m_height:int;
		
		private var m_isHide:Boolean;
		
		public function Debugger(w:int, h:int)
		{
			super();
			
			m_width = w;
			m_height = h;
			
			m_list = [];
			m_isHide = true;
			m_loadState = UNLOAD;
			
			m_style = new StyleSheet();
			
			m_btn = new MovieClip();
			m_btn.graphics.clear();
			m_btn.graphics.beginFill(0x000080, 1);
			m_btn.graphics.drawRect(0, 0, 20, 20);
			m_btn.graphics.endFill();
			m_btn.buttonMode = true;
			m_btn.x = -m_btn.width;
			m_btn.alpha = 0.3;
			addChild(m_btn);
			
			m_textField = new TextField();
			m_textField.type = TextFieldType.DYNAMIC;
			m_textField.background = true;
			m_textField.backgroundColor = 0x00;//00AA;
			m_textField.alpha = 0.5;
			m_textField.width = m_width;
			m_textField.height = m_height;
			m_textField.multiline = true;
			m_textField.wordWrap = true;
			m_textField.styleSheet = m_style;
			addChild(m_textField);
			
			
			
			m_btn.addEventListener(MouseEvent.CLICK, __showOrHideClickHandler);
		}
		
		private function __showOrHideClickHandler(e:MouseEvent):void
		{
			if(m_isHide)
			{
				x = stage.stageWidth - width;
				m_isHide = false;
			}
			else
			{
				x = stage.stageWidth;
				m_isHide = true;
			}
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set width(value:Number):void
		{
			m_width = value;
			
			m_textField.width = m_width;
		}
		
		override public function get height():Number
		{
			return m_height
		}
		
		override public function set height(value:Number):void
		{
			m_height = value;
			
			m_textField.height = m_height;
		}
		
		public function loadCSS(path:String):void
		{
			if(m_loader) return;
			
			var obj:Object = {};
			
			obj.rnd = Math.random();
			
			var request:URLRequest = new URLRequest(path);
			
			request.data = obj;
			
			m_loader = new URLLoader();
			m_loader.dataFormat = URLLoaderDataFormat.TEXT;
			m_loader.addEventListener(Event.COMPLETE, __loadCompleteHandler);
			m_loader.load(request);
			m_loadState = LOADING;
		}
		
		public function info(obj:*, ...args):void
		{
			var str:String;
			if(obj is String)
			{
				args.unshift(obj);
				
				str = StringUtil.format.apply(null, args);
			}
			else
			{
				str = getObjectStr(obj);
			}
			
			t(StringUtil.format("<{0}>[Info]" + str + "</{0}>", INFO_TAG));
		}
		
		public function debug(obj:*, ...args):void
		{
			var str:String;
			if(obj is String)
			{
				args.unshift(obj);
				
				str = StringUtil.format.apply(null, args);
			}
			else
			{
				str = getObjectStr(obj);
			}
			
			t(StringUtil.format("<{0}>[Debug]" + str + "</{0}>", DEBUG_TAG));
		}
		
		public function warn(obj:*, ...args):void
		{
			var str:String;
			if(obj is String)
			{
				args.unshift(obj);
				
				str = StringUtil.format.apply(null, args);
			}
			else
			{
				str = getObjectStr(obj);
			}
			
			t(StringUtil.format("<{0}>[Warn]" + str + "</{0}>", WARN_TAG));
		}
		
		public function error(obj:*, ...args):void
		{
			var str:String;
			if(obj is String)
			{
				args.unshift(obj);
				
				str = StringUtil.format.apply(null, args);
			}
			else
			{
				str = getObjectStr(obj);
			}
			
			t(StringUtil.format("<{0}>[Error]" + str + "</{0}>", ERROR_TAG));
		}
		
		public function clear():void
		{
			ArrayUtil.removeAll(m_list);
			
			updateHtmlText();
		}
		
		private function getObjectStr(obj:*):String
		{
			if(obj is String) return obj;
			
			var key:String, str:String = String(obj);
			var list:Array = ObjectUtil.getPropertyName(obj);
			
			str += "Properties:[\n";
			
			for each(key in list)
			{
				str += getStrByLen(key) + "：" + obj[key] + "\n";
			}
			
			for(key in obj)
			{
				str += getStrByLen(key) + "：" + obj[key] + "\n";
			}
			
			str += "]";
			
			return str;
		}
		
		private function getStrByLen(str:String, len:int = 20):String
		{
			var i:int = 20 - str.length;
			
			for(;i < len; i++)
			{
				str += " ";
			}
			
			return str;
		}
		
		private function __loadCompleteHandler(e:Event):void
		{
			m_loader.removeEventListener(Event.COMPLETE, __loadCompleteHandler);
			
			m_loadState = COMPLETE;
			
			var cssText:String = m_loader.data as String;
			
			m_style.parseCSS(cssText);
			
			updateHtmlText();
		}
		
		private function t(str:String):void
		{
			m_list.push(str);
			
			if(m_loadState != LOADING)
			{
				updateHtmlText();
			}
		}
		
		private function updateHtmlText():void
		{
			var htmlText:String = "";
			
			for each(var str:String in m_list)
			{
				htmlText += str;
			}
			
			m_textField.text = StringUtil.format("<0>" + htmlText + "</0>", TRACER_TAG);
			m_textField.scrollV = m_textField.maxScrollV;
		}
	}
}