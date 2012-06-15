package jsion.loaders
{
	import flash.utils.ByteArray;

	/**
	 * Xml加载器
	 * @author Jsion
	 * 
	 */	
	public class XmlLoader extends TextLoader
	{
		public function XmlLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onLoadCompleted():void
		{
			if(m_data == null && m_status == LOADING)
			{
				var bytes:ByteArray = decrypt(m_urlLoader.data as ByteArray);
				bytes.position = 0;
				var xmlStr:String = bytes.readUTFBytes(bytes.bytesAvailable);
				
				m_data = new XML(xmlStr);
			}
			
			super.onLoadCompleted();
		}
	}
}