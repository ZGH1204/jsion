package jcore.org.loader
{
	import flash.utils.ByteArray;

	/**
	 * <p>文本加载类</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class TextLoader extends BinaryLoader
	{
		public function TextLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		override protected function setContent(data:*):void
		{
			var bytes:ByteArray = decrypt(data as ByteArray);
			bytes.position = 0;
			_content = bytes.readUTFBytes(bytes.bytesAvailable);
		}
	}
}