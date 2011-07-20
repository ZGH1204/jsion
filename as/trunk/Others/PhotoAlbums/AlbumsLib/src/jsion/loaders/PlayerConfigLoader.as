package jsion.loaders
{
	import com.loader.XmlLoader;
	
	public class PlayerConfigLoader extends XmlLoader
	{
		public function PlayerConfigLoader(path:String)
		{
			super(path, false);
		}
	}
}