package jsion
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 一个指示宽度和高度并提供相关计算方法的类
	 * @author Jsion
	 * 
	 */	
	public class IntDimension
	{
		/**
		 * 宽度
		 */		
		public var width:int = 0;
		/**
		 * 高度
		 */		
		public var height:int = 0;
		
		public function IntDimension(width:int = 0, height:int = 0)
		{
			this.width = width;
			this.height = height;
		}
		
		/**
		 * 设置宽度和高度
		 */		
		public function setSize(dim:IntDimension):void
		{
			this.width = dim.width;
			this.height = dim.height;
		}
		
		/**
		 * 设置宽度和高度
		 */		
		public function setSizeWH(width:int, height:int):void
		{
			this.width = width;
			this.height = height;
		}
		
		/**
		 * 增加宽度和高度
		 * @param s 要增加的宽度和高度的 IntDimension 对象
		 */		
		public function increaseSize(s:IntDimension):IntDimension
		{
			width += s.width;
			height += s.height;
			return this;
		}
		
		/**
		 * 减去宽度和高度
		 * @param s 要减去的宽度和高度的 IntDimension 对象
		 */		
		public function decreaseSize(s:IntDimension):IntDimension
		{
			width -= s.width;
			height -= s.height;
			return this;
		}
		
		/**
		 * 改变宽度和高度
		 * @param deltaW 要改变的宽度值
		 * @param deltaH 要改变的高度值
		 */		
		public function change(deltaW:int, deltaH:int):IntDimension
		{
			width += deltaW;
			height += deltaH;
			return this;
		}
		
		/**
		 * 获取要改变的宽度和高度的 IntDimension 对象 并生成新的对象 不影响对象本身
		 * @param deltaW 要改变的宽度值
		 * @param deltaH 要改变的高度值
		 */		
		public function changedSize(deltaW:int, deltaH:int):IntDimension
		{
			var s:IntDimension = new IntDimension(deltaW, deltaH);
			return s;
		}
		
		/**
		 * 联合宽度和高度 取最大的宽度和高度值
		 * @param d 要联合的宽度和高度的 IntDimension 对象
		 */		
		public function combine(d:IntDimension):IntDimension
		{
			this.width = Math.max(this.width, d.width);	
			this.height = Math.max(this.height, d.height);
			return this;
		}
		
		/**
		 * 克隆对象
		 */		
		public function clone():IntDimension
		{
			return new IntDimension(width,height);
		}
		
		/**
		 * 联合宽度和高度 取最大的宽度和高度值 并生成新的 IntDimension 对象 不影响对象本身
		 * @param d 要联合的宽度和高度的 IntDimension 对象
		 */		
		public function combineSize(d:IntDimension):IntDimension
		{
			return clone().combine(d);
		}
		
		/**
		 * 通过指定位置获取包含此对象大小的范围
		 * @param x 指定位置的x坐标
		 * @param y 指定位置的y坐标
		 */		
		public function getBounds(x:int=0, y:int=0):Rectangle
		{
			var p:Point = new Point(x, y);
			var r:Rectangle = new Rectangle();
			r.x = p.x;
			r.y = p.y;
			r.width = width;
			r.height = height;
			return r;
		}
		
		/**
		 * 与指定对象比较是否相等
		 * @param o 要比较的对象
		 * @return true表示相等 false表示不相等
		 * 
		 */		
		public function equals(o:Object):Boolean
		{
			var d:IntDimension = o as IntDimension;
			if(d == null) return false;
			return width === d.width && height === d.height;
		}
		
		/**
		 * 获取一个 100000 x 100000 的 IntDimension 对象
		 */		
		public static function createBigDimension():IntDimension
		{
			return new IntDimension(100000, 100000);
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String
		{
			return "IntDimension["+width+","+height+"]";
		}
	}
}