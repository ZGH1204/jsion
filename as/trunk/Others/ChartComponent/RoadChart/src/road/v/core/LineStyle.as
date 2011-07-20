package road.v.core
{
	public class LineStyle
	{
		public var color:uint;
        public var thickness:Number;
        public var alpha:Number;
        
		public function LineStyle($color:uint = 0, $thickness:Number = 1, $alpha:Number = 1)
        {
            this.color = $color;
            this.thickness = $thickness;
            this.alpha = $alpha;
            return;
        }
	}
}