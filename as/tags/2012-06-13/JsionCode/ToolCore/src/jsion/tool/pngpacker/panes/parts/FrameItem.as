package jsion.tool.pngpacker.panes.parts
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	import jsion.utils.ScaleUtil;
	
	import org.aswing.Icon;
	import org.aswing.JToggleButton;
	
	public class FrameItem extends JToggleButton implements IDispose
	{
		private var m_bmd:BitmapData;
		
		private var m_bmp:Bitmap;
		
		public function FrameItem(bmd:BitmapData)
		{
			m_bmd = bmd;
			
			super();
			
			setPreferredWidth(100);
			setPreferredHeight(100);
			
			pack();
			
			m_bmp = new Bitmap(m_bmd);
			addChild(m_bmp);
			
			var scale:Number = ScaleUtil.calcScaleFullSize(m_bmd.width, m_bmd.height, width, height);
			
			m_bmp.scaleX = scale;
			m_bmp.scaleY = scale;
			
			m_bmp.x = (width - m_bmp.width) / 2;
			m_bmp.y = (height - m_bmp.height) / 2;
		}
		
		public function get bmd():BitmapData
		{
			return m_bmd;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_bmp, false);
			m_bmp = null;
			
			m_bmd = null;
		}
	}
}