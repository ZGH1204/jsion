package jsion.core.serialize.xml
{
	import flash.utils.*;
	
	import jsion.utils.*;
	
	public class XmlPropertySerialize implements IXmlSerialize
	{
		private var transfer:XmlPropertyTransfer;
		
		public function XmlPropertySerialize()
		{
			transfer = new XmlPropertyTransfer();
		}
		
		public function encode(nodeName:String, obj:Object):XML
		{
			var rlt:String = "<" + nodeName + " ";
			
			var describe:XML = describeType(obj);
			
			for each ( var v:XML in describe..*.( name() == "variable" || name() == "accessor" ) )
			{
				var n:String = v.@name.toString();
				rlt += transfer.encodingProperty(n, obj[n]);
			}
			
			rlt += "/>";
			
			return new XML(rlt);
		}
		
		public function decode(obj:Object, xml:XML):void
		{
			var attributes:XMLList = xml.attributes();
			var tmp:Object = {};
			var x:XML;
			for each(x in attributes)
			{
				tmp[String(x.name())] = String(x);
			}
			
			
			var xl:XMLList = describeType(obj)..*.(name() == "variable" || name() == "accessor");
			for each(x in xl)
			{
				var t:String = String(x.@type);
				var n:String = String(x.@name);
				transfer.decodingProperty(obj, tmp, n, t);
			}
		}
	}
}