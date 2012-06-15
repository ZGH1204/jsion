package jsion.socket
{
	/**
	 * 动态密钥
	 * @author Jsion
	 */	
	public class FSM
	{
		private var _state:int;
		private var _adder:int;
		private var _multiper:int;
		
		/**
		 * 状态密钥数据
		 * @return 
		 * 
		 */		
		public function get State():int
		{
			return (_state & (0xFF << 16)) >> 16;
		}
		
		public function FSM(adder:int,multiper:int)
		{
			setup(adder,multiper);
		}
		
		/**
		 * 重置
		 */		
		public function reset():void
		{
			_state = 0;
		}
		
		/**
		 * 初始化
		 * @param adder
		 * @param multiper
		 * 
		 */		
		public function setup(adder:int,multiper:int):void
		{
			_adder = adder;
			_multiper = multiper;
			reset();
			updateState();
		}
		
		/**
		 * 更新密钥数据
		 */		
		public function updateState():int
		{
			_state = ((~ _state) + _adder) * _multiper;
			_state = _state ^ (_state >> 16);
			return (_state & (0xFF << 16)) >> 16;
		}
	}
}