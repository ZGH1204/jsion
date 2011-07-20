package org
{
	import flash.system.LoaderContext;
	
	import jcore.org.moduls.ModuleInfoMgr;

	public class Global
	{
		private static var _Current_Domain_Context:LoaderContext;
		
		public static function setup():void
		{
			_Current_Domain_Context = ModuleInfoMgr.Current_Domain_Context;
		}

		public static function get Current_Domain_Context():LoaderContext
		{
			return _Current_Domain_Context;
		}


	}
}