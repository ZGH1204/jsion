package jsion
{
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.data.ProvinceInfo;
	import jsion.view.BaseView;
	import jsion.view.ProvinceView;

	public class ProvinceMgr
	{
		private var _container:DisplayObjectContainer;
		private var _view:BaseView;
		
		public function setup(container:DisplayObjectContainer):void
		{
			_container = container;
		}
		
		public function showProvinceView(province:ProvinceInfo):void
		{
			if(province == null) return;
			
			DisposeHelper.dispose(_view);
			_view = new ProvinceView();
			_view.data = province;
			_container.addChild(_view);
		}
		
		public function showView(view:DisplayObject):void
		{
			if(view == null) return;
			_container.addChild(view);
		}
		
		public static function get Instance():ProvinceMgr
		{
			return InstanceManager.createSingletonInstance(ProvinceMgr) as ProvinceMgr;
		}
	}
}