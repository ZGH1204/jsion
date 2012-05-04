package flash.geom
{
	public class Size
	{
		public var width:Number;
		public var height:Number;
		
		public function Size(width:Number = 0, height:Number = 0)
		{
			width = width;
			height = height;
		}
		
		/**
		 * 通过指定的Size对象设置Size并返回自己本身.
		 */		
		public function setSize(s:Size):Size
		{
			if(s == null) return this;
			
			width = s.width;
			height = s.height;
			
			return this;
		}
		
		/**
		 * 通过指定的宽度和高度设置Size并返回自己本身.
		 */		
		public function setWH(w:Number, h:Number):Size
		{
			width = w;
			height = h;
			
			return this;
		}
		
		/**
		 * 通过指定的Size对象增加宽度和高度并返回自己本身.
		 */		
		public function increase(s:Size):Size
		{
			if(s == null) return this;
			
			width += s.width;
			height += s.height;
			
			return this;
		}
		
		/**
		 * 通过指定的Size对象增加宽度和高度并返回新的Size对象.
		 */		
		public function increaseSize(s:Size):Size
		{
			return clone().increase(s);
		}
		
		/**
		 * 增加指定的宽度和高度并返回自己本身.
		 */		
		public function increaseWH(w:Number, h:Number):Size
		{
			width += w;
			height += h;
			
			return this;
		}
		
		/**
		 * 增加指定的宽度和高度并返回新的Size对象.
		 */		
		public function increaseSizeWH(w:Number, h:Number):Size
		{
			return clone().increaseWH(w, h);
		}
		
		/**
		 * 通过指定的Size对象减去宽度和高度并返回自己本身.
		 */		
		public function decrease(s:Size):Size
		{
			if(s == null) return this;
			
			width -= s.width;
			height -= s.height;
			
			return this;
		}
		
		/**
		 * 通过指定的Size对象减去宽度和高度并返回新的Size对象.
		 */		
		public function decreaseSize(s:Size):Size
		{
			return clone().decrease(s);
		}
		
		/**
		 * 减去指定的宽度和高度并返回自己本身.
		 */		
		public function decreaseWH(w:Number, h:Number):Size
		{
			width -= w;
			height -= h;
			
			return this;
		}
		
		/**
		 * 减去指定的宽度和高度并返回新的Size对象.
		 */		
		public function decreaseSizeWH(w:Number, h:Number):Size
		{
			return clone().decreaseWH(w, h);
		}
		
		/**
		 * 通过指定的Size对象合并宽度和高度并返回自己本身.
		 */		
		public function combin(s:Size):Size
		{
			if(s == null) return this;
			
			width = Math.max(s.width, width);
			height = Math.max(s.height, height);
			
			return this;
		}
		
		/**
		 * 通过指定的Size对象合并宽度和高度并返回新的Size对象.
		 */		
		public function combinSize(s:Size):Size
		{
			return clone().combin(s);
		}
		
		/**
		 * 合并指定的宽度和高度并返回自己本身.
		 */		
		public function combinWH(w:Number, h:Number):Size
		{
			width = Math.max(w, width);
			height = Math.max(h, height);
			
			return this;
		}
		
		/**
		 * 合并指定的宽度和高度并返回新的Size对象.
		 */		
		public function combinSizeWH(w:Number, h:Number):Size
		{
			return clone().combinWH(w, h);
		}
		
		/**
		 * 克隆Size对象
		 */		
		public function clone():Size
		{
			return new Size(width, height);
		}
		
		/**
		 * 与指定对象比较,如果两个对象表示的大小相同则返回true,否则返回false.
		 */		
		public function equals(o:Object):Boolean
		{
			var s:Size = o as Size;
			
			if(s == null) return false;
			
			return width === s.width && height === s.height;
		}
		
		/**
		 * 与指定的坐标位置生成一个Rectangle对象
		 */		
		public function getBounds(pos:Point):Rectangle
		{
			if(pos == null) pos = new Point();
			
			return new Rectangle(pos.x, pos.y, width, height);
		}
		
		/**
		 * 创建一个指定宽度和高度的Size对象.
		 */		
		public static function createSize(w:Number, h:Number):Size
		{
			return new Size(w, h);
		}
		
		/**
		 * 创建一个 100000 x 100000 大小的Size对象.
		 */		
		public static function createBigSize():Size{
			return createSize(100000, 100000);
		}
		
		public function toString():String
		{
			return "Size["+width+","+height+"]";
		}
	}
}