package jsion
{
	import com.interfaces.IDispose;
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.actions.BaseAction;

	public class ActionManager implements IDispose
	{
		private var _sprite:Sprite;
		private var _queue:Vector.<BaseAction>;
		
		public function ActionManager()
		{
			_queue = new Vector.<BaseAction>();
			
			_sprite = new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			exec();
		}
		
		public function act(action:BaseAction):void
		{
			for(var i:int = 0; i < _queue.length; i++)
			{
				var at:BaseAction = _queue[i];
				if(at.connect(action))
				{
					DisposeHelper.dispose(action);
					return;
				}
				else if(at.canReplace(action))
				{
					action.prepare();
					_queue[i] = action;
					DisposeHelper.dispose(at);
					return;
				}
			}
			
			_queue.push(action);
			
			if(_queue.length == 1) action.prepare();
		}
		
		public function exec():void
		{
//			if(_queue.length > 0)
//			{
//				if(_queue[0].isFinished == false) _queue[0].execute();
//				
//				if(_queue[0].isFinished)
//				{
//					var action:BaseAction = _queue.shift();
//					DisposeHelper.dispose(action);
//					if(_queue.length > 0) _queue[0].prepare();
//				}
//			}
			
			for(var i:int = 0; i < _queue.length; i++)
			{
				_queue[i].prepare();
				if(_queue[i].isFinished)
				{
					var action:BaseAction = _queue.splice(i, 1)[0];
					DisposeHelper.dispose(action);
					action = null;
					i--;
					continue;
				}
				_queue[i].execute();
			}
		}
		
		public function get numActions():int
		{
			return _queue.length;
		}
		
		public function execAtOnce():void
		{
			for each(var action:BaseAction in _queue)
			{
				action.executeAtOnce();
			}
		}
		
		public function clear():void
		{
			while(_queue && _queue.length > 0)
			{
				var action:BaseAction = _queue.shift();
				action.cancel();
			}
		}
		
		public static function get Instance():ActionManager
		{
			return InstanceManager.createSingletonInstance(ActionManager) as ActionManager;
		}
		
		public function dispose():void
		{
			clear();
			_queue = null;
		}
	}
}