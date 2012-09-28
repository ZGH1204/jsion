package
{
	import spark.components.WindowedApplication;

	public class ToolGlobal
	{
		private static var m_windows:WindowedApplication
		
		public static function setup(win:WindowedApplication):void
		{
			if(m_windows || win == null) return;
			
			m_windows = win;
		}
		
		public static function get windows():WindowedApplication
		{
			return m_windows;
		}
	}
}