package road.index
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import road.v.core.LineStyle;
	import road.v.grids.DateCategoryGrid;

	public class ChartCategoryGrid extends DateCategoryGrid
	{
		public var gapHeight:Number = 0;
        public var extraHeight:Number = 0;
		
		public function ChartCategoryGrid()
		{
			super();
		}
		
		override protected function drawSplitLine():void
		{
			var _loc_3:Number;
            if (_splitLineLayer == null)
            {
                _splitLineLayer = new Shape();
                addChildAt(_splitLineLayer, 0);
            }
            var _loc_1:Graphics = _splitLineLayer.graphics;
            _loc_1.clear();
            var _loc_2:LineStyle = _styles[SPLIT_LINE_STYLE] as LineStyle;
            _loc_1.lineStyle(_loc_2.thickness, _loc_2.color, _loc_2.alpha);
            for each (_loc_3 in _splitPositionsAry)
            {
                
                _loc_1.moveTo(_loc_3, 0);
                _loc_1.lineTo(_loc_3, _height);
                _loc_1.moveTo(_loc_3, _height + gapHeight);
                _loc_1.lineTo(_loc_3, _height + gapHeight + extraHeight);
            }
		}
		
		override protected function drawMask() : void
		{
			if(_maskLayer == null)
			{
				_maskLayer = new Shape();
				addChild(_maskLayer);
				this.mask = _maskLayer;
			}
			
			var g:Graphics = _maskLayer.graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			g.drawRect(0, -100, _width, _height + gapHeight + extraHeight + 200);
			g.endFill();
		}
	}
}