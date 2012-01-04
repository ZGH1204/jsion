package jsion.tool
{
	import flash.display.Stage;
	
	import org.aswing.AsWingManager;

	public class ToolGlobal
	{
		private static var m_window:MainWindow;
		
		public static function get window():MainWindow
		{
			return m_window;
		}
		
		
		public static function setup(stage:Stage, w:int, h:int):void
		{
			if(m_window) return;
			
			AsWingManager.initAsStandard(stage);
			
			m_window = new MainWindow();
			m_window.setSizeWH(w, h);
			m_window.show();
		}
		
		public static function resize(w:int, h:int):void
		{
			if(m_window) m_window.setSizeWH(w, h);
		}
	}
}