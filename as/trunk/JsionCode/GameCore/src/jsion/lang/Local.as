package jsion.lang
{
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 本地语言包支持类
	 * @author Jsion
	 * 
	 */	
	public class Local
	{
		private static var languages:Dictionary = new Dictionary();
		
		/**
		 * 安装语言包
		 * @param str 语言包字符串
		 * 
		 */		
		public static function setup(str:String):void
		{
			var list:Array = str.split("\r\n");
			
			for(var i:int = 0; i < list.length; i ++)
			{
				var s:String = list[i];
				if(s.indexOf("#") == 0)
					continue;
				var index:int = s.indexOf(":");
				if(index != -1)
				{
					var name:String = s.substring(0,index);
					var value:String = s.substr(index + 1);
					value = value.split("##")[0];
					languages[name] = value;
				}
			}
		}
		
		/**
		 * 获取当前语言版本的对应文字信息
		 * @param key 文字信息键
		 * @param args 格式化数据源
		 * @return 当前语言的对应文字
		 * 
		 */		
		public static function getTrans(key:String, ...args):String
		{
			var input:String = languages[key] ? languages[key] : "未找到语言包对应值";
			
			var argList:Array = ArrayUtil.clone(args);
			argList.unshift(input);
			
			return StringUtil.format.apply(null, argList);
		}
	}
}