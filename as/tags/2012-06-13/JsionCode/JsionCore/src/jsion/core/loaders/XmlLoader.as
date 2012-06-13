package jsion.core.loaders
{
	import flash.utils.ByteArray;

	/**
	 * <p>Xml加载类</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class XmlLoader extends TextLoader
	{
		public function XmlLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		/** @private */
		override protected function setContent(data:*):void
		{
			var bytes:ByteArray = decrypt(data as ByteArray);
			bytes.position = 0;
			var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
			
			_content = new XML(str);
		}
	}
}