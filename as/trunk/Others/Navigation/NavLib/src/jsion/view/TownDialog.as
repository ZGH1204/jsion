package jsion.view
{
	import com.StageReference;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import jsion.Util;
	import jsion.data.CountyInfo;
	import jsion.data.TownInfo;
	import jsion.factory.ControlFactory;

	public class TownDialog extends BaseView
	{
		private var _county:CountyInfo;
		
		private var _back:DisplayObject;
		private var _closeBtn:DisplayObject;
		
		private var _listContainer:Sprite;
		
		public function TownDialog()
		{
		}
		
		override public function set data(value:Object):void
		{
			_county = value as CountyInfo;
			super.data =_county;
		}
		
		override protected function initTop():void
		{
			
		}
		
		override protected function initBottom():void
		{
			DisposeHelper.dispose(_bottom);
			_bottom = new Sprite();
			
			DisposeHelper.dispose(_back);
			_back = Util.createDisplay(_county.background);
			
			if(_back)
			{
				if(_county.dialogWidth > 0) _back.width = _county.dialogWidth;
				if(_county.dialogHeight > 0) _back.height = _county.dialogHeight;
				
				_bottom.addChild(_back);
			}
			
			DisposeHelper.dispose(_closeBtn);
			_closeBtn = ControlFactory.createButton(Util.createDisplay(_county.dialogClose), null, _county.dialogCloseX, _county.dialogCloseY);
			
			if(_closeBtn)
			{
				_bottom.addChild(_closeBtn);
			}
			
			_bottom.x = (StageReference.stage.stageWidth - _bottom.width) / 2;
			_bottom.y = (StageReference.stage.stageHeight - _bottom.height) / 2;
			
			_listContainer = new Sprite();
			_listContainer.x = _county.townContainerX;
			_listContainer.y = _county.townContainerY;
			_bottom.addChild(_listContainer);
		}
		
		override protected function initView():void
		{
			super.initView();
			
			for each(var town:TownInfo in _county.townList)
			{
				createViewBtn(town.up, town.over, town.x, town.y, town.name, town.townFont, town.townSize, town.townColor, town.townBold, town.townItalic, town.townX, town.townY, _listContainer);
			}
			
			refreshTownList();
		}
		
		private function refreshTownList():void
		{
			var cols:int = _county.townColumns;
			var iw:Number = _county.townItemWidth;
			var ih:Number = _county.townItemHeight;
			var curCols:int = 0;
			var curRows:int = 0;
			for(var i:int = 0; i < _list.length; i++)
			{
				curCols++;
				if(curCols > cols)
				{
					curCols = 1;
					curRows++;
				}
				
				_list[i].x = (curCols - 1) * iw;
				_list[i].y = curRows * ih;
			}
		}
			
		
		override protected function addEvent():void
		{
			if(_closeBtn) _closeBtn.addEventListener(MouseEvent.CLICK, __closeBtnClickHandler);
			if(_bottom) _bottom.addEventListener(MouseEvent.CLICK, __dialogClickHandler);
			
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			if(_closeBtn) _closeBtn.removeEventListener(MouseEvent.CLICK, __closeBtnClickHandler);
			if(_bottom) _bottom.removeEventListener(MouseEvent.CLICK, __dialogClickHandler);
			
			super.removeEvent();
		}
		
		override protected function onClickHandler():void
		{
			var index:int = _list.indexOf(_clickTarget);
			
			var town:TownInfo = _county.townList[index];
			
			if(town && StringHelper.isNullOrEmpty(town.townUrl) == false)
			{
				navigateToURL(new URLRequest(town.townUrl), town.linkType);
			}
			
			_clickTarget = null;
		}
		
		private function __closeBtnClickHandler(e:MouseEvent):void
		{
			beginClose();
		}
		
		private function __dialogClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		override public function dispose():void
		{
			_county = null;
			super.dispose();
		}
	}
}