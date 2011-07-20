package jutils.org.util
{
	/**
	 * 日期工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class DateUtil
	{
		/**
		 * 解析日期时间字符串为Date对象
		 * @param dateTime 日期时间字符串
		 * @return Date对象
		 * 
		 */		
		public static function parse(dateTime:String):Date
		{
			if(StringUtil.isNullOrEmpty(dateTime)) return null;
			
			var year:int, month:int, day:int, hour:int, minutes:int, second:int;
			
			var dateAndTime:Array = dateTime.split(" ");
			
			var dateList:Array = String(dateAndTime[0]).split("-"), timeList:Array;
			
			if(dateAndTime.length == 2)
			{
				timeList = String(dateAndTime[1]).split(":");
			}
			
			if(dateList.length > 0)
				year = int(dateList[0]);
			if(dateList.length > 1)
				month = int(dateList[1]);
			(dateList.length > 2)
				day = int(dateList[2]);
			
			if(timeList)
			{
				if(timeList.length > 0)
					hour = int(timeList[0]);
				if(timeList.length > 1)
					minutes = int(timeList[1]);
				if(timeList.length > 2)
					second = int(timeList[2]);
			}
			
			return new Date(year, month - 1, day, hour, minutes, second);
		}
		/**
		 * 格式化Date对象为指定格式的日期时间字符串
		 * @param date Date对象
		 * @param formatStr 格式字符串中仅包含[YMDhms-:]8种字符, 如 YYYY-MM-DD hh:mm:ss
		 * @return 日期时间字符串
		 * 
		 */		
		public static function format(dateParam:Date, formatStr:String = "YYYY-MM-DD hh:mm:ss"):String
		{
			var str:String;
			var date:Date = dateParam;
			if(date == null) date = new Date(1970, 0, 1, 0, 0, 0, 0);
			str = formatStr.replace(/([YMDhms])\1*/g, function (param1:*,param2:*,param3:*,param4:*) : String
			{
				var vStr:String;
				var fStr:String = param1 as String;
				switch(fStr.charAt())
				{
					case "Y":
					{
						vStr = IntUtil.getIntStrByLength(date.getFullYear(), fStr.length);
						break;
					}
					case "M":
					{
						vStr = IntUtil.getIntStrByLength(date.getMonth() + 1, fStr.length);
						break;
					}
					case "D":
					{
						vStr = IntUtil.getIntStrByLength(date.getDate(), fStr.length);
						break;
					}
					case "h":
					{
						vStr = IntUtil.getIntStrByLength(date.getHours(), fStr.length);
						break;
					}
					case "m":
					{
						vStr = IntUtil.getIntStrByLength(date.getMinutes(), fStr.length);
						break;
					}
					case "s":
					{
						vStr = IntUtil.getIntStrByLength(date.getSeconds(), fStr.length);
						break;
					}
					default:
					{
						break;
					}
				}
				return vStr;
			}// end function
			);
			return str;
		}
		
		/**
		 * 根据时间格式化字符串获取时间字符串
		 * @param seconds 时间的总秒数
		 * @param formatStr 时间格式化字符串,仅包含[hms:]四种字符,如 hh:mm:ss
		 * @return 
		 * 
		 */		
		public static function getTimeStr(seconds:int, formatStr:String = "hh:mm:ss"):String
		{
			var str:String;
			var secondsParam:int = seconds;
			if(secondsParam < 0)
				secondsParam = 0;
			
			str = formatStr.replace(/([hms])\1*/g, function(param1:*,param2:*,param3:*,param4:*):String{
				var vStr:String;
				var fStr:String = param1 as String;
				switch(fStr.charAt())
				{
					case "h":
					{
						vStr = IntUtil.getIntStrByLength(Math.floor(secondsParam / 3600), fStr.length);
						break;
					}
					case "m":
					{
						vStr = IntUtil.getIntStrByLength(Math.floor((secondsParam % 3600) / 60), fStr.length);
						break;
					}
					case "s":
					{
						vStr = IntUtil.getIntStrByLength(Math.floor(((secondsParam % 3600) % 60)), fStr.length);
						break;
					}
					default:
						break;
				}
				
				return vStr;
			});
			
			return str;
		}
		
		/**
		 * 获取时间字符串的总秒数
		 * @param timeStr 时间字符串
		 * @param formatStr 时间格式化字符串
		 * @return 
		 * 
		 */		
		public static function getTime(timeStr:String, formatStr:String):int
		{
			var tList:Array = timeStr.split(":");
			var fList:Array = formatStr.split(":");
			
			var seconds:int = 0;
			
			if(tList.length != fList.length)
			{
				throw new ArgumentError("The 'timeStr' and 'formatStr' count of split by ':' is not euqal.");
				return seconds;
			}
			
			for(var i:uint = 0; i < fList.length; i++)
			{
				var str:String = fList[i];
				switch(str.charAt())
				{
					case "h":
					{
						seconds = seconds + int(tList[i]) * 3600;
						break;
					}
					case "m":
					{
						seconds = seconds + int(tList[i]) * 60;
						break;
					}
					case "s":
					{
						seconds = seconds + int(tList[i]);
						break;
					}
					default:
						break;
				}
			}
			
			return seconds;
		}
	}
}