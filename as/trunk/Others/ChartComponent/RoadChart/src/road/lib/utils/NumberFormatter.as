package road.lib.utils
{
	public class NumberFormatter
	{
		public static function format(param1:Number, param2:String) : String
        {
            var str:String;
            var decStr:String;
            var num:* = param1;
            var formatStr:* = param2;
            var numStr:* = num.toString();
            var tempAry:* = numStr.split(".");
            var intStr:* = tempAry[0];
            decStr = tempAry.length > 1 ? (tempAry[1]) : ("");
            str = formatStr.replace(/I+/g, intStr);
            str = str.replace(/D+/g, function (param1:*, param2:*,param3:*,param4:*) : String
            {
                var _loc_2:* = param1 as String;
                var _loc_3:* = decStr;
                if (_loc_3.length > _loc_2.length)
                {
                    _loc_3 = _loc_3.substr(0, _loc_2.length);
                }
                else
                {
                    while (_loc_3.length < _loc_2.length)
                    {
                        
                        _loc_3 = _loc_3 + "0";
                    }
                }
                return _loc_3;
            }// end function
            );
            return str;
        }// end function
	}
}