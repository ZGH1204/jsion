package jsion.tool
{
	import org.aswing.Container;
	import org.aswing.JFrame;
	import org.aswing.event.ResizedEvent;
	
	public class BaseFrame extends JFrame
	{
		protected var m_win:MainWindow;
		
		protected var m_title:String;
		
		protected var m_content:Container;
		
		public function BaseFrame(owner:* = null, modal:Boolean = false)
		{
			m_win = owner as MainWindow;
			
			super(owner, m_title, modal);
			
			addEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			m_content = getContentPane();
			m_content.addEventListener(ResizedEvent.RESIZED, __contentResizeHandler);
		}
		
		private function __resizeHandler(e:ResizedEvent):void
		{
			setLocationXY((m_win.width - width) / 2, (m_win.height - height) / 2);
		}
		
		private function __contentResizeHandler(e:ResizedEvent):void
		{
			onContentResized(m_content.width, m_content.height);
		}
		
		protected function onContentResized(w:int, h:int):void
		{
		}
		
		override public function dispose():void
		{
			removeEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			if(m_content)
			{
				m_content.removeEventListener(ResizedEvent.RESIZED, __contentResizeHandler);
			}
			m_content = null;
			
			super.dispose();
		}
	}
}