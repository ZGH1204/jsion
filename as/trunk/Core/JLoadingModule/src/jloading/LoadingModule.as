package jloading
{
	import jcore.org.message.Message;
	import jcore.org.moduls.DefaultModule;
	import jcore.org.moduls.ModuleInfo;
	
	import jutils.org.util.DepthUtil;
	import jutils.org.util.DisposeUtil;
	
	import launcher.loading.LoadingAsset;
	
	public class LoadingModule extends DefaultModule
	{
		private var _loadingView:LoadingAsset;
		
		public function LoadingModule(moduleInfo:ModuleInfo)
		{
			super(moduleInfo);
		}
		
		override protected function install(msg:Message):Object
		{
			var rlt:Object = super.install(msg);
			
			_loadingView = new LoadingAsset();
			StageRef.addChild(_loadingView);
			DepthUtil.bringToBottom(_loadingView);
			
			return rlt;
		}
		
		override protected function uninstall(msg:Message):Object
		{
			DisposeUtil.free(_loadingView);
			_loadingView = null;
			
			return super.uninstall(msg);
		}
	}
}