package jsion.tool.respacker.events
{
	import flash.events.Event;
	
	public class PackerEvent extends Event
	{
		public static const ADD_ACTION:String = "addAction";
		
		protected var m_data:*;
		
		public function PackerEvent(type:String, data:* = null)
		{
			super(type, bubbles, cancelable);
			
			m_data = data;
		}

		public function get data():*
		{
			return m_data;
		}
		
		override public function clone():Event
		{
			return new PackerEvent(type, m_data);
		}
	}
}