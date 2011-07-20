package road.lib.utils
{
	public class DateFormatter
	{
		private static function getIntStrAtLength(param1:uint, param2:uint) : String
        {
            var _loc_3:* = param1.toString();
            if (param2 > 1)
            {
                if (_loc_3.length > param2)
                {
                    _loc_3 = _loc_3.substr(-param2);
                }
                else
                {
                    while (_loc_3.length < param2)
                    {
                        
                        _loc_3 = "0" + _loc_3;
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function parse(param1:String, param2:String) : Date
        {
            var date:Date;
            var str:* = param1;
            var formatStr:* = param2;
            str = escape(str);
            formatStr = escape(formatStr);
            date = new Date(0);
            formatStr.replace(/([YMDhms])\1*/g, function (param1:*,param2:*,param3:*,param4:*) : String
            {
                var _loc_2:* = param1 as String;
                var _loc_3:* = param3;
                var _loc_4:* = parseInt(str.substr(_loc_3, _loc_2.length));
                switch(_loc_2.charAt())
                {
                    case "Y":
                    {
                        date.fullYear = _loc_4;
                        break;
                    }
                    case "M":
                    {
                        date.month = _loc_4-1;
                        break;
                    }
                    case "D":
                    {
                        date.date = _loc_4;
                        break;
                    }
                    case "h":
                    {
                        date.hours = _loc_4;
                        break;
                    }
                    case "m":
                    {
                        date.minutes = _loc_4;
                        break;
                    }
                    case "s":
                    {
                        date.seconds = _loc_4;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                return "";
            }// end function
            );
            return date;
        }// end function

        public static function format(param1:Date, param2:String) : String
        {
            var str:String;
            var date:* = param1;
            var formatStr:* = param2;
            str = formatStr.replace(/([YMDhms])\1*/g, function (param1:*,param2:*,param3:*,param4:*) : String
            {
                var _loc_3:*;
                var _loc_2:* = param1 as String;
                switch(_loc_2.charAt())
                {
                    case "Y":
                    {
                        _loc_3 = getIntStrAtLength(date.getFullYear(), _loc_2.length);
                        break;
                    }
                    case "M":
                    {
                        _loc_3 = getIntStrAtLength(date.getMonth() + 1, _loc_2.length);
                        break;
                    }
                    case "D":
                    {
                        _loc_3 = getIntStrAtLength(date.getDate(), _loc_2.length);
                        break;
                    }
                    case "h":
                    {
                        _loc_3 = getIntStrAtLength(date.getHours(), _loc_2.length);
                        break;
                    }
                    case "m":
                    {
                        _loc_3 = getIntStrAtLength(date.getMinutes(), _loc_2.length);
                        break;
                    }
                    case "s":
                    {
                        _loc_3 = getIntStrAtLength(date.getSeconds(), _loc_2.length);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                return _loc_3;
            }// end function
            );
            return str;
        }// end function
	}
}