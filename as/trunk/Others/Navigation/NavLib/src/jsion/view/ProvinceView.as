package jsion.view
{
	import com.utils.DisposeHelper;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.ProvinceMgr;
	import jsion.Util;
	import jsion.controls.Button;
	import jsion.data.CityInfo;
	import jsion.data.ProvinceInfo;
	import jsion.factory.ControlFactory;
	
	public class ProvinceView extends BaseView
	{
		private var _province:ProvinceInfo;
		
		public function ProvinceView()
		{
			
		}
		
		override public function set data(value:Object):void
		{
			_province = value as ProvinceInfo
			super.data = _province;
		}
		
		override protected function initView():void
		{
			super.initView();
			
			for each(var city:CityInfo in _province.cityList)
			{
				createViewBtn(city.up, city.over, city.x, city.y, city.name, city.cityFont, city.citySize, city.cityColor, city.cityBold, city.cityItalic, city.cityX, city.cityY, _container);
			}
		}
		
		override protected function onClickHandler():void
		{
			if(_clickTarget == null) return;
			
			super.onClickHandler();
			
			mouseEnabled = mouseChildren = false;
			
			var _clickShowView:BaseView = new CityView();
			_clickShowView.data = _province.cityList[_list.indexOf(_clickTarget)];
			
			var p:Point = _container.localToGlobal(new Point(_clickTarget.x, _clickTarget.y));
			
			_clickShowView.parentShadowLayer = _shadowLayer;
			_clickShowView.beginShow(p, _clickTarget.width, _clickTarget.height, closing);
			
			ProvinceMgr.Instance.showView(_clickShowView);
		}
		
		private function closing():void
		{
			if(_shadowLayer && _shadowLayer.parent) _shadowLayer.parent.removeChild(_shadowLayer);
			_clickTarget = null;
			
			mouseEnabled = mouseChildren = true;
		}
		
		override public function dispose():void
		{
			_province = null;
			super.dispose();
		}
	}
}