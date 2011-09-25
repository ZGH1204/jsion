package
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class Global
	{
		private static var m_currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		private static var m_currentContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		
		public static function get CurrentDomainContext():LoaderContext
		{
			return m_currentContext;
		}

		public static function get CurrentDomain():ApplicationDomain
		{
			return m_currentDomain;
		}
	}
}