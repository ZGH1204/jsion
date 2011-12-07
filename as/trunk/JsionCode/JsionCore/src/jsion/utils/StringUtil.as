package jsion.utils
{
	import flash.text.TextField;
	
	import jsion.Constant;
	
	/**
	 * 字符串工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class StringUtil
	{
		/**
		 * 默认空白字符编码列表
		 */		
		private static var blankSpaceType:Array = [9,32,61656,59349,59350,59351,59352,59353,59354,59355,59355,59356,59357,59358,59359,59360,59361,59362,59363,59364,59365];
		/**
		 * 文本辅助对象
		 */		
		private static var text_field:TextField = new TextField();
		
		/**
		 * 指示指定的字符串是 null 还是 Constant.Empty 字符串
		 * @param value 要测试的字符串
		 * @return true表示字符串为 null 或 Constant.Empty 字符串<br />
		 * false表示字符串不为 null 或 Constant.Empty 字符串
		 * 
		 */		
		public static function isNullOrEmpty(value:String):Boolean
		{
			return value == null || value == Constant.Empty;
		}
		
		/**
		 * 指示指定的字符串不是 null 也不是 Constant.Empty 字符串
		 * @param value 要测试的字符串
		 * @return true表示字符串不为 null 也不为 Constant.Empty 字符串<br />
		 * false表示字符串为 null 或 Constant.Empty 字符串
		 */		
		public static function isNotNullOrEmpty(value:String):Boolean
		{
			return value != null && value != Constant.Empty;
		}
		
		/**
		 * 从当前 String 对象移除所有前导空白字符
		 * @param value 要移除空白字符的字符串
		 * @return 移除所有前导空白字符的新字符串
		 * 
		 */		
		public static function trimStart(value:String):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			return value.replace(/^\s*/g, Constant.Empty);
		}
		
		/**
		 * 从当前 String 对象移除所有尾部空白字符
		 * @param value 要移除空白字符的字符串
		 * @return  移除所有尾部空白字符的新字符串
		 * 
		 */		
		public static function trimEnd(value:String):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			return value.replace(/\s*$/g, Constant.Empty);
		}
		
		/**
		 * 从当前 String 对象移除所有前导空白字符和尾部空白字符
		 * @param value 要移除空白字符的字符串
		 * @return 移除所有前导空白字符和尾部空白字符的新字符串
		 * 
		 */		
		public static function trim(value:String):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			return value.replace(/(^\s*)|(\s*$)/g, Constant.Empty);
		}
		
		/**
		 * 从当前 String 对象移除所有空白字符
		 * @param value 要移除空白字符的字符串
		 * @param blankList 指定的空白字符编码列表
		 * @return 移除所有空白字符的新字符串
		 * 
		 */		
		public static function trimAll(value:String, blankList:Array = null):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			var s:String = trim(value);
			
			var newStr:String = Constant.Empty;
			
			var list:Array;
			
			if(blankList && blankList.length > 0) list = blankList;
			else list = blankSpaceType;
			
			for (var i:uint = 0; i<s.length; i++)
			{
				if (list.indexOf(s.charCodeAt(i)) <= -1)
				{
					newStr += s.charAt(i);
				}
			}
			
			return newStr;
		}
		
		/**
		 * 替换字符串
		 * @param str 要进行替换的原始字符串
		 * @param oldStr 旧字符串
		 * @param newStr 新字符串
		 * @return 替换后的新字符串
		 * 
		 */		
		public static function replace(str:String, oldStr:String, newStr:String):String
		{
			if(isNullOrEmpty(str)) return "";
			
			return str.split(oldStr).join(newStr);
		}
		
		/**
		 * 将指定字符串中的格式项替换为指定数组中相应对象的字符串表示形式
		 * @param value 复合格式字符串
		 * @param args 一个字符串数组,其中包含零个或多个要替换的字符串.
		 * @return 格式化后的新字符串
		 * 
		 */		
		public static function format(value:String,...args):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			if(args == null || args.length <= 0) return value;
			
			for(var i:int = 0; i < args.length; i++)
			{
				value = value.split("{" + i.toString() + "}").join(args[i]);
			}
			
			return value;
		}
		
		/**
		 * 将指定字符串中的绑定项绑定为指定数据源相应的字符串
		 * @param str 包含任意个{key}绑定项的字符串(key表示数据源中的数据键)
		 * @param bindData 要绑定到字符串的数据源
		 * @return 绑定后的新字符串
		 * 
		 */		
		public static function bindString(str:String, bindData:Object):String
		{
			var rlt:String = str;
			var list:Array = str.match(/\{\w*\}/g);
			for each(var item:String in list)
			{
				var key:String = item.substr(0, item.length - 2);
				var val:String;
				if(bindData) val = bindData[key];
				if(val == null) val = Constant.Empty;
				rlt = replace(rlt, item, val);
			}
			
			return rlt
		}
		
		/**
		 * 从当前 String 对象移除所有 Html 标签
		 * @param value 要移除标签的字符串
		 * @return 移除标签后的新字符串
		 * 
		 */		
		public static function removeHtmlTag(value:String):String
		{
			if(isNullOrEmpty(value)) return Constant.Empty;
			
			//value = value.replace(/<(\S*?)[^>]*>|<.*? \/>/g,"");
			text_field.htmlText = value;
			value = text_field.text;
			text_field.text = Constant.Empty;
			
			return value;
		}
		
		/**
		 * 指示指定的字符串是否以 withStr 字符串开头
		 * @param value 原始字符串
		 * @param withStr 要比较的字符串
		 * @return true 表示以 withStr 字符串开头<br />
		 * false 表示不以 withStr 字符串开头
		 */		
		public static function startWith(value:String, withStr:String):Boolean
		{
			return (value.indexOf(withStr) == 0);
		}
		
		/**
		 * 指示指定的字符串是否以 withStr 字符串结尾
		 * @param value 原始字符串
		 * @param withStr 要比较的字符串
		 * @return true 表示以 withStr 字符串结尾<br />
		 * false 表示不以 withStr 字符串结尾
		 */		
		public static function endWith(value:String, withStr:String):Boolean
		{
			return (value.lastIndexOf(withStr) == (value.length - withStr.length));
		}
		
		/**
		 * 指示指定的字符串是否为纯字母字符串
		 * @param value 要判断的字符串
		 * @return true 表示此字符串由纯字母字符串<br />
		 * false 表示此字符串不是纯字母字符串
		 */		
		public static function isLetter(value:String):Boolean
		{
			if(isNullOrEmpty(value)) return false;
			
			for(var i:int=0; i<value.length; i++)
			{
				var code:uint = value.charCodeAt(i);
				if(code < 65 || code > 122 || 
				  (code > 90 && code < 97)) return false;
			}
			return true;
		}
		
		/**
		 * 指示指定的对象是否为 String 对象字符串
		 * @param value 要判断的对象
		 * @return true 表示是字符串<br />
		 * false 表示不是字符串
		 */		
		public static function isString(value:*):Boolean
		{
			return value is String;
		}
		
		/**
		 * 过滤转义字符串
		 * @param str
		 * @return 
		 * 
		 */		
		public static function escapeString( str : String ) : String 
		{
			// create a string to store the string's jsonstring value
			var s : String = "";
			// current character in the string we're processing
			var ch : String;
			// store the length in a local variable to reduce lookups
			var len : Number = str.length;
			
			// loop over all of the characters in the string
			for ( var i : int = 0;i < len; i++ ) 
			{
				// examine the character to determine if we have to escape it
				ch = str.charAt(i);
				switch ( ch ) 
				{
					
					case '"':	
						// quotation mark
						s += "\\\"";
						break;
					
					case '/':	// solidus
						s += "\\/";
						break;
					
					case '\\':	
						// reverse solidus
						s += "\\\\";
						break;
					
					case '\b':	
						// bell
						s += "\\b";
						break;
					
					case '\f':	
						// form feed
						s += "\\f";
						break;
					
					case '\n':	
						// newline
						s += "\\n";
						break;
					
					case '\r':	
						// carriage return
						s += "\\r";
						break;
					
					case '\t':	
						// horizontal tab
						s += "\\t";
						break;
					
					default:	
						// everything else
						
						// check for a control character and escape as unicode
						if ( ch < ' ' ) 
						{
							// get the hex digit(s) of the character (either 1 or 2 digits)
							var hexCode : String = ch.charCodeAt(0).toString(16);
							
							// ensure that there are 4 digits by adjusting
							// the # of zeros accordingly.
							var zeroPad : String = hexCode.length == 2 ? "00" : "000";
							
							// create the unicode escape sequence with 4 hex digits
							s += "\\u" + zeroPad + hexCode;
						} else 
						{
							
							// no need to do any special encoding, just pass-through
							s += ch;
						}
				}
			}	
			
			return  s ;
		}
	}
}