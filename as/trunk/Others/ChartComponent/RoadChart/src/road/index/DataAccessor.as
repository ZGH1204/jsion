package road.index
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	public class DataAccessor extends EventDispatcher
	{
		public static var gateway:String = "http://localhost:1473/getData.aspx";//"http://index.baidu.com/gateway.php";
        public static var snapshotInterface:String = "http://index.baidu.com/main/show.php";
        
		private var self:DataAccessor;
		
		public function DataAccessor()
		{
			self = this;
		}
		
		public function loadIndexes(keys:Array, areas:Array, periods:Array):void
		{
			var con:NetConnection = new NetConnection();
			con.addEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
			con.connect(gateway);
			var responder:Responder = new Responder(__resultHandler,__netStatusHandler);
			con.call("DataAccessor.getIndexes", responder, keys.join(","), areas.join(","), periods.join(","));
		}
		
		public function loadData(keys:Array, dataStartDate:String, dataEndDate:String):void
		{
			var obj:Object = {};
			
			obj["keys"] = keys.join("|");
			obj["sd"] = dataStartDate;
			obj["ed"] = dataEndDate;
			obj["custom"] = ConfigManager.customParam;
//			loadCallBack(null);
			new DataRequestLoader(gateway, obj).loadSync(loadCallBack);
		}
		
		public function sendSnapshot(param1:ByteArray) : void
		{
			var request:URLRequest = new URLRequest(snapshotInterface);
            request.data = param1;
            request.contentType = "application/octet-stream";
            request.method = URLRequestMethod.POST;
            navigateToURL(request, "_blank");
		}
		
		private function loadCallBack(loader:DataRequestLoader):void
		{
//			var str:String = '<root><data key="2010年5月13日" values="144,140,135,130,123,117,115,110,107,101,96,91,91,94,91,90,85,83,79,82,77,76,70,68,69,64,61,61,57,55,54,49,50,50,50,48,47,45,44,41,39,36,34,34,35,38,38,37,35,36,35,30,29,29,29,26,26,22,23,23,23,24,24,23,22,22,21,18,20,20,20,21,22,22,22,18,19,20,20,17,18,18,18,18,16,17,17,16,17,15,15,17,18,19,20,21,21,22,21,22,25,25,24,32,34,36,35,39,38,41,45,51,57,56,59,62,66,66,68,71,68,74,80,83,86,87,96,103,103,103,97,98,97,100,101,105,109,109,105,110,110,110,117,122,124,123,126,128,129,137,145,147,148,139,148,154,153,155,158,146,154,154,154,156,154,155,157,160,158,155,153,164,165,166,161,156,156,161,163,158,161,153,156,160,160,163,164,160,162,155,151,146,149,158,157,157,157,156,156,148,163,161,158,160,163,162,156,151,155,152,153,151,148,144,139,146,148,145,145,147,153,154,160,161,162,165,166,166,170,161,164,170,171,163,157,154,163,159,164,164,166,171,170,180,181,182,190,183,183,195,196,201,204,206,203,200,199,194,194,188,183,188,184,181,182,185,180,171,163,158,155,156,156,148,148,142,141,136,129,132,134,137,134,133,133,129,128,127,129" /><data key="2010年5月10日" values="129,125,121,121,116,114,110,103,96,95,96,92,88,80,78,72,70,71,68,71,72,70,68,64,65,63,61,56,56,56,55,57,59,58,58,57,56,55,53,51,48,49,47,47,48,44,47,43,40,42,43,42,41,41,40,39,39,39,37,40,41,40,37,35,33,34,34,33,34,34,31,29,31,29,27,25,24,22,22,23,24,24,26,24,23,21,23,21,21,19,19,22,22,20,21,20,22,21,22,26,26,29,33,36,34,35,37,41,41,44,45,45,43,45,51,50,49,50,54,57,61,66,63,67,66,72,74,78,82,80,85,84,84,80,76,79,78,78,87,88,88,94,88,92,92,93,97,101,107,104,108,111,115,120,120,126,130,127,128,125,126,134,127,120,120,118,119,118,120,119,119,117,118,120,119,125,125,125,128,133,135,137,136,135,133,132,135,135,138,136,137,138,142,143,137,141,146,141,138,141,138,137,141,140,141,139,137,135,140,141,139,150,141,145,145,147,144,141,139,139,141,142,142,133,141,140,142,134,138,144,146,152,149,152,161,163,163,165,173,172,180,185,183,178,180,178,174,177,176,184,185,187,188,189,190,198,196,193,189,195,199,202,198,190,193,194,187,188,188,184,183,184,186,180,175,168,167,162,152,145,140,141,136,131,128,122,113,112,113" /></root>';
//			var xml:XML = new XML(str);
//			var xl:XMLList = xml..data;
//			var dataList:Array = [];
//			for each(var x:XML in xl)
//			{
//				var obj:Object = {};
//				
//				obj.key = x.@key;
//				obj.userIndexes = x.@values;
//				obj.area = 0;
//				obj.areaName = "";
//				
//				dataList.push(obj);
//			}
//			var array:Array = operateIndexesData(dataList);
			var array:Array = operateIndexesData(loader.dataList.slice(0, loader.dataList.length));
			
			if(array.length > 0)
			{
				var de:DataEvent = new DataEvent(DataEvent.INDEXES_LOADED);
				
				de.data = array;
				
				self.dispatchEvent(de);
			}
			else
			{
				dispatchErrorEvent("数据加载失败!");
			}
		}
		
		private function __resultHandler(obj:Object):void
		{
			if(obj == -1)
			{
				trace("fault -1");
                dispatchErrorEvent("fault -1");
                return;
			}
			
			var de:DataEvent = new DataEvent(DataEvent.INDEXES_LOADED);
			
			var array:Array = operateIndexesData(obj as Array);
			
			de.data = array;
			obj = null;
			self.dispatchEvent(de);
		}
		
		private function operateIndexesData(array:Array) : Array
		{
			var singleObj:Object;
			var userIndexes:Array;
			var mediaIndexes:Array;
			
			for each(singleObj in array)
			{
				var userIndexesAry:Array = new String(singleObj.userIndexes).split(",");
//				var mediaIndexesAry:Array = new String(singleObj.mediaIndexes).split(",");
				var array1:Array = [];
//				var array2:Array = [];
				var intStr:String;
				for each(intStr in userIndexesAry)
				{
					var val:int = parseInt(intStr);
					if(isNaN(val))
					{
						array1.push(0);
					}
					else
					{
						array1.push(val);
					}
				}
				
//				for each(intStr in mediaIndexesAry)
//				{
//					array2.push(parseInt(intStr));
//				}
				singleObj.userIndexes = array1;
				singleObj.mediaIndexes = [];//array2;
			}
			
//			for each(singleObj in array)
//			{
//				var periodAry:Array = singleObj.period.split("|");
//				singleObj.startDate = DateFormatter.parse(periodAry[0], "YYYY-MM-DD hh:mm:ss");
//				singleObj.endDate = DateFormatter.parse(periodAry[1], "YYYY-MM-DD hh:mm:ss");
//				userIndexes = singleObj.userIndexes;
//				mediaIndexes = singleObj.mediaIndexes;
//				
//				var i:uint = 0;
//				var count:uint = userIndexes.length;
//				
//				while(i < count)
//				{
//					if(isNaN(userIndexes[i]))
//					{
//						userIndexes[i] = 0;
//					}
//					if(isNaN(mediaIndexes[i]))
//					{
//						mediaIndexes[i] = 0;
//					}
//					i++;
//				}
//			}
			
			return array;
		}
		
		private function __netStatusHandler(e:NetStatusEvent):void
		{
			trace("faultStatus");
            dispatchErrorEvent("faultStatus");
            return;
		}
		
		private function dispatchErrorEvent(param1:String) : void
        {
            var de:DataEvent = new DataEvent(DataEvent.ERROR);
            de.data = param1;
            dispatchEvent(de);
            return;
        }
	}
}