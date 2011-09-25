package jsion.core.serialize.xml
{
	import flash.utils.describeType;

	public class XmlPropForceSerialize implements IXmlSerialize
	{
		private var transfer:XmlPropertyTransfer;
		
		public function XmlPropForceSerialize()
		{
			transfer = new XmlPropertyTransfer();
		}
		
		public function encode(nodeName:String, obj:Object):XML
		{
			var rlt:String = "<" + nodeName + " ";
			
			//var describe:XML = describeType(obj);
			
			//for each ( var v:XML in describe..*.( name() == "variable" || name() == "accessor" ) )
			for(var n:String in obj)
			{
				if(obj[n] is Function) continue;
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
			
			for(var n:String in tmp)
			{
				if(tmp[n] is Function) continue;
				
				var t:String;
				
				var rlt:XMLList = (xl.(@name == n));
				if(rlt && rlt.length() > 0)
				{
					t = String(rlt[0].@type);
				}
				else
				{
					t = "String";
				}
				
				transfer.decodingProperty(obj, tmp, n, t);
			}
		}
	}
}