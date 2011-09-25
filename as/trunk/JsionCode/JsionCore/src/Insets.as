package
{
	public class Insets
	{
		public var bottom:int = 0;
		public var top:int = 0;
		public var left:int = 0;
		public var right:int = 0;
		
		public function Insets(top:int = 0, left:int = 0, bottom:int = 0, right:int = 0)
		{
			this.top = top;
			this.left = left;
			this.bottom = bottom;
			this.right = right;
		}
		
		public static function createIdentic(edge:int):Insets
		{
			return new Insets(edge, edge, edge, edge);	
		}
		
		public function addInsets(insets:Insets):Insets
		{
			this.top += insets.top;
			this.left += insets.left;
			this.bottom += insets.bottom;
			this.right += insets.right;
			return this;
		}
		
		public function getMarginWidth():int
		{
			return left + right;
		}
		
		public function getMarginHeight():int
		{
			return top + bottom;
		}
		
		public function getInsideBounds(bounds:IntRectangle):IntRectangle
		{
			var r:IntRectangle = bounds.clone();
			r.x += left;
			r.y += top;
			r.width -= (left + right);
			r.height -= (top + bottom);
			return r;
		}
		
		public function getOutsideBounds(bounds:IntRectangle):IntRectangle
		{
			var r:IntRectangle = bounds.clone();
			r.x -= left;
			r.y -= top;
			r.width += (left + right);
			r.height += (top + bottom);
			return r;
		}
		
		public function getOutsideSize(size:IntDimension=null):IntDimension
		{
			if(size == null) size = new IntDimension();
			var s:IntDimension = size.clone();
			s.width += (left + right);
			s.height += (top + bottom);
			return s;
		}
		
		public function getInsideSize(size:IntDimension=null):IntDimension
		{
			if(size == null) size = new IntDimension();
			var s:IntDimension = size.clone();
			s.width -= (left + right);
			s.height -= (top + bottom);
			return s;
		}
		
		public function equals(o:Object):Boolean
		{
			var i:Insets = o as Insets;
			if(i == null)
			{
				return false;
			}
			else
			{
				return i.bottom == bottom && i.left == left && i.right == right && i.top == top;
			}
		}
		
		public function clone():Insets
		{
			return new Insets(top, left, bottom, right);
		}
		
		public function toString():String
		{
			return "Insets(top:"+top+", left:"+left+", bottom:"+bottom+", right:"+right+")";
		}
	}
}