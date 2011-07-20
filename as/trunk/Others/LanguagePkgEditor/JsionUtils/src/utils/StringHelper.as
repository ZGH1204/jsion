package utils
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class StringHelper
	{
	 	/**
	 	 * 判断是否为空或空字符串 
	 	 * @param str
	 	 * @return 
	 	 * true 表示是空或空字符串
	 	 * false 表示不是空或空字符串
	 	 */	 	
	 	public static function isNullOrEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		
		/**
		 * 压缩左边空格 
		 * @param targetString
		 * @return 
		 * 
		 */		
		public static function trimLeft(targetString:String):String
	 	{
	 		if(isNullOrEmpty(targetString))
	 			return "";
	 		
	 		return targetString.replace(/^\s*/g,"");
	 	}
	 	
	 	/**
	 	 *  压缩右边空格 
	 	 * @param targetString
	 	 * @return 
	 	 * 
	 	 */	 	
	 	public static function trimRight(targetString:String):String
	 	{
	 		if(isNullOrEmpty(targetString))
	 			return "";
	 		
	 		return targetString.replace(/\s*$/g,"");
	 	}
	 	
	 	/**
	 	 * 压缩首尾空格 
	 	 * @param str
	 	 * @return 
	 	 * 
	 	 */	 	
	 	public static function trim(str:String):String
	 	{
	 		if(isNullOrEmpty(str))
	 			return "";
	 		
	 		return str.replace(/(^\s*)|(\s*$)/g,"");
	 	}
	 	
	 	private static var blankSpaceType:Array = [9,32,61656,59349,59350,59351,59352,59353,59354,59355,59355,59356,59357,59358,59359,59360,59361,59362,59363,59364,59365];
	 	/**
	 	 * 删除所有空格和未知字符 
	 	 * @param str
	 	 * @return 
	 	 * 
	 	 */
	 	public static function trimAll(str:String):String
	 	{
	 		if(isNullOrEmpty(str))
	 			return "";
	 		
	 		var s:String = trim(str);
	 		
	 		var newStr:String = "";
			
	 		for (var i:uint = 0; i<s.length; i++)
			{
				if (blankSpaceType.indexOf(s.charCodeAt(i)) <= -1)
				{
					newStr += s.charAt(i);
				}
			}
	 		
	 		return newStr;
	 	}
	 	
	 	/**
	 	 * 替换字符串 
	 	 * @param originalStr 原始字符串
	 	 * @param oldStr 旧字符串
	 	 * @param newStr 新字符串
	 	 * @return 
	 	 * 返回替换后的字符串
	 	 */	 	
	 	public static function replace(originalStr:String,oldStr:String,newStr:String):String
	 	{
	 		if(isNullOrEmpty(originalStr))
	 			return "";
	 		
	 		return originalStr.split(oldStr).join(newStr);
	 	}
		
		/**
		 * 格式化字符串 
		 * @param str
		 * @param args
		 * @return 
		 * 返回格式化后的字符串
		 */		
		public static function format(str:String,...args):String
		{
	 		if(isNullOrEmpty(str))
	 			return "";
	 		
			if(args == null || args.length <= 0)
			{
				return str;
			}
			
			for(var i:uint = 0; i < args.length; i++)
			{
				str = replace(str,"{"+i.toString()+"}",args[i]);
			}
			
			return str;
		}
		
		/**
		 * 移除掉简单HTML标签 
		 * @param str HTML字符串
		 * @return 
		 * 移除HTML标签后的字符串
		 */		
		public static function removeHtmlTag(str:String):String
		{
	 		if(isNullOrEmpty(str))
	 			return "";
	 		
			str = str.replace(/<(\S*?)[^>]*>|<.*? \/>/g,"");
			return str;
		}
		
		/**
		 * 移除掉简单HTML标签 (利用TextField)
		 * @param str HTML字符串
		 * @return 
		 * 移除HTML标签后的字符串
		 */		
		public static function removeHtmlTagByTextField(str:String):String
		{
	 		if(isNullOrEmpty(str))
	 			return "";
	 		var txt:TextField = new TextField();
	 		txt.htmlText = str;
			
			return txt.text;
		}
		
		/**
		 * 将字符串转换为HTML字符串，转义特殊字符串
		 * @param s
		 * @return 
		 * 
		 */		
		public static function toHtmlString(s:String):String
		{
	 		if(isNullOrEmpty(s))
	 			return "";
	 		
			var txt:TextField = new TextField();
			
			txt.text = s;
			
			s = removeHtmlTag(txt.htmlText);
			
			return s;
		}
		
		/**
		 * 获取指定字符串中所有HTML转义字符的数组
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getConvertedHtmlArray(str:String):Array
		{
	 		if(isNullOrEmpty(str))
	 			return null;
	 		
			return str.match(/&[a-z]*?;/g);
		}
		
		private static const reg:RegExp = /[^\x00-\xff]{1,}/g;
		/**
		 * 限制TextField的最大输入字符
		 * @param textfield
		 * @param max
		 * @param input
		 * 
		 */		
		public static function checkTextFieldLength(textfield:TextField, max:uint,input:String = null):void
		{
			if(textfield == null)
				return;
			
			var ulen1:uint = textfield.text ? textfield.text.match(reg).join("").length : 0;
			var ulen2:uint = input ? input.match(reg).join("").length : 0;
			
	        textfield.maxChars = max > ulen1 + ulen2 ? max - ulen1 - ulen2 : (max > ulen2 ? max - ulen2 : max /2);
		}
		
		private static const OFFSET:Number=2000;
		
		/**
		 * 转换路径字符串,长度必需为偶数
		 * @param pathString
		 * @return 
		 * 返回Point数组
		 */		
		public static function stringToPath(pathString:String):Array
		{
	 		if(isNullOrEmpty(pathString))
	 			return null;
	 		
			var path:Array = [];
			for(var i:uint = 0; i < path.length; i+=2)
			{
				var x:int = pathString.charCodeAt(i);
				var y:int = pathString.charCodeAt(i+1);
				
				path.push(new Point(x-OFFSET,y-OFFSET));
			}
			
			return path;
		}
		/**
		 * 将Point路径数组转换为路径字符串
		 * @param path
		 * @return 
		 * 返回路径字符串
		 */		
		public static function pathToString(path:Array):String
		{
			if(path == null || path.length <= 0)
			{
				return "";
			}
			
			var pathString:String = "";
			for(var i:uint = 0; i < path.length; i++)
			{
				pathString = String.fromCharCode(Math.round(path[i].x + OFFSET));
				pathString = String.fromCharCode(Math.round(path[i].y + OFFSET));
			}
			
			return pathString;
		}
		
		/**
		 * 字符串转换为坐标点(字符串应至少为两位，并且只取前两位)
		 * @param str
		 * @return 
		 * 
		 */		
		public static function stringToPoint(str:String):Point
		{
	 		if(isNullOrEmpty(str))
	 			return null;
	 		
			return new Point(str.charCodeAt(0)-OFFSET,str.charCodeAt(1)-OFFSET);
		}
		
		/**
		 * 坐标点转换为字符串
		 * @param point
		 * @return 
		 * 
		 */		
		public static function pointToString(point:Point):String
		{
			if(point == null)
				return "";
			
			var result:String = "";
			
			result += String.fromCharCode(Math.round(point.x + OFFSET));
			result += String.fromCharCode(Math.round(point.y + OFFSET));
			
			return result;
		}
		
		/**
		 * 数字转换为字符串
		 * @param number
		 * @return 
		 * 
		 */		
		public static function numberToString(number:Number):String
		{
			return String.fromCharCode(Math.round(number+OFFSET));
		}
		
		/**
		 * 字符串转换为数字(字符串至少1位，且函数仅取第一位的字符)
		 * @param str
		 * @return 
		 * 
		 */		
		public static function stringToNumber(char:String):Number
		{
			return char.charCodeAt(0) - OFFSET;
		}
		
		/**
		 * 确定字符串是不是Big码
		 * @param str
		 * @param max
		 * @return 
		 * 
		 */		
		public static function getIsBiggerMaxCHchar(str:String,max:int):Boolean
		{
			var b:ByteArray = new ByteArray();
        	b.writeUTF(trim(str));
        	if(b.length > (max*3+2))
        	{
        		return true;
        	}
        	else
        	{
        		return false;
        	}
		}
		
		/**
		 * 返回str参数所指定的字符串是否以withStr参数所指定的字符串开头
		 * @param str 原始字符串
		 * @param withStr 要匹配的开头字符串
		 * @return 
		 * 
		 */		
		public static function startWith(str:String, withStr:String):Boolean
		{
			return (str.indexOf(withStr) == 0);
		}
		
		/**
		 * 返回str参数所指定的字符串是否以withStr参数所指定的字符串结尾
		 * @param str
		 * @param withStr
		 * @return 
		 * 
		 */		
		public static function endWith(str:String, withStr:String):Boolean
		{
			return (str.lastIndexOf(withStr) == (str.length - withStr.length));
		}
	}
}