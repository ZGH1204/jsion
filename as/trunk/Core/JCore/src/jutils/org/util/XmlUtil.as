package jutils.org.util
{
	import jutils.org.serialize.xml.*;

	/**
	 * Xml数据格式化工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class XmlUtil
	{
		/**
		 * 序列化指定对象为Xml，以Xml属性的方式序列化。
		 * @param nodeName Xml节点名称
		 * @param obj 要序列化的对象
		 * @param force 强制将Xml属性赋值给obj参数对象,即动态属性.
		 * @return 序列化的Xml对象
		 * 
		 */		
		public static function encodeWithProperty(nodeName:String, obj:Object, force:Boolean = false):XML
		{
			var serialize:IXmlSerialize;
			if(force)
			{
				serialize = new XmlPropForceSerialize();
			}
			else
			{
				serialize = new XmlPropertySerialize();
			}
			return serialize.encode(nodeName, obj);
		}
		
		/**
		 * 反序列化Xml到指定对象，以Xml属性的方式反序列化。
		 * @param obj 反序列化到的目标对象
		 * @param xml 要反序列化的Xml
		 * @param force 强制将Xml属性赋值给obj参数对象,即动态属性.
		 * 
		 */		
		public static function decodeWithProperty(obj:Object, xml:XML, force:Boolean = false):void
		{
			var serialize:IXmlSerialize;
			if(force)
			{
				serialize = new XmlPropForceSerialize();
			}
			else
			{
				serialize = new XmlPropertySerialize();
			}
			return serialize.decode(obj, xml);
		}
		
		/**
		 * 序列化指定对象为Xml，以Xml子节点的方式序列化。
		 * @param nodeName Xml节点名称
		 * @param obj 要序列化的对象
		 * @param force 强制将Xml属性赋值给obj参数对象,即动态属性.
		 * @return 序列化的Xml对象
		 * 
		 */		
		public static function encodeWithChildNode(nodeName:String, obj:Object, force:Boolean = false):XML
		{
			var serialize:IXmlSerialize;
			if(force)
			{
				serialize = new XmlChildNodeForceSerialize();
			}
			else
			{
				serialize = new XmlChildNodeSerialize();
			}
			return serialize.encode(nodeName, obj);
		}
		
		/**
		 * 反序列化Xml到指定对象，以Xml子节点的方式反序列化。
		 * @param obj 反序列化到的目标对象
		 * @param xml 要反序列化的Xml
		 * @param force 强制将Xml属性赋值给obj参数对象,即动态属性.
		 * 
		 */		
		public static function decodeWithChildNode(obj:Object, xml:XML, force:Boolean = false):void
		{
			var serialize:IXmlSerialize;
			if(force)
			{
				serialize = new XmlChildNodeForceSerialize();
			}
			else
			{
				serialize = new XmlChildNodeSerialize();
			}
			return serialize.decode(obj, xml);
		}
	}
}