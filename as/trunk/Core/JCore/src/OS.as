package
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * 操作系统类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class OS
	{
		/**
		 * 指定运行内容的系统的语言代码。
		 * <br /><br />
		 * 语言　　　　值 <br /><br />
		 * 
		 * 捷克语　　　cs <br />
		 * 丹麦语　　　da <br />
		 * 荷兰语　　　nl <br />
		 * 英语　　　　en <br />
		 * 芬兰语　　　fi <br />
		 * 法语　　　　fr <br />
		 * 德语　　　　de <br />
		 * 匈牙利语　　hu <br />
		 * 意大利语　　it <br />
		 * 日语　　　　ja <br />
		 * 韩语　　　　ko <br />
		 * 挪威语　　　no <br />
		 * 波兰语　　　pl <br />
		 * 葡萄牙语　　pt <br />
		 * 俄语　　　　ru <br />
		 * 简体中文　　zh-CN <br />
		 * 西班牙语　　es <br />
		 * 瑞典语　　　sv <br />
		 * 繁体中文　　zh-TW <br />
		 * 土耳其语　　tr <br />
		 * 其它/未知 　xu 
		 * @return 
		 * 
		 */		
		public static function get language():String
		{
			return Capabilities.language;
		}
		
		/**
		 * 当前的操作系统。 
		 * os 属性可返回下列字符串：
		 * “Windows XP”、“Windows 2000”、“Windows NT”、“Windows 98/ME”、“Windows 95”、
		 * “Windows CE”（仅在 Flash Player SDK 中可用，在台式机版本中不可用）、“Linux”
		 * 以及“Mac OS X.Y.Z”（其中的 X.Y.Z 为版本号，例如：Mac OS 10.5.2）。
		 * 服务器字符串为 OS。
		 * @return 
		 * 
		 */		
		public static function get os():String
		{
			return Capabilities.os;
		}
		
		/**
		 * 指定运行时环境的类型。此属性可以是下列值之一：<br />
		 * "StandAlone"，用于独立的 Flash Player<br />
		 * "External"，用于外部 Flash Player 或处于测试模式下<br />
		 * "PlugIn"，代表 Flash Player 浏览器插件（和通过 AIR 应用程序中的 HTML 页加载的 SWF 内容）<br />
		 * "ActiveX"，用于 Microsoft Internet Explorer 使用的 Flash Player ActiveX 控件<br />
		 * "Desktop"代表 Adobe AIR 运行时（通过 HTML 页加载的 SWF 内容除外，该内容将 Capabilities.playerType 设置为“PlugIn”）<br />
		 * "External"，用于外部 Flash Player 或处于测试模式下
		 * @return 
		 * 
		 */		
		public static function get playerType():String
		{
			return Capabilities.playerType;
		}
		
		/**
		 * 指定系统是否有音频功能。
		 * @return 
		 * 
		 */		
		public static function get hasAudio():Boolean
		{
			return Capabilities.hasAudio;
		}
		
		/**
		 * 指定系统是否安装了输入法编辑器 (IME)，如果是，则为 true，否则为 false。
		 * @return 
		 * 
		 */		
		public static function get hasIME():Boolean
		{
			return Capabilities.hasIME;
		}
		
		/**
		 * 指定系统是否具有 MP3 解码器，如果是，则为 true，否则为 false。
		 * @return 
		 * 
		 */		
		public static function get hasMP3():Boolean
		{
			return Capabilities.hasMP3;
		}
		
		/**
		 * 指定系统使用的是特殊的调试软件 (true)，还是正式发布的版本 (false)。
		 * @return 
		 * 
		 */		
		public static function get isDebugger():Boolean
		{
			return Capabilities.isDebugger;
		}
		
		
		/**
		 * 指定主显示器的分辨率。 
		 * 此属性不会随用户的屏幕分辨率而更新，而仅指示 Flash Player 或 Adobe AIR 应用程序启动时的分辨率。
		 * 服务器无效。
		 * @return 
		 * 
		 */		
		public static function get resolution():Rectangle
		{
			try
			{
				return new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			}
			catch(err:Error) {}
			
			return new Rectangle(0, 0, 0, 0);
		}
	}
}