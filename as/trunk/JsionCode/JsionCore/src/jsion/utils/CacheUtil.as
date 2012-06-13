package jsion.utils
{
	public class CacheUtil
	{
		/**
		 * 替换掉http://..../ 
		 */		
		private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
		/**
		 * 替换: :|.|\/|\\
		 */		
		private static const _reg2:RegExp = /[:|.|\/|\\]/g;
		
		/**
		* 将路径转换为字典键
		* @param path 路径
		* @return 字典键
		* 
		*/		
		public static function path2Key(path:String):String
		{
			var index:int = path.indexOf("?");
			var key:String = path.substring(0, (index == -1 ? int.MAX_VALUE : index));
			
			key = key.replace(_reg1,"");
			key = key.replace(_reg2,"_");
			
			return key;
		}
		
		/**
		 * 获取指定路径中文件的扩展名
		 * @param url 文件的路径
		 * @return 扩展名
		 * 
		 */		
		public static function getExtension(url:String):String
		{
			var startIndex:int = url.lastIndexOf("/");
			if(startIndex == -1) startIndex = 0;
			
			var endIndex:int = url.indexOf("?");
			if(endIndex == -1) endIndex = url.length;
			
			var name:String = url.substring(startIndex, endIndex);
			var dotIndex:int = name.lastIndexOf(".");
			if(dotIndex == -1) return null;
			var ext:String = name.substr(dotIndex + 1);
			return ext;
		}
	}
}