package jsion.tool
{
	import org.aswing.JFrame;
	import org.aswing.event.ResizedEvent;
	
	public class BaseFrame extends JFrame
	{
		protected var m_win:MainWindow;
		
		protected var m_title:String;
		
		public function BaseFrame(owner:* = null, modal:Boolean = false)
		{
			m_win = owner as MainWindow;
			
			super(owner, m_title, modal);
			
			addEventListener(ResizedEvent.RESIZED, __resizeHandler);
		}
		
		private function __resizeHandler(e:ResizedEvent):void
		{
			setLocationXY((m_win.width - width) / 2, (m_win.height - height) / 2);
		}
		
		override public function dispose():void
		{
			removeEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			super.dispose();
		}
	}
}