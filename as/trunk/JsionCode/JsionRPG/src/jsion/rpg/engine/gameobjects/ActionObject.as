package jsion.rpg.engine.gameobjects
{
	public class ActionObject extends MovieObject
	{
		protected var m_action:int;
		
		public function ActionObject()
		{
			super();
		}
		
		public function get action():int
		{
			return m_action;
		}

		public function set action(value:int):void
		{
			m_action = value;
		}
	}
}