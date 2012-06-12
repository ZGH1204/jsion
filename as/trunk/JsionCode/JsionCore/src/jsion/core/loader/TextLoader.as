package jsion.core.loader
{
	import flash.net.URLLoaderDataFormat;

	public class TextLoader extends BytesLoader
	{
		public function TextLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
		}
	}
}