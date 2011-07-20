package road.index
{
	import road.lib.request.RequestLoader;
	import road.lib.utils.DateFormatter;

	public class DataRequestLoader extends RequestLoader
	{
		public var dataList:Array = [];
		
		public function DataRequestLoader(path:String, params:Object=null)
		{
			super(path, params);
		}
		
		override protected function onRequestReturn(xml:XML):void
		{
			var sd:Date = DateFormatter.parse(String(xml.@startDate), "YYYY-MM-DD hh:mm:ss");
			var ed:Date = DateFormatter.parse(String(xml.@endDate), "YYYY-MM-DD hh:mm:ss");
			var custom:String = String(xml.@custom);
			
			if(isNaN(ed.fullYear) == false && isNaN(sd.fullYear) == false)
			{
				ConfigManager.START_DATA_DATE = DateFormatter.parse(String(xml.@startDate), "YYYY-MM-DD hh:mm:ss");
				ConfigManager.showEndDate = DateFormatter.parse(String(xml.@endDate), "YYYY-MM-DD hh:mm:ss");
			}
			
			if(custom != null && custom != "null")
			{
				ConfigManager.customParam = custom;
			}
			
			var xl:XMLList = xml..data;
			
			for each(var x:XML in xl)
			{
				var obj:Object = {};
				
				obj.key = x.@key;
				obj.userIndexes = x.@values;
				obj.area = 0;
				obj.areaName = "";
				
				dataList.push(obj);
			}
		}
	}
}