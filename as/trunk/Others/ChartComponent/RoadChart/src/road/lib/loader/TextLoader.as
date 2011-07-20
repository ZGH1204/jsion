package road.lib.loader
{
	import flash.net.URLLoaderDataFormat;
	
	public class TextLoader extends BytesLoader
	{
		public function TextLoader(path:String)
		{
			super(path);
			dataFormat = URLLoaderDataFormat.TEXT;
		}
		
	}
}