package jsion.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Rectangle;
	
	import jsion.Insets;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	public class Image extends Component
	{
		public static const SOURCE:String = "source";
		public static const SCALE9INSETS:String = "scale9Insets";
		public static const SCALETYPE:String = "scaleType";
		
		public static const SCALE:String = "scale";
		public static const TILE:String = "tile";
		
		private var m_source:BitmapData;
		
		private var m_scale9Insets:Insets;
		
		private var m_scaleType:String;
		
		
		private var m_bmp1:Bitmap;
		private var m_bmp2:Bitmap;
		private var m_bmp3:Bitmap;
		private var m_bmp4:Bitmap;
		private var m_bmp5:Bitmap;
		private var m_bmp6:Bitmap;
		private var m_bmp7:Bitmap;
		private var m_bmp8:Bitmap;
		private var m_bmp9:Bitmap;
		
		
		public function Image()
		{
			super();
			
			m_scaleType = SCALE;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function get source():BitmapData
		{
			return m_source;
		}
		
		public function set source(value:BitmapData):void
		{
			if(m_source != value)
			{
				m_source = value;
				
				if(m_source)
				{
					m_width = m_source.width;
					m_height = m_source.height;
				}
				
				onPropertiesChanged(SOURCE);
			}
		}
		
		override public function get scale9Grid():Rectangle
		{
			throw new Error("九宫格范围请访问scale9Insets属性");
		}
		
		override public function set scale9Grid(innerRectangle:Rectangle):void
		{
			throw new Error("九宫格范围请访问scale9Insets属性");
		}
		
		public function get scale9Insets():Insets
		{
			return m_scale9Insets;
		}
		
		public function set scale9Insets(value:Insets):void
		{
			m_scale9Insets = value;
			
			onPropertiesChanged(SCALE9INSETS);
		}
		
		public function get scaleType():String
		{
			return m_scaleType;
		}
		
		public function set scaleType(value:String):void
		{
			if(m_scaleType != value && (value == SCALE || value == TILE))
			{
				m_scaleType = value;
				
				onPropertiesChanged(SCALETYPE);
			}
		}
		
		override protected function addChildren():void
		{
			//super.addChildren();
			
			if(m_bmp1) return;
			
			m_bmp1 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp2 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp3 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp4 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp5 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp6 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp7 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp8 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp9 = new Bitmap(null, PixelSnapping.AUTO, true);
			
			addChild(m_bmp1);
			addChild(m_bmp2);
			addChild(m_bmp3);
			addChild(m_bmp4);
			addChild(m_bmp5);
			addChild(m_bmp6);
			addChild(m_bmp7);
			addChild(m_bmp8);
			addChild(m_bmp9);
		}
		
		override protected function onProppertiesUpdate():void
		{
			if(m_source == null) return;
			
			if(m_scale9Insets != null)
			{
				if(m_changeProperties.containsKey(SOURCE) || 
					m_changeProperties.containsKey(SCALE9INSETS) ||
					m_changeProperties.containsKey(SCALETYPE) || 
					m_changeProperties.containsKey(WIDTH) || 
					m_changeProperties.containsKey(HEIGHT))
				{
					if(m_scaleType == SCALE)
					{
						drawScaleBitmap();
					}
					else
					{
						drawTileBitmap();
					}
				}
			}
			else
			{
				drawScaleBitmap();
			}
		}
		
		private function drawScaleBitmap():void
		{
			if(m_bmp5.bitmapData != m_source)
			{
				m_bmp1.x = m_bmp1.y = 0;
				m_bmp2.x = m_bmp2.y = 0;
				m_bmp3.x = m_bmp3.y = 0;
				m_bmp4.x = m_bmp4.y = 0;
				m_bmp5.x = m_bmp5.y = 0;
				m_bmp6.x = m_bmp6.y = 0;
				m_bmp7.x = m_bmp7.y = 0;
				m_bmp8.x = m_bmp8.y = 0;
				m_bmp9.x = m_bmp9.y = 0;
				
				disposeBitmapData(m_bmp1);
				disposeBitmapData(m_bmp2);
				disposeBitmapData(m_bmp3);
				disposeBitmapData(m_bmp4);
				disposeBitmapData(m_bmp5);
				disposeBitmapData(m_bmp6);
				disposeBitmapData(m_bmp7);
				disposeBitmapData(m_bmp8);
				disposeBitmapData(m_bmp9);
				
				m_bmp5.bitmapData = m_source;
			}
			
			if(m_changeProperties.containsKey(WIDTH) || 
				m_changeProperties.containsKey(HEIGHT))
			{
				m_bmp5.width = m_width;
				m_bmp5.height = m_height;
			}
		}
		
		private function drawTileBitmap():void
		{
			
		}
		
		private function drawNoScaleBmp():void
		{
			
		}
		
		private function disposeBitmapData(bmp:Bitmap):void
		{
			var bmd:BitmapData = bmp.bitmapData;
			DisposeUtil.free(bmd);
			bmp.bitmapData = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}