package jsion
{
	import flash.geom.Rectangle;

	/**
	 * 一个指示上下左右四边距并提供相关计算方法的类
	 * @author Jsion
	 */	
	public class Insets
	{
		/**
		 * 下边距
		 */		
		public var bottom:int = 0;
		/**
		 * 上边距
		 */		
		public var top:int = 0;
		/**
		 * 左边距
		 */		
		public var left:int = 0;
		/**
		 * 右边距
		 */		
		public var right:int = 0;
		
		public function Insets(top:int = 0, left:int = 0, bottom:int = 0, right:int = 0)
		{
			this.top = top;
			this.left = left;
			this.bottom = bottom;
			this.right = right;
		}
		
		/**
		 * 创建等边距对象
		 * @param edge 边距
		 */		
		public static function createIdentic(edge:int):Insets
		{
			return new Insets(edge, edge, edge, edge);	
		}
		
		/**
		 * 增加边距值
		 * @param insets 增加的四个边距值
		 */		
		public function addInsets(insets:Insets):Insets
		{
			this.top += insets.top;
			this.left += insets.left;
			this.bottom += insets.bottom;
			this.right += insets.right;
			return this;
		}
		
		/**
		 * 获取边距宽度 左右边距相加
		 */		
		public function getMarginWidth():int
		{
			return left + right;
		}
		
		/**
		 * 获取边距高度 上下边距相加
		 */		
		public function getMarginHeight():int
		{
			return top + bottom;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取不包含边距值的范围
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getInsideBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			r.x += left;
			r.y += top;
			r.width -= (left + right);
			r.height -= (top + bottom);
			return r;
		}
		
		/**
		 * 通过一个指定的不包含边距值的范围获取包含边距值的范围
		 * @param bounds 指定的不包含边距值的范围
		 */		
		public function getOutsideBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			r.x -= left;
			r.y -= top;
			r.width += (left + right);
			r.height += (top + bottom);
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取顶部不包含边距值的范围 高度为上边距 宽度为指定范围宽度减去左右边距
		 * @param bounds 指定范围
		 */		
		public function getTopBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.x += left;
			r.width -= (left + right);
			r.height = top;
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取底部不包含边距值的范围 高度为底边距 宽度为指定范围宽度减去左右边距
		 * @param bounds 指定范围
		 */		
		public function getBottomBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.x += left;
			r.y += (r.height - bottom);
			r.width -= (left + right);
			r.height = bottom;
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取左边不包含边距值的范围 宽度为左边距 高度为指定范围高度减去上下边距
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getLeftBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.y += top;
			r.width = left;
			r.height -= (top + bottom);
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取右边不包含边距值的范围 宽度为右边距 高度为指定范围高度减去上下边距
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getRightBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.x += (r.width - right);
			r.y += top;
			r.width = right;
			r.height -= (top + bottom);
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取左上角的范围
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getLeftTopCornerBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.width = left;
			r.height = top;
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取右上角的范围
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getRightTopCornerBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.x += (r.width - right);
			r.width = right;
			r.height = top;
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取左下角的范围
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getLeftBottomCornerBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.y += (r.height - bottom);
			r.width = left;
			r.height = bottom;
			
			return r;
		}
		
		/**
		 * 通过一个指定的包含边距值的范围获取右下角的范围
		 * @param bounds 指定的包含边距值的范围
		 */		
		public function getRightBottomCornerBounds(bounds:Rectangle):Rectangle
		{
			var r:Rectangle = bounds.clone();
			
			r.x += (r.width - right);
			r.y += (r.height - bottom);
			r.width = right;
			r.height = bottom;
			
			return r;
		}
		
		/**
		 * 通过一个指定的不包含边距值的大小获取包含边距值的大小
		 * @param size 指定的不包含边距值的大小
		 */		
		public function getOutsideSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width += (left + right);
			s.height += (top + bottom);
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取不包含边距值的大小
		 * @param size 指定的包含边距值的大小
		 */		
		public function getInsideSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width -= (left + right);
			s.height -= (top + bottom);
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取顶部不包含边距值的大小 高度为上边距 宽度为指定的包含边距值的大小的宽度减去左右边距
		 * @param size 指定的包含边距值的大小
		 */
		public function getTopSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width -= (left + right);
			s.height = top;
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取底部不包含边距值的大小 高度为下边距 宽度为指定的包含边距值的大小的宽度减去左右边距
		 * @param size 指定的包含边距值的大小
		 */
		public function getBottomSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width -= (left + right);
			s.height = bottom;
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取左边不包含边距值的大小 宽度为左边距 高度为指定的包含边距值的大小的高度减去上下边距
		 * @param size 指定的包含边距值的大小
		 */
		public function getLeftSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = left;
			s.height -= (top + bottom);
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取右边不包含边距值的大小 宽度为右边距 高度为指定的包含边距值的大小的高度减去上下边距
		 * @param size 指定的包含边距值的大小
		 */
		public function getRightSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = right;
			s.height -= (top + bottom);
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取左上角的大小
		 * @param size 通过一个指定的包含边距值的大小
		 */		
		public function getLeftTopCornerSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = left;
			s.height = top;
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取右上角的大小
		 * @param size 通过一个指定的包含边距值的大小
		 */		
		public function getRightTopCornerSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = right;
			s.height = top;
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取左下角的大小
		 * @param size 通过一个指定的包含边距值的大小
		 */		
		public function getLeftBottomCornerSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = left;
			s.height = bottom;
			return s;
		}
		
		/**
		 * 通过一个指定的包含边距值的大小获取右下角的大小
		 * @param size 通过一个指定的包含边距值的大小
		 */		
		public function getRightBottomCornerSize(size:Dimension=null):Dimension
		{
			if(size == null) size = new Dimension();
			var s:Dimension = size.clone();
			s.width = right;
			s.height = bottom;
			return s;
		}
		
		/**
		 * 与指定对象比较是否相等
		 * @param o 要比较的对象
		 * @return true表示相等 false表示不相等
		 * 
		 */		
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
		
		/**
		 * 克隆对象
		 */		
		public function clone():Insets
		{
			return new Insets(top, left, bottom, right);
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String
		{
			return "Insets(top:"+top+", left:"+left+", bottom:"+bottom+", right:"+right+")";
		}
	}
}