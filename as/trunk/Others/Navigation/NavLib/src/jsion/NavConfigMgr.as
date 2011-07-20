package jsion
{
	import com.managers.InstanceManager;
	import com.utils.ObjectHelper;
	
	import jsion.data.CityInfo;
	import jsion.data.CountyInfo;
	import jsion.data.ProvinceInfo;
	import jsion.data.TownInfo;

	public class NavConfigMgr
	{
		private var _provinceList:Vector.<ProvinceInfo> = new Vector.<ProvinceInfo>();
		private var _current:ProvinceInfo;

		public function get current():ProvinceInfo
		{
			return _current;
		}

		public function set current(value:ProvinceInfo):void
		{
			_current = value;
		}

		
		public function setup(config:XML):void
		{
			var selectedIndex:int = int(config.@SelectedIndex);
			
			var provinceXL:XMLList = config.Province;
			for each(var provinceXml:XML in provinceXL)
			{
				var province:ProvinceInfo = new ProvinceInfo();
				_provinceList.push(province);
				Util.parseXml(province, provinceXml, config);
				
				var cityXL:XMLList = provinceXml.City;
				for each(var cityXml:XML in cityXL)
				{
					var city:CityInfo = new CityInfo();
					province.cityList.push(city);
					ObjectHelper.copyPropertyToTargetBySource(province, city);
					city.countyList = new Vector.<CountyInfo>();
					city.townList = new Vector.<TownInfo>();
					Util.parseXml(city, cityXml);
					
					var countyXL:XMLList = cityXml.County;
					for each(var countyXml:XML in countyXL)
					{
						var county:CountyInfo = new CountyInfo();
						city.countyList.push(county);
						ObjectHelper.copyPropertyToTargetBySource(city, county);
						county.townList = new Vector.<TownInfo>();
						Util.parseXml(county, countyXml);
						
						var townXL:XMLList = countyXml.Town;
						for each(var townXml:XML in townXL)
						{
							var town:TownInfo = new TownInfo();
							county.townList.push(town);
							ObjectHelper.copyPropertyToTargetBySource(county, town);
							Util.parseXml(town, townXml);
						}
					}
				}
			}
			
			if(selectedIndex >= 0 && selectedIndex < _provinceList.length)
			{
				current = _provinceList[selectedIndex];
			}
			else
			{
				if(_provinceList.length > 0) current = _provinceList[0];
			}
		}
		
		public static function get Instance():NavConfigMgr
		{
			return InstanceManager.createSingletonInstance(NavConfigMgr) as NavConfigMgr;
		}
	}
}