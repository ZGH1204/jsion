package editor.rightviews
{
	import editor.aswings.PreviewBackground;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import jsion.IDispose;
	import jsion.utils.ScaleUtil;
	
	import org.aswing.AssetBackground;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	
	public class ResourcePreviewer extends JPanel implements IDispose
	{
		protected var bmp:Bitmap;
		
		protected var m_viewWidth:int;
		
		protected var m_viewHeight:int;
		
		public function ResourcePreviewer(viewWidth:int = 160, viewHeight:int = 170)
		{
			m_viewWidth = viewWidth;
			
			m_viewHeight = viewHeight;
			
			super();
			
			initialize();
		}
		
		protected function initialize():void
		{
			setPreferredHeight(m_viewHeight + getInsets().top + getInsets().bottom);
			
			bmp = new Bitmap(new BitmapData(m_viewWidth, m_viewHeight, true, 0));
			setBackgroundDecorator(new PreviewBackground(bmp));
			
			setBorder(new TitledBorder(null, '预览', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		public function draw(value:BitmapData):void
		{
			var scale:Number;
			
			var rltWidth:Number;
			var rltHeight:Number;
			
			var matrix:Matrix = new Matrix();
			
			if(value.width <= bmp.width && value.height <= bmp.height)
			{
				rltWidth = value.width;
				rltHeight = value.height;
			}
			else
			{
				scale = ScaleUtil.calcScaleFullSize(value.width, value.height, bmp.width, bmp.height);
				rltWidth = scale * value.width;
				rltHeight = scale * value.height;
				matrix.scale(scale, scale);
			}
			
			var dx:Number = (bmp.width - rltWidth) / 2;
			var dy:Number = (bmp.height - rltHeight) / 2;
			
			matrix.translate(dx, dy);
			
			bmp.bitmapData.lock();
			bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0);
			bmp.bitmapData.draw(value, matrix);
			bmp.bitmapData.unlock();
		}
		
		public function dispose():void
		{
		}
	}
}