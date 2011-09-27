package jsion.socket
{
	public class FSM
	{
		private var _state:int;
		private var _adder:int;
		private var _multiper:int;
		
		public function get State():int
		{
			return (_state & (0xFF << 16)) >> 16;
		}
		
		public function FSM(adder:int,multiper:int)
		{
			setup(adder,multiper);
		}
		
		public function reset():void
		{
			_state = 0;
		}
		
		public function setup(adder:int,multiper:int):void
		{
			_adder = adder;
			_multiper = multiper;
			reset();
			updateState();
		}
		
		public function updateState():int
		{
			_state = ((~ _state) + _adder) * _multiper;
			_state = _state ^ (_state >> 16);
			return (_state & (0xFF << 16)) >> 16;
		}
	}
}