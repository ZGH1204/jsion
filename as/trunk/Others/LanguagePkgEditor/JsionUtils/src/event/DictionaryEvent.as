package event
{
	import flash.events.Event;

	public class DictionaryEvent extends Event
	{
		public static const PREADD:String = "preaddDictionary";
		public static const PREUPDATE:String = "preupdateDictionary";
		public static const PREDELETE:String = "predeleteDictionary";
		public static const PRECLEAR:String = "preclearDictionary";
		public static const ADD:String = "addDictionary";
		public static const UPDATE:String = "updateDictionary";
		public static const DELETE:String = "deleteDictionary";
		public static const CLEAR:String = "clearDictionary";
		
		private var _oldData:*;
		private var _newData:*;
		
		public function get oldData():*
		{
			return _oldData;
		}
		
		public function get newData():*
		{
			return _newData;
		}
		
		public function DictionaryEvent(type:String, $newData:* = null, $oldData:* = null)
		{
			_newData = $newData;
			_oldData = $oldData;
			super(type);
		}
		
	}
}