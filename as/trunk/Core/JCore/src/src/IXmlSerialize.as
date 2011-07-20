package
{
	/**
	 * XML序列化接口
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public interface IXmlSerialize
	{
		/**
		 * 序列化指定对象为Xml
		 * @param nodeName Xml节点名称
		 * @param obj 要序列化的对象
		 * @return 序列化的Xml对象
		 * 
		 */		
		function encode(nodeName:String, obj:Object):XML;
		
		/**
		 * 反序列化Xml到指定对象
		 * @param obj 反序列化到的目标对象
		 * @param xml 要反序列化的Xml
		 * 
		 */		
		function decode(obj:Object, xml:XML):void;
	}
}