package editor
{
	import flash.display.DisplayObject;
	
	import org.aswing.AssetBackground;
	import org.aswing.Component;
	import org.aswing.geom.IntRectangle;
	import org.aswing.graphics.Graphics2D;
	
	public class PreviewBackground extends AssetBackground
	{
		protected var m_second:DisplayObject;
		
		public function PreviewBackground(asset:DisplayObject, second:DisplayObject = null, ignorBorderMargin:Boolean=false)
		{
			m_second = second
			super(asset, ignorBorderMargin);
		}
		
		override public function updateDecorator(c:Component, g:Graphics2D, b:org.aswing.geom.IntRectangle):void
		{
			if(ignorBorderMargin)
			{
				asset.x = 0;
				asset.y = 0;
				
				if(m_second)
				{
					m_second.x = 0;
					m_second.y = 0;
				}
			}
			else
			{
				asset.x = b.x;
				asset.y = b.y;
				
				if(m_second)
				{
					m_second.x = b.x;
					m_second.y = b.y;
				}
			}
		}
	}
}