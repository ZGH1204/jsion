package
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import jcore.org.moduls.ModuleInfoMgr;

	public class Global
	{
		private static var _Current_Domain:ApplicationDomain = ApplicationDomain.currentDomain;
		private static var _Current_Domain_Context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		
		public static function get Current_Domain_Context():LoaderContext
		{
			return _Current_Domain_Context;
		}

		public static function get Current_Domain():ApplicationDomain
		{
			return _Current_Domain;
		}
	}
}