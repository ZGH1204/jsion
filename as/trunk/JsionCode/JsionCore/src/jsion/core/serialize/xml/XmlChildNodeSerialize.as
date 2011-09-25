package jsion.core.serialize.xml
{
	import flash.utils.*;
	
	import jsion.utils.*;
	
	public class XmlChildNodeSerialize implements IXmlSerialize
	{
		private var transfer:XmlPropertyTransfer;
		
		public function XmlChildNodeSerialize()
		{
			transfer = new XmlPropertyTransfer();
		}
		
		public function encode(nodeName:String, obj:Object):XML
		{
			var rlt:String = "<" + nodeName + ">";
			
			var describe:XML = describeType(obj);
			
			for each ( var v:XML in describe..*.( name() == "variable" || name() == "accessor" ) )
			{
				var n:String = v.@name.toString();
				rlt = rlt + "\r\n    " + transfer.encodingChildNode(n, obj[n]);
			}
			
			rlt += "\r\n</" + nodeName + ">";
			
			var xml:XML = new XML(rlt);
			
			return xml;
		}
		
		public function decode(obj:Object, xml:XML):void
		{
			var children:XMLList = xml.children();
			var tmp:Object = {};
			var x:XML;
			for each(x in children)
			{
				tmp[String(x.name())] = String(x.valueOf());
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