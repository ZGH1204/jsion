package knightage.core
{
	import jsion.utils.XmlUtil;

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
		
		private static var _LoaderCfg:Object;
		
		public static function get config():ConfigInfo
		{
			return _config;
		}
		
		public static function get LoaderCfg():Object
		{
			return _LoaderCfg;
		}
		
		public static function setup(config:XML, cfg:ConfigInfo = null):void
		{
			configXml = config;
			_config = cfg == null ? new ConfigInfo() : cfg;
			XmlUtil.decodeWithProperty(_config, config.config[0]);
			
			_LoaderCfg = { root: _config.ResRoot };
		}
	}
}