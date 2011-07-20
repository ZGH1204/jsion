package road.index
{
	import flash.text.TextField;
	
	import road.v.grids.ValueGrid;

	public class SpecialValueGrid extends ValueGrid
	{
		public function SpecialValueGrid()
		{
		}
		
		override protected function locateAxisLabels():void
		{
			var count:uint = _axisLabels.length;
			var padding:Number = _styles[AXIS_LABEL_PADDING];
			var i:int;
			
			while(i < count)
			{
				var splitPos:Number = _height - i * _splitSize;
				var textField:TextField = _axisLabels[i];
				textField.x = _width - textField.width - padding + 2;
				textField.y = splitPos;
				i++;
			}
		}
	}
}