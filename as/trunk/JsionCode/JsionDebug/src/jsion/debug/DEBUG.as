package jsion.debug
{
	import flash.display.Stage;

	/**
	 * 信息调试器代理(全局静态)
	 * @author Jsion
	 */	
	public class DEBUG
	{
		private static var m_debugger:Debugger;
		
		public static function setup(stage:Stage, w:int):void
		{
			if(m_debugger) return;
			
			m_debugger = new Debugger(w, stage.stageHeight);
			m_debugger.x = stage.stageWidth;
			
			stage.addChild(m_debugger);
		}
		
		public static function loadCSS(path:String):void
		{
			m_debugger.loadCSS(path);
		}
		
		public static function info(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.info.apply(null, args);
		}
		
		public static function debug(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.debug.apply(null, args);
		}
		
		public static function warn(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.warn.apply(null, args);
		}
		
		public static function error(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.error.apply(null, args);
		}
	}
}