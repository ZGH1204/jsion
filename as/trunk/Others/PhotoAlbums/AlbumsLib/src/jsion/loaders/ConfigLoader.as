package jsion.loaders
{
	import com.loader.XmlLoader;
	
	public class ConfigLoader extends XmlLoader
	{
		public function ConfigLoader()
		{
			super("config.xml", false);
		}
	}
}