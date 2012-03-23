package jsion.tool.pngpacker.panes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import jsion.tool.pngpacker.PackerFrame;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.utils.JUtil;
	
	import org.aswing.Box;
	import org.aswing.BoxLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.ResizedEvent;
	
	public class RenderPane extends JPanel
	{
		private var m_frame:PackerFrame;
		
		private var m_info:DirectionInfo;
		
		private var m_fps:int = 3;
		
		private var m_cur:int = 0;
		
		private var m_index:int = 0;
		
		private var m_bmp:Bitmap;
		
		private var m_hasBmd:Boolean;
		
		public function RenderPane(frame:PackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.CENTER));
			
			setBorder(new TitledBorder(null, "预览", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_bmp = new Bitmap();
			addChild(m_bmp);
			
			addEventListener(ResizedEvent.RESIZED, __resizedHandler);
			
			JUtil.addEnterFrame(onEnterFrameHandler);
		}
		
		private function __resizedHandler(e:Event):void
		{
			update();
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			if(m_info == null) return;
			
			m_cur++;
			
			if(m_cur > m_fps)
			{
				m_cur = 0;
				
				m_index++;
				
				if(m_index >= m_info.getList().length)
				{
					m_index = 0;
				}
			}
			
			if(m_info.getList().length > 0)
			{
				m_bmp.bitmapData = m_info.getList()[m_index];
				
				if(m_hasBmd == false)
				{
					m_hasBmd = true;
					update();
				}
			}
			else
			{
				m_hasBmd = false;
			}
		}
		
		private function update():void
		{
			m_bmp.x = (width - m_bmp.width) / 2;
			m_bmp.y = (height - m_bmp.height) / 2;
		}
		
		public function setDirInfo(dir:DirectionInfo = null):void
		{
			if(m_info != dir)
			{
				m_info = dir;
				
				if(m_info)
				{
					m_cur = 0;
					
					m_index = 0;
					
					if(m_info.getList().length > 0)
					{
						m_bmp.bitmapData = m_info.getList()[m_index];
					}
					else
					{
						m_bmp.bitmapData = null;
					}
					
					update();
				}
				else
				{
					m_bmp.bitmapData = null;
				}
			}
		}
	}
}