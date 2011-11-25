package jsion.ui.components.images
{
	import flash.display.BitmapData;
	
	import jsion.ui.Component;
	import jsion.ui.UIConstants;
	
	public class AbstractImage extends Component
	{
		public static const TOP_LEFT:int = UIConstants.TOP_LEFT;
		
		public static const TOP_CENTER:int = UIConstants.TOP_CENTER;
		
		public static const TOP_RIGHT:int = UIConstants.TOP_RIGHT;
		
		public static const MIDDLE_LEFT:int = UIConstants.MIDDLE_LEFT;
		
		public static const MIDDLE_CENTER:int = UIConstants.MIDDLE_CENTER;
		
		public static const MIDDLE_RIGHT:int = UIConstants.MIDDLE_RIGHT;
		
		public static const BOTTOM_LEFT:int = UIConstants.BOTTOM_LEFT;
		
		public static const BOTTOM_CENTER:int = UIConstants.BOTTOM_CENTER;
		
		public static const BOTTOM_RIGHT:int = UIConstants.BOTTOM_RIGHT;
		
		/**
		 * 拉伸方式
		 */		
		public static const DRAW_SCALE:int = UIConstants.DRAW_SCALE;
		
		/**
		 * 平铺方式
		 */		
		public static const TILE_SCALE:int = UIConstants.TILE_SCALE;
		
		private var m_scaleType:int;
		
		private var m_scaleInsets:Insets;
		
		private var m_sourceBitmapData:BitmapData;
		
		public function AbstractImage(bmd:BitmapData, scaleInset:Insets = null, id:String = null)
		{
			if(scaleInset == null) scaleInset = new Insets();//throw new ArgumentError("scaleInset 参数不能为空!!");
			
			m_sourceBitmapData = bmd;
			
			m_scaleInsets = scaleInset;
			
			m_scaleType = DRAW_SCALE;
			
			super(null, id);
			
			if(bmd == null) throw new ArgumentError("bmd 参数不能为空!!");
		}
		
		public function get scaleType():int
		{
			return m_scaleType;
		}
		
		public function set scaleType(value:int):void
		{
			if(value != TILE_SCALE && value != DRAW_SCALE && value == m_scaleType) return;
			
			m_scaleType = value;
			
			invalidate();
		}
		
		public function get scaleInsets():Insets
		{
			return m_scaleInsets;
		}
		
		public function set scaleInsets(value:Insets):void
		{
			if(m_scaleInsets != value)
			{
				m_scaleInsets = value;
				
				if(m_scaleInsets == null) m_scaleInsets = new Insets();
				
				invalidate();
			}
		}
		
		public function get sourceBitmapData():BitmapData
		{
			return m_sourceBitmapData;
		}
		
		public function set sourceBitmapData(value:BitmapData):void
		{
			if(m_sourceBitmapData != value)
			{
				m_sourceBitmapData = value;
				
				invalidate();
			}
		}
		
//		override public function setSizeWH(w:int, h:int):void
//		{
//			var min:IntDimension = getMinimumSize();
//			
//			if(w < min.width) w = min.width;
//			if(h < min.height) h = min.height;
//			
//			super.setSizeWH(w, h);
//		}
		
		override public function dispose():void
		{
			m_scaleInsets = null;
			
			m_sourceBitmapData = null;
			
			super.dispose();
		}
	}
}