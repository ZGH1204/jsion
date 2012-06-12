package jsion.core.loader
{
	import flash.utils.ByteArray;

	public class XmlLoader extends TextLoader
	{
		public function XmlLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
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