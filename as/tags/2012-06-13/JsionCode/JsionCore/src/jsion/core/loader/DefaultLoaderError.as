package jsion.core.loader
{

	public class DefaultLoaderError implements ILoaderError
	{
		public function DefaultLoaderError()
		{
		}
		
		public function error(loader:ILoader):void
		{
			trace(loader.fullUrl, "加载失败！", loader.errorMsg);
		}
	}
}