package road.index
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class ConfigManager
	{
		//曲线的时间单位，可能的值有：“日期”，“小时”，“分钟”，“5分钟”
        public static var minShowUnit:String = "5分钟";
        //显示时的最小时间间隔
        public static var minShowDistance:Number = 1;
        //显示曲线的结束日期时间,也是所有数据的截止时间
        public static var showEndDate:Date = new Date(2010,4,14);
        //所有数据的起始时间
        public static var START_DATA_DATE:Date = new Date(2010,4,13);
        //定时请求数据时间间隔(秒)
        public static var TimeInterval:Number = 0;
        //显示时的初始时间间隔
        public static var initShowDistance:Number = 3;
        //曲线线条颜色
        public static var COLORS_OF_GRAPHS:Array = [0xFFA333, 0x009149, 0x0058C6, 0xA918BA, 0x666633, 0xFF00CC];
        //显示首尾的完整刻度标签
        public static var showIntactLabel:Boolean = true;
        //显示垂直分隔线
        public static var showVerticalSplitLine:Boolean = true;
        //显示水平分隔线
        public static var showHorizontalSplitLine:Boolean = true;
        //自定义参数
        public static var customParam:String = "";
        
        public static var ChartTitle:String = "";
        
        public static var paramKeys:Array = [];
        
        
        public static const SECOND_TIME_VALUE:Number = 1000;//秒
        public static const MINUTE_TIME_VALUE:Number = 60000;//分
        public static const HOUR_TIME_VALUE:Number = 3.6e+006;//小时
        public static const DAY_TIME_VALUE:Number = 8.64e+007;//天
        public static const WEEK_TIME_VALUE:Number = 6.048e+008;//周
        public static const MONTH_TIME_VALUE:Number = 2.592e+009;//月
        public static const QUARTER_TIME_VALUE:Number = 7.776e+009;//季
        public static const YEAR_TIME_VALUE:Number = 3.1536e+010;//年
        
        public static var intervalHnd:uint;
        
        public static function setTimeInterval(intervalFunc:Function):void
        {
        	if(TimeInterval > 0)
        	{
        		intervalHnd = setInterval(intervalFunc, TimeInterval * 1000);
        	}
        }
        
        public static function clearTimeInterval():void
        {
        	if(intervalHnd != 0)
        		clearInterval(intervalHnd);
        	intervalHnd = 0;
        }
        
        public static function getCalcValueByUnit():Number
		{
			var result:Number;
			switch(minShowUnit)
			{
				case "分钟":
				{
					result = MINUTE_TIME_VALUE;
					break;
				}
				case "5分钟":
				{
					result = MINUTE_TIME_VALUE * 5;
					break;
				}
				case "小时":
				{
					result = HOUR_TIME_VALUE;//MINUTE_TIME_VALUE * 5;
					break;
				}
				case "日期":
				{
					result = DAY_TIME_VALUE;
					break;
				}
				default:
				{
					result = DAY_TIME_VALUE;
				}
			}
			
			return result;
		}
		
		public static function getFormatString():String
		{
			var result:String;
			switch(minShowUnit)
			{
				case "分钟":
				{
					result = "YYYY-MM-DD hh:mm";
					break;
				}
				case "5分钟":
				{
					result = "MM-DD hh:mm";
					break;
				}
				case "小时":
				{
					result = "YYYY-MM-DD hh";
					break;
				}
				case "日期":
				{
					result = "YYYY-MM-DD";
					break;
				}
				default:
				{
					result = "YYYY-MM-DD";
				}
			}
			
			return result;
		}
	}
}