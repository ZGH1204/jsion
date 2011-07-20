package jutils.org.serialize.xml
{
	import jutils.org.util.*;

	public class XmlPropertyTransfer
	{
		public function encodingProperty(name:String, value:Object):String
		{
			var val:String;
			
			if(value == null) val = Constant.Empty;
			else if(String(value) == "NaN") val = "0";
			else if(value is Date) val = DateUtil.format(value as Date);
			else val = String(value);
			
			return StringUtil.escapeString(name) + "=\"" + val + "\" ";
		}
		
		public function encodingChildNode(name:String, value:Object):String
		{
			var val:String;
			
			if(value == null) val = Constant.Empty;
			else if(String(value) == "NaN") val = "0";
			else if(value is Date) val = DateUtil.format(value as Date);
			else val = String(value);
			
			return "<" + StringUtil.escapeString(name) + ">" + val + "</" + StringUtil.escapeString(name) + ">";
		}
		
		public function decodingProperty(obj:Object, tmp:Object, n:String, t:String):void
		{
			if(tmp.hasOwnProperty(n))
			{
				switch(t)
				{
					case "Boolean":
						obj[n] = (tmp[n] == "false" ? false : true);
						break;
					case "Date":
						obj[n] = DateUtil.parse(tmp[n] as String);
						break;
					case "Number":
						obj[n] = (tmp[n] == "NaN" ? 0 : Number(tmp[n]));
						break;
					default:
						obj[n] = tmp[n];
						break;
				}
			}
		}
	}
}