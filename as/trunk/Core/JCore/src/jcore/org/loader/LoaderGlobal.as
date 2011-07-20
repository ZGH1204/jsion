package jcore.org.loader
{
	import jutils.org.util.StringUtil;

	public class LoaderGlobal
	{
		public static const StatusInitialized:String = "initialized";
		public static const StatusStarted:String = "started";
		public static const StatusStopped:String = "stopped";
		public static const StatusFinished:String = "finished";
		public static const StatusError:String = "error";
		public static const StatusGetBytesTotal:String = "getBytesTotal";
		
		/**
		 * 默认同时加载数
		 */		
		public static const DefaultMaxLoadings:int = 8;
		
		/**
		 * 未知资源类型
		 */		
		public static const TYPE_UNDEFINED:String = "undefined";
		
		/**
		 * 二进制资源类型
		 */		
		public static const TYPE_BINARY:String = "binary";
		
		/**
		 * 图像资源类型
		 */		
		public static const TYPE_IMAGE:String = "image";
		
		/**
		 * 文本资源类型
		 */		
		public static const TYPE_TEXT:String = "text";
		
		/**
		 * Xml资源类型
		 */		
		public static const TYPE_XML:String = "xml";
		
		/**
		 * swf格式的类库资源类型
		 */		
		public static const TYPE_LIB:String = "lib";
		
		/**
		 * swc格式的类库资源类型
		 */		
		public static const TYPE_SWC:String = "swc";
		
		/**
		 * 声音资源类型
		 */		
		public static const TYPE_SOUND:String = "sound";
		
		/**
		 * swf格式的影片剪辑资源类型
		 */		
		public static const TYPE_MOVIECLIP:String = "movieClip";
		
		/**
		 * 视频资源类型
		 */		
		public static const TYPE_VIDEO:String = "video";
		
		/**
		 * 受支持的所有资源类型列表
		 */		
		internal static var AVAILABLE_TYPE:Array = [TYPE_BINARY, TYPE_IMAGE, TYPE_TEXT, TYPE_XML, TYPE_LIB, TYPE_SWC, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_VIDEO];
		
		/**
		 * 受支持的所有资源扩展名列表
		 */		
		internal static var AVAILABLE_EXTENSIONS : Array = ["jpg", "jpeg", "png", "gif", "txt", "js", "xml", "swf", "lib", "swc", "mp3", "flv" ];
		
		/**
		 * 与扩展名相对应的默认资源类型
		 */		
		internal static var EXTENSION_DEFAULT_TYPE:Object = {
			"jpg" 	: TYPE_IMAGE,
			"jpeg" 	: TYPE_IMAGE,
			"png" 	: TYPE_IMAGE,
			"gif" 	: TYPE_IMAGE,
			"txt" 	: TYPE_TEXT,
			"js"	: TYPE_TEXT,
			"xml" 	: TYPE_XML,
			"swf"	: TYPE_MOVIECLIP,
			"lib"	: TYPE_LIB,
			"swc"	: TYPE_SWC,
			"mp3"	: TYPE_SOUND,
			"flv"	: TYPE_VIDEO
		};
		
		/**
		 * 与资源类型相对应的加载类
		 */		
		internal static var TYPE_LOADER_CLASS:Object = {
			"binary"	: BinaryLoader,
			"image"		: ImageLoader,
			"text"		: TextLoader,
			"xml"		: XmlLoader,
			"lib"		: LibLoader,
			"swc"		: SwcLoader,
			"sound"		: SoundLoader,
			"movieClip"	: ImageLoader,
			"video"		: VideoLoader
		};
		
		
		/**
		 * 获取猜测后的资源类型，猜测失败时返回 JLoaders.TYPE_UNDEFINED。
		 * @param url 文件的路径
		 * @return 资源类型
		 * 
		 */		
		public static function guessType(url:String):String
		{
			var ext:String = JUtil.getExtension(url);
			
			if(StringUtil.isNotNullOrEmpty(ext))
			{
				var type:String = EXTENSION_DEFAULT_TYPE[ext];
				
				if(StringUtil.isNotNullOrEmpty(type)) return type;
			}
			
			return TYPE_UNDEFINED;
		}
		
		/**
		 * 注册新的扩展名、资源类型、加载类。
		 * @param ext 扩展名
		 * @param type 资源类型
		 * @param cls 加载类
		 * @throws ArgumentError 参数错误，有一个或多个参数为空。
		 */		
		public static function registeNewType(ext:String, type:String, cls:Class):void
		{
			if(StringUtil.isNullOrEmpty(ext) || StringUtil.isNullOrEmpty(type) || cls == null)
			{
				throw new ArgumentError("参数错误，有一个或多个参数为空。");
				return;
			}
			
			var index:int = ext.lastIndexOf(".");
			var lstExt:String;
			
			if(index == -1) lstExt = ext;
			else lstExt = ext.substr(index + 1);
			
			if(AVAILABLE_EXTENSIONS.indexOf(lstExt) == -1) AVAILABLE_EXTENSIONS.push(lstExt);
			
			if(EXTENSION_DEFAULT_TYPE[lstExt] == null) EXTENSION_DEFAULT_TYPE[lstExt] = type;
			
			if(AVAILABLE_TYPE.indexOf(type) == -1) AVAILABLE_TYPE.push(type);
			
			if(TYPE_LOADER_CLASS[type] == null) TYPE_LOADER_CLASS[type] = cls;
		}
	}
}