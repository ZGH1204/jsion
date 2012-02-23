package knightage.loading
{
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	
	public class KLoadingModule extends BaseModule
	{
		public function KLoadingModule(info:ModuleInfo)
		{
			super(info);
		}
		
		override public function startup():void
		{
			t("startup");
		}
	}
}