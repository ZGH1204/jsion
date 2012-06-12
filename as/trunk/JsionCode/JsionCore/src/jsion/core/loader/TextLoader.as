package jsion.core.loader
{
	import flash.utils.ByteArray;

	public class TextLoader extends BytesLoader
	{
		public function TextLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
		override protected function onLoadCompleted():void
		{
			if(m_data == null && m_status == LOADING)
			{
				var bytes:ByteArray = decrypt(m_urlLoader.data as ByteArray);
				bytes.position = 0;
				m_data = bytes.readUTFBytes(bytes.bytesAvailable);
			}
			
			super.onLoadCompleted();
		}
	}
}