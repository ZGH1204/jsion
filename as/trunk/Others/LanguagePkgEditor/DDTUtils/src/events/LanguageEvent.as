package events
{
	import code.LanguageBindModel;
	
	import flash.events.Event;

	public class LanguageEvent extends Event
	{
		public var LanguageInfo:LanguageBindModel;
		
		public function LanguageEvent(type:String, language:LanguageBindModel)
		{
			LanguageInfo = language;
			super(type);
		}
		
	}
}