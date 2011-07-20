package jsion.actions
{
	import com.interfaces.IDispose;

	public class BaseAction implements IDispose
	{
		protected var _isPrepared:Boolean;
		protected var _isFinished:Boolean;
		
		public function BaseAction()
		{
			_isFinished = false;
		}
		
		public function connect(action:BaseAction):Boolean
		{
			return false;
		}
		
		public function canReplace(action:BaseAction):Boolean
		{
			return false;
		}
		
		public function get isFinished():Boolean
		{
			return _isFinished;
		}
		
		public function prepare():void
		{
			if(_isPrepared) return;
			_isPrepared = true;
		}
		
		public function execute():void
		{
			prepare();
			executeAtOnce();
			_isFinished = true;
		}
		
		public function executeAtOnce():void
		{
			prepare();
			_isFinished = true;
		}
		
		public function cancel():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}