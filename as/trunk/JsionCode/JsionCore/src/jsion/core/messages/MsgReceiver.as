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
		
		/** @private */
		protected var m_parentReceiver:MsgReceiver;
		
		
		private var m_msgMonitor:MsgMonitorImp;
		
		private var m_globalMsgCount:int;
		
		
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
			
			MsgMonitor.registeReceiver(this);
			
			m_globalMsgCount = 0;
		}
		
		/**
		 * 父消息接收者
		 */		
		public function get parent():MsgReceiver
		{
			return m_parentReceiver;
		}
		
		
		
		
		
		
		/**
		 * 指示指定接收者ID是否存在于全局接收者列表
		 * @param receiverID
		 */		
		public function hasReceiver(receiverID:String):Boolean
		{
			return MsgMonitor.hasReceiver(receiverID);
		}
		
		
		
		
		
		/**
		 * 接收者ID
		 */		
		public function get id():String
		{
			return m_id;
		}
		
		/**
		 * 注册当前接收者处理指定消息的函数
		 * @param msg 消息标识
		 * @param handlerFn 以 Msg 对象为参数的处理函数
		 */		
		public function registeHandler(msg:uint, handlerFn:Function):void
		{
			m_handlers[msg] = handlerFn;
		}
		
		/**
		 * 移除当前接收者已注册的消息处理函数
		 * @param msg 消息标识
		 */		
		public function removeHandler(msg:uint):Function
		{
			return DictionaryUtil.delKey(m_handlers, msg) as Function;
		}
		
		/**
		 * 注册指定全局消息在当前接收者中的处理函数
		 * @param msg 消息标识
		 * @param handlerFn 以 Msg 对象为参数的处理函数
		 */		
		public function registeReceive(msg:uint, handlerFn:Function):void
		{
			MsgMonitor.registeMsgReceiver(msg, this);
			
			if(m_handlers[msg] == null)
				m_globalMsgCount++;
			
			registeHandler(msg, handlerFn);
		}
		
		/**
		 * 移除全局消息处理函数
		 * @param msg 消息标识
		 */		
		public function removeReceive(msg:uint):Function
		{
			if(m_handlers[msg] == null)
				m_globalMsgCount--;
			
			if(m_globalMsgCount <= 0)
			{
				m_globalMsgCount = 0;
				MsgMonitor.removeMsgReceiver(msg, this);
			}
			
			return removeHandler(msg);
		}
		
		/**
		 * 同步接收并处理消息
		 * @param msg
		 */		
		public function receiveSync(msg:Msg):*
		{
			if(m_handlers[msg.msg])
			{
				var handler:Function = m_handlers[msg.msg] as Function;
				
				if(handler != null) handler(msg);
			}
		}
		
		/**
		 * 异步接收消息，并在下帧时处理消息。
		 * @param msg
		 */		
		public function receiveAsync(msg:Msg):void
		{
			m_msgQueue.push(msg);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(m_msgQueue)
			{
				while(m_msgQueue.length > 0)
				{
					var msg:Msg = m_msgQueue.shift() as Msg;
					
					receiveSync(msg);
				}
			}
		}
		
		
		
		
		
		
		
		
		/**
		 * 同步发送消息，并以接收者ID为Key返回处理结果列表。
		 * @param msg 消息标识
		 * @param receivers 接收者ID列表
		 * @param wParam 参数
		 * @param lParam 参数
		 */		
		public function sendMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return MsgMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 异步发送消息
		 * @param msg 消息标识
		 * @param receivers 接收者ID列表
		 * @param wParam 参数
		 * @param lParam 参数
		 */		
		public function postMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return MsgMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 添加子消息接收者
		 * @param child
		 */		
		public function addChildReceiver(child:MsgReceiver):void
		{
			child.m_parentReceiver = this;
			m_childReceivers[child.id] = child;
		}
		
		/**
		 * 移除子消息接收者
		 * @param id
		 */		
		public function removeChildReceiver(id:String):MsgReceiver
		{
			var receiver:MsgReceiver = m_childReceivers[id] as MsgReceiver;
			
			if(receiver != null)
			{
				receiver.m_parentReceiver = null;
				return DictionaryUtil.delKey(m_childReceivers, id) as MsgReceiver;
			}
			
			return null;
		}
		
		/**
		 * 同步发送消息给子消息接收者，并以子消息接收者ID为Key返回处理结果列表。
		 * @param msg 消息标识
		 * @param receivers 子消息接收者ID列表
		 * @param wParam 参数
		 * @param lParam 参数
		 */		
		public function sendToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return m_msgMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 同步发送消息给子消息接收者
		 * @param msg 消息标识
		 * @param receivers 子消息接收者ID列表
		 * @param wParam 参数
		 * @param lParam 参数
		 */		
		public function postToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return m_msgMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 同步转发消息给所有子消息接收者，并以子消息接收者ID为Key返回处理结果列表。
		 * @param msg 消息对象
		 */		
		public function transToSubsSync(msg:Msg):Dictionary
		{
			return sendToSub(msg.msg, DictionaryUtil.getKeys(m_childReceivers), msg.wParam, msg.lParam);
		}
		
		/**
		 * 异步转发消息给所有子消息接收者
		 * @param msg 消息对象
		 */		
		public function transToSubsAsync(msg:Msg):void
		{
			postToSub(msg.msg, DictionaryUtil.getKeys(m_childReceivers), msg.wParam, msg.lParam);
		}
		
		
		
		
		
		
		
		public function dispose():void
		{
			MsgMonitor.removeReceiver(id);
			
			__enterFrameHandler(null);
			
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			DictionaryUtil.delAll(m_handlers);
			m_handlers = null;
			
			DisposeUtil.free(m_childReceivers);
			m_childReceivers = null;
			
			DisposeUtil.free(m_msgMonitor);
			m_msgMonitor = null;
			
			m_msgQueue = null;
			
			m_parentReceiver = null;
		}
	}
}