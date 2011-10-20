package jsion.core.actions
{
	import flash.events.Event;
	
	import jsion.utils.*;

	/**
	 * Action动作轴
	 * @author Jsion
	 */	
	public class ActionLine implements IDispose
	{
		private var _multiple:Boolean;
		private var _queue:Vector.<Action>;
		
		public function ActionLine(multiple:Boolean = false)
		{
			_multiple = multiple;
			_queue = new Vector.<Action>();
			JUtil.addEnterFrame(__enterFrameHandler);
		}
		
		/**
		 * 当前Action数量
		 */		
		public function numAction():int
		{
			return _queue.length;
		}
		
		/**
		 * 添加Action对象
		 * @param a
		 */		
		public function act(a:Action):void
		{
			if(a == null) return;
			
			for(var i:int = 0; i < _queue.length; i++)
			{
				var at:Action = _queue[i];
				if(at.connect(a))
				{
					DisposeUtil.free(a);
					return;
				}
				else if(at.replace(a))
				{
					if(at.isPrepared && at.isFinished == false)
					{
						a.isPrepared = true;
						a.prepare();
					}
					
					_queue[i] = a;
					DisposeUtil.free(at);
					
					return;
				}
			}
			
			_queue.push(a);
		}
		
		/** @private */
		protected function __enterFrameHandler(e:Event):void
		{
			if(_multiple) executeLine();
			else executeMulti();
		}
		
		/** @private */
		protected function executeLine():void
		{
			if(_queue.length == 0) return;
			
			if(_queue[0].isPrepared == false)
			{
				_queue[0].isPrepared = true;
				_queue[0].prepare();
			}
			
			if(_queue[0].isFinished)
			{
				_queue[0].finish();
				DisposeUtil.free(_queue.shift());
			}
			else
			{
				_queue[0].execute();
			}
		}
		
		/** @private */
		protected var i:int = 0;
		
		/** @private */
		protected function executeMulti():void
		{
			for(i = 0; i < _queue.length; i++)
			{
				if(_queue[i].isPrepared == false)
				{
					_queue[i].isPrepared = true;
					_queue[i].prepare();
				}
				
				if(_queue[i].isFinished)
				{
					i--;
					_queue[i].finish();
					DisposeUtil.free(_queue.splice(i, 1)[0]);
				}
				else
				{
					_queue[i].execute();
				}
			}
		}
		
		public function dispose():void
		{
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			while(_queue && _queue.length > 0)
			{
				_queue.shift();
			}
			_queue = null;
		}
	}
}