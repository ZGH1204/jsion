package jsion.tool
{
	import flash.display.Stage;
	
	import mx.core.IVisualElement;
	
	import org.aswing.AsWingManager;
	
	import spark.components.WindowedApplication;

	public class ToolGlobal
	{
		private static var m_stage:Stage;
		private static var m_window:MainWindow;
		private static var m_app:WindowedApplication;
		
		public static function get window():MainWindow
		{
			return m_window;
		}
		
		public static function get stage():Stage
		{
			return m_stage;
		}
		
		public static function get windowedApp():WindowedApplication
		{
			return m_app;
		}
		
		public static function setup(stage:Stage, app:WindowedApplication, w:int, h:int):void
		{
			if(m_window) return;
			
			m_stage = stage;
			
			m_app = app;
			
			AsWingManager.initAsStandard(stage);
			
			m_window = new MainWindow();
			m_window.setSizeWH(w, h);
			m_window.show();
		}
		
		public static function drawSpark(ui:IVisualElement):void
		{
			m_app.addElement(ui);
		}
		
		public static function resize(w:int, h:int):void
		{
			if(m_window) m_window.setSizeWH(w, h);
		}
	}
}