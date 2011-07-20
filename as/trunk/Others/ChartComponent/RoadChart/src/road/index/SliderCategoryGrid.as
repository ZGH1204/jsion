package road.index
{
	import flash.text.TextField;
	
	import road.v.grids.DateCategoryGrid;

	public class SliderCategoryGrid extends DateCategoryGrid
	{
		public function SliderCategoryGrid()
		{
		}
		
		override protected function locateAxisLabels():void
		{
			var i:int;
			var count:int = _axisLabels.length;
			
			while(i < count)
			{
				var pos:Number = _splitPositionsAry[i];
				var textField:TextField = _axisLabels[i];
				textField.selectable = false;
				textField.width = _unitSize;
				textField.x = pos + 5;
				textField.y = 0;
				i++;
			}
		}
		
		override protected function calculateDateSplit():void
		{
			if(_data == null) return;
			
			_splitPositionsAry = [];
			_splitLabelCenterPosAry = [];
			_splitLabelTextsAry = [];
			
			//时间跨度(毫秒)
			var timeSpan:Number = _data[_data.length-1].valueOf() - _data[0].valueOf();
			//偏移
			var realPadding:Number = _padding <= 1 ? (_padding * _unitSize) : _padding;
			//开始的索引
			var startIndex:Number;
			//数据个数
			var dataCount:int = _data.length;
			
			date = _data[0] as Date;
				
			year = date.fullYear;
			
			_splitPositionsAry.push(realPadding);
			_splitLabelTextsAry.push(date.fullYear + "年");
			
			startIndex = 1;
			
			while(startIndex < dataCount)
			{
				date = _data[startIndex] as Date;
				if(date.fullYear != year)
				{
					splitPos = realPadding + startIndex * _unitSize;
					splitLabelText = date.fullYear + "年";
					
					_splitPositionsAry.push(splitPos);
					_splitLabelTextsAry.push(splitLabelText);
					
					year = date.fullYear;
				}
				startIndex++;
			}
		}
	}
}