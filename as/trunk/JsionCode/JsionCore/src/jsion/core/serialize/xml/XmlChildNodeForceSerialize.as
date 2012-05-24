package jsion.core.serialize.xml
{
	import flash.utils.describeType;

	/**
	 * XML强制序列化属性为Xml子节点(for in 方式)
	 * @author Jsion
	 * 
	 */	
	public class XmlChildNodeForceSerialize implements IXmlSerialize
	{
		private var transfer:XmlPropertyTransfer;
		
		public function XmlChildNodeForceSerialize()
		{
			transfer = new XmlPropertyTransfer();
		}
		
		/**
		 * @copy jsion.core.serialize.xml.IXmlSerialize#encode()
		 */		
		public function encode(nodeName:String, obj:Object):XML
		{
			var rlt:String = "<" + nodeName + ">";
			
			//var describe:XML = describeType(obj);
			
			//for each ( var v:XML in describe..*.( name() == "variable" || name() == "accessor" ) )
			for(var n:String in obj)
			{
				rlt = rlt + "\r\n    " + transfer.encodingChildNode(n, obj[n]);
			}
			
			rlt += "\r\n</" + nodeName + ">";
			
			var xml:XML = new XML(rlt);
			
			return xml;
		}
		
		/**
		 * @copy jsion.core.serialize.xml.IXmlSerialize#decode()
		 */		
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