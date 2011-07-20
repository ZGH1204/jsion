package road.v.graphs
{
	import flash.geom.Point;
	
	import road.v.core.Graph;
	import road.v.core.GridPlacement;
	import road.v.grids.CategoryGrid;
	import road.v.grids.ValueGrid;

	public class GridBasedGraph extends Graph
	{
		public static const GRAPH_LINE_STYLE:String = "graphLineStyle";
		
        protected var _categoryGrid:CategoryGrid;
        protected var _valueGrid:ValueGrid;
        
        public static const INVALID_TYPE_VALUE_GRID:String = "valueGrid";
        public static const INVALID_TYPE_CATEGORY_GRID:String = "categoryGrid";

		public function GridBasedGraph()
		{
		}
		
		public function get categoryGrid():CategoryGrid
		{
			return _categoryGrid;
		}
		public function set categoryGrid(grid:CategoryGrid):void
		{
			if(grid == _categoryGrid) return;
			
			_categoryGrid = grid;
			invalidate(INVALID_TYPE_CATEGORY_GRID);
		}
		
		public function get valueGrid():ValueGrid
		{
			return _valueGrid;
		}
		public function set valueGrid(grid:ValueGrid):void
		{
			if(_valueGrid == grid) return;
			
			_valueGrid = grid;
			invalidate(INVALID_TYPE_VALUE_GRID);
		}
		
		public function getPointByIndex(index:uint):Point
		{
			var result:Point;
			
			var xPos:Number = _categoryGrid.getPositionByIndex(index);
			var yPos:Number = _valueGrid.getPositionByValue(_data[index]);
			
			if(_categoryGrid.placement == GridPlacement.TOP || _categoryGrid.placement == GridPlacement.BOTTOM)
			{
				result = new Point(xPos, yPos);
			}
			else
			{
				result = new Point(yPos, xPos);
			}
			
			return result;
		}
	}
}