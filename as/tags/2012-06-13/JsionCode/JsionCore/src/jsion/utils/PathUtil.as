package jsion.utils
{
	/**
	 * 路径工具
	 * @author Jsion
	 * 
	 */	
	public class PathUtil
	{
		/**
		 * 合并一个或多个路径值 自动处理路径分隔符
		 * @param args 路径值列表
		 * @return 合并后的路径
		 * 
		 */		
		public static function combinPath(...args):String
		{
			var path:String = "";
			
			if(args.length <= 0) return path;
			else if(args.length == 1) return args[0];
			else path = args.shift();
			
			if(path == null) path = "";
			
			var splitor:String;
			
			if(path.lastIndexOf("\\") != -1) splitor = "\\";
			else splitor = "/";
			
			for each(var arg:String in args)
			{
				if(StringUtil.isNullOrEmpty(arg)) continue;
				
				if(path.lastIndexOf("\\") == (path.length - 1) || path.lastIndexOf("/") == (path.length - 1))
				{
					if(arg.indexOf("\\") == 0 || arg.indexOf("/") == 0) path = path + arg.substr(1);
					else path = path + arg;
				}
				else
				{
					if(arg.indexOf("\\") == 0 || arg.indexOf("/") == 0) path = path + arg;
					else path = path + splitor + arg;
				}
			}
			
			return path;
		}
	}
}