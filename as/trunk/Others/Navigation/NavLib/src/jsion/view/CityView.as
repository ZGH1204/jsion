package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.ProvinceMgr;
	import jsion.data.CityInfo;
	import jsion.data.CountyInfo;
	
	public class CityView extends BaseView
	{
		private var _city:CityInfo;
		
		override public function set data(value:Object):void
		{
			_city = value as CityInfo;
			
			super.data = _city;
		}
		
		override protected function initView():void
		{
			super.initView();
			
			for each(var county:CountyInfo in _city.countyList)
			{
				createViewBtn(county.up, county.over, county.x, county.y, county.name, county.countyFont, county.countySize, county.countyColor, county.countyBold, county.countyItalic, county.countyX, county.countyY, _container);
			}
		}
		
		override protected function onClickHandler():void
		{
			super.onClickHandler();
			
			mouseEnabled = mouseChildren = false;
			
			var view:TownDialog = new TownDialog();
			view.data = _city.countyList[_list.indexOf(_clickTarget)];
			
			view.parentShadowLayer = _shadowLayer;
			view.beginShow(new Point(StageReference.stage.stageWidth / 2, StageReference.stage.stageHeight / 2), 1, 1, closing);
			
			ProvinceMgr.Instance.showView(view);
		}
		
		private function closing():void
		{
			if(_shadowLayer && _shadowLayer.parent) _shadowLayer.parent.removeChild(_shadowLayer);
			_clickTarget = null;
			
			mouseEnabled = mouseChildren = true;
		}
		
		override public function dispose():void
		{
			_city = null;
			super.dispose();
		}
	}
}