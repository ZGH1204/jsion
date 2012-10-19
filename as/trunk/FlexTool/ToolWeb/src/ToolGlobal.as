package
{
	import spark.components.Application;

	public class ToolGlobal
	{
		private static var m_windows:Application
		
		public static function setup(win:Application):void
		{
			if(m_windows || win == null) return;
			
			m_windows = win;
		}
		
		public static function get windows():Application
		{
			return m_windows;
		}
	}
}