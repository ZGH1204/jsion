package tool.xmlformats
{
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;
	import jsion.utils.StringUtil;
	
	public class XmlNode implements IDispose
	{
		private static const SpliteCount:int = 4;
		
		public var xml:XML;
		
		public var xmlList:XMLList;
		
		public var parent:XmlNode;
		
		public var attributes:Array;
		
		public var attributeVals:Array;
		
		public var attributeLens:Array;
		
		public var children:Array;
		
		public function XmlNode()
		{
			attributes = [];
			
			attributeVals = [];
			
			attributeLens = [];
			
			children = [];
			
			parent = this;
		}
		
		public function parseXML(x:XML):String
		{
			parseXMLToXmlNode(x, this);
			
			calcChildAttributesLen();
			
			return getString();
		}
		
		protected function calcChildAttributesLen():void
		{
			if(children.length != 0)
			{
				var node:XmlNode = children[0] as XmlNode;
				
				if(node.attributes.length != 0)
				{
					for(var i:int = 0; i < node.attributes.length; i++)
					{
						var rlt:int = 0;
						var tmp:XmlNode;
						var name:String = node.attributes[i];
						
						for each(tmp in children)
						{
							tmp.updateAttribute(name, i);
							
							var value:String = tmp.getAttributeValue(name);
							var len:int = StringUtil.getRealLength(value) + name.length + 3;
							
							rlt = Math.max(rlt, len);
						}
						
						if((rlt % SpliteCount) > 0)
						{
							rlt = (rlt / SpliteCount + 1) * SpliteCount;
						}
						
						//node.attributeLens[i] = rlt;
						//trace("属性:", name, "最大长度为:", rlt);
						
						for each(tmp in children)
						{
							tmp.setAttributeLen(name, rlt);
						}
					}
				}
				
				for each(var temp:XmlNode in children)
				{
					temp.calcChildAttributesLen();
				}
			}
		}
		
		private function updateAttribute(name:String, index:int):void
		{
			var i:int = attributes.indexOf(name);
			
			if(i == -1) return;
			
			if(i != index)
			{
				var obj:*;
				
				attributes.splice(i, 1);
				ArrayUtil.insert(attributes, name, index);
				
				obj = attributeVals.splice(i, 1);
				ArrayUtil.insert(attributeVals, obj, index);
				
				obj = attributeLens.splice(i, 1);
				ArrayUtil.insert(attributeLens, obj, index);
			}
		}
		
		private function getAttributeName(index:int):String
		{
			if(index < 0 || index >= attributes.length) return "";
			
			return attributes[index];
		}
		
		private function getAttributeValue(name:String):String
		{
			var index:int = attributes.indexOf(name);
			
			if(index == -1) return "";
			
			return attributeVals[index];
		}
		
		private function getAttributeLen(name:String):int
		{
			var index:int = attributes.indexOf(name);
			
			if(index == -1) return 0;
			
			return attributeLens[index];
		}
		
		private function setAttributeLen(name:String, len:int):void
		{
			var index:int = attributes.indexOf(name);
			
			if(index == -1) return;
			
			attributeLens[index] = len;
		}
		
		protected function parseXMLToXmlNode(x:XML, node:XmlNode):void
		{
			node.xml = x;
			
			var atts:XMLList = x.attributes();
			
			for each(var tmp:XML in atts)
			{
				var name:String = tmp.localName();
				
				node.addAttribute(name, String(tmp));
			}
			
			var xl:XMLList = x.children();
			
			for each(var xml:XML in xl)
			{
				var child:XmlNode = new XmlNode();
				
				child.xmlList = xl;
				
				node.addChild(child);
				
				parseXMLToXmlNode(xml, child);
			}
		}
		
		public function addChild(node:XmlNode):void
		{
			if(node == null) return;
			
			node.parent = this;
			
			children.push(node);
		}
		
		public function addAttribute(attName:String, attVal:String):void
		{
			attributes.push(attName);
			attributeVals.push(attVal);
			attributeLens.push(0);
		}
		
		public function getString(len:int = 0):String
		{
			var i:int;
			
			var str:String = "";
			
			var attr:String, tmp:String;
			
			if(children.length > 0)
			{
				str = str + getSpaces(len) + "<" + xml.localName();
				
				for(i = 0;i < attributes.length; i++)
				{
					attr = attributes[i];
					
					tmp = attr + "=\"" + getAttributeValue(attr) + "\"";
					
					tmp = fillStr(tmp, getAttributeLen(attr));
					
					str = str + " " + tmp;
				}
				
				str = str + ">\r\n";
				
				for each(var node:XmlNode in children)
				{
					str = str + node.getString(len + SpliteCount);
				}
				
				str = str + getSpaces(len) + "</" + xml.localName() + ">\r\n";
			}
			else
			{
				str = str + getSpaces(len) + "<" + xml.localName();
				
				for(i = 0;i < attributes.length; i++)
				{
					attr = attributes[i];
					
					tmp = attr + "=\"" + getAttributeValue(attr) + "\"";
					
					tmp = fillStr(tmp, getAttributeLen(attr));
					
					str = str + " " + tmp;
				}
				
				str = str + " />\r\n";
			}
			
			
			
			return str;
		}
		
		private function getSpaces(len:int):String
		{
			var str:String = "";
			
			for(var i:int = 0; i < len; i++)
			{
				str += " ";
			}
			
			return str;
		}
		
		private function fillStr(str:String, len:int):String
		{
			var rlt:String = str;
			
			var strLen:int = StringUtil.getRealLength(str);
			
			var count:int = len - strLen;
			
			if(count > 0)
			{
				for(var i:int = 0; i < count; i++)
				{
					rlt += " ";
				}
			}
			
			return rlt;
		}
		
		public function dispose():void
		{
		}
	}
}