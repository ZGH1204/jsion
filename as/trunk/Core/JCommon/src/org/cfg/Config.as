package org.cfg
{
	import jutils.org.util.XmlUtil;

	/**
	 * 配置信息全局类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class Config
	{
		public static var configXml:XML;
		
		private static var _config:ConfigInfo;
		
		public static function get config():ConfigInfo
		{
			return _config;
		}
		
		public static function setup(config:XML, cfg:ConfigInfo = null):void
		{
			configXml = config;
			_config = cfg == null ? new ConfigInfo() : cfg;
			XmlUtil.decodeWithProperty(_config, config.config[0]);
		}
	}
}