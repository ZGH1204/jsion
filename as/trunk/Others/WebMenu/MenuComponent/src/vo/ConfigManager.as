package vo
{
	import com.managers.InstanceManager;
	import com.utils.StringHelper;
	
	import vo.data.MenuConfig;
	import vo.data.MenuItemConfig;

	public class ConfigManager
	{
		private var configList:Array;
		private var config:MenuConfig;
		
		public function setup(list:Array):void
		{
			if(isSetup() || list == null || list.length == 0) return;
			configList = list;
		}
		
		public function select(id:String):void
		{
			if(isSetup() == false) return;
			
			if(StringHelper.isNullOrEmpty(id))
			{
				config = configList[0] as MenuConfig;
				return;
			}
			
			for each(var mc:MenuConfig in configList)
			{
				if(mc.id == id)
				{
					config = mc;
					return;
				}
			}
		}
		
		public function isSetup():Boolean
		{
			return (configList != null);
		}
		
		public function isSelect():Boolean
		{
			return (config != null);
		}
		
		public function get current():MenuConfig
		{
			return config;
		}
		
		public function getItemConfigByIndex(index:int):MenuItemConfig
		{
			if(index < config.itemList.length)
				return config.itemList[index] as MenuItemConfig;
			return null;
		}
		
		public static function get Instance():ConfigManager
		{
			return InstanceManager.createSingletonInstance(ConfigManager) as ConfigManager;
		}
	}
}