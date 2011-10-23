package jsion.utils
{
	public class PathUtil
	{
		public static function combinPath(...args):String
		{
			var path:String = "";
			
			if(args.length <= 0) return path;
			else if(args.length == 1) return args[0];
			else path = args.shift();
			
			var splitor:String;
			
			if(path.lastIndexOf("\\") != -1) splitor = "\\";
			else splitor = "/";
			
			for each(var arg:String in args)
			{
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