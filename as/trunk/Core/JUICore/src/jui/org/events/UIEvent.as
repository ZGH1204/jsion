package jui.org.events
{
	import flash.events.Event;
	
	import jutils.org.util.NameUtil;
	import jutils.org.util.StringUtil;
	
	public class UIEvent extends Event
	{
		
		
		public function UIEvent(type:String)
		{
			super(type);
		}
		
		override public function toString():String
		{
			return StringUtil.format("{0}(type:{1})", NameUtil.getUnqualifiedClassName(this), type);
		}
	}
}