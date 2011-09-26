package jsion.core.messages
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.StringUtil;

	public class MsgReceiver implements IMsgReceiver, IDispose
	{
		private var m_id:String;
		
		private var m_msgQueue:Array;
		
		private var m_handlers:Dictionary;
		
		private var m_childReceivers:Dictionary;
		
		protected var m_parentReceiver:MsgReceiver;
		
		
		private var m_msgMonitor:MsgMonitorImp;
		
		
		public function MsgReceiver(id:String)
		{
			if(StringUtil.isNullOrEmpty(id))
				throw new Error("id不能为空!");
			
			m_id = id;
			m_msgQueue = [];
			m_handlers = new Dictionary();
			m_childReceivers = new Dictionary();
			JUtil.addEnterFrame(__enterFrameHandler);
			
			m_msgMonitor = new MsgMonitorImp();
		}
		
		public function get parent():MsgReceiver
		{
			return m_parentReceiver;
		}
		
		public function get id():String
		{
			return m_id;
		}
		
		public function registeHandler(msg:uint, handlerFn:Function):void
		{
			m_handlers[msg] = handlerFn;
		}
		
		public function removeHandler(msg:uint):Function
		{
			return DictionaryUtil.delKey(m_handlers, msg) as Function;
		}
		
		public function registeReceive(msg:uint, handlerFn:Function):void
		{
			MsgMonitor.registeMsgReceiver(msg, this);
			
			registeHandler(msg, handlerFn);
		}
		
		public function removeReceive(msg:uint):Function
		{
			MsgMonitor.removeMsgReceiver(msg, this);
			
			return removeHandler(msg);
		}
		
		public function receiveSync(msg:Msg):*
		{
			if(m_handlers[msg.msg])
			{
				var handler:Function = m_handlers[msg.msg] as Function;
				
				if(handler != null) handler(msg);
			}
		}
		
		public function receiveAsync(msg:Msg):void
		{
			m_msgQueue.push(msg);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(m_msgQueue)
			{
				while(m_msgQueue.count > 0)
				{
					var msg:Msg = m_msgQueue.shift() as Msg;
					
					receiveSync(msg);
				}
			}
		}
		
		
		
		
		
		
		
		
		
		public function sendMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return MsgMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		public function postMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return MsgMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		public function addChildReceiver(child:MsgReceiver):void
		{
			child.m_parentReceiver = this;
			m_childReceivers[child.id] = child;
		}
		
		public function sendToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return m_msgMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		public function postToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return m_msgMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		public function transToSubsSync(msg:Msg):Dictionary
		{
			return sendToSub(msg.msg, DictionaryUtil.getKeys(m_childReceivers), msg.wParam, msg.lParam);
		}
		
		public function transToSubsAsync(msg:Msg):void
		{
			postToSub(msg.msg, DictionaryUtil.getKeys(m_childReceivers), msg.wParam, msg.lParam);
		}
		
		
		
		
		
		
		
		public function dispose():void
		{
			__enterFrameHandler(null);
			
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			DictionaryUtil.delAll(m_handlers);
			m_handlers = null;
			
			DictionaryUtil.delAll(m_childReceivers);
			m_childReceivers = null;
			
			DisposeUtil.free(m_msgMonitor);
			m_msgMonitor = null;
			
			m_msgQueue = null;
			
			m_parentReceiver = null;
		}
	}
}