package jsion.core.serialize.xml
{
	import jsion.Constant;
	import jsion.utils.*;

	/**
	 * Xml属性转换
	 * @author Jsion
	 * 
	 */	
	public class XmlPropertyTransfer
	{
		/**
		 * 生成指定对象属性的Xml属性
		 * @param name 对象属性名
		 * @param value 对象属性值
		 * @return Xml属性字符串
		 * 
		 */		
		public function encodingProperty(name:String, value:Object):String
		{
			var val:String;
			
			if(value == null) val = Constant.Empty;
			else if(String(value) == "NaN") val = "0";
			else if(value is Date) val = DateUtil.format(value as Date);
			else val = String(value);
			
			return StringUtil.escapeString(name) + "=\"" + val + "\" ";
		}
		
		/**
		 * 生成指定对象属性的Xml子节点
		 * @param name 对象属性名
		 * @param value 对象属性值
		 * @return Xml子节点字符串
		 * 
		 */		
		public function encodingChildNode(name:String, value:Object):String
		{
			var val:String;
			
			if(value == null) val = Constant.Empty;
			else if(String(value) == "NaN") val = "0";
			else if(value is Date) val = DateUtil.format(value as Date);
			else val = String(value);
			
			return "<" + StringUtil.escapeString(name) + ">" + val + "</" + StringUtil.escapeString(name) + ">";
		}
		
		/**
		 * 解析并设置属性值到指定对象上
		 * @param obj 要设置属性的对象
		 * @param tmp 包含属性值的对象
		 * @param n 属性名称
		 * @param t 属性类型
		 * 
		 */		
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