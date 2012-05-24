package jsion.core.messages
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;

	/**
	 * 消息监视器实现类
	 * @author Jsion
	 * 
	 */	
	public class MsgMonitorImp implements IDispose
	{
		private var msgReceiverList:Dictionary = new Dictionary();
		
		private var receiverList:Dictionary = new Dictionary();
		
		/**
		 * 注册指定消息的接收者
		 * @param msg 消息标识
		 * @param receiver 接收者
		 * 
		 */		
		public function registeMsgReceiver(msg:uint, receiver:IMsgReceiver):void
		{
			if(receiver == null)
			{
				throw new ArgumentError("参数 receiver 不能为空!");
				return ;
			}
			
			if(msgReceiverList[msg] == null) msgReceiverList[msg] = [];
			
			ArrayUtil.push(msgReceiverList[msg], receiver);
		}
		
		/**
		 * 移除指定消息的接收者
		 * @param msg 消息标识
		 * @param receiver 接收者
		 * 
		 */		
		public function removeMsgReceiver(msg:uint, receiver:IMsgReceiver):void
		{
			if(msgReceiverList[msg] == null) return;
			
			ArrayUtil.remove(msgReceiverList[msg], receiver);
		}
		
		/**
		 * 指示是否存在指定ID的接收者
		 * @param id 接收者ID
		 * @return true表示存在
		 * 
		 */		
		public function hasReceiver(id:String):Boolean
		{
			if(receiverList[id]) return true;
			
			return false;
		}
		
		/**
		 * 注册消息接收者
		 * @param id 接收者标识
		 * @param receiver 接收者对象
		 * 
		 */		
		public function registeReceiver(receiver:IMsgReceiver):void
		{
			if(receiver == null)
			{
				throw new ArgumentError("参数 receiver 不能为空!");
				return ;
			}
			
			if(receiverList[receiver.id])
			{
				throw new Error(receiver.id + " 的接收者已存在，无法注册。");
				return;
			}
			
			receiverList[receiver.id] = receiver;
		}
		
		/**
		 * 移除消息接收者
		 * @param id 接收者标识
		 * 
		 */		
		public function removeReceiver(id:String):IMsgReceiver
		{
			return DictionaryUtil.delKey(receiverList, id);
		}
		
		/**
		 * 移除并析构消息接收者
		 * @param id 接收者标识
		 * 
		 */		
		public function removeAndFreeReceiver(id:String):void
		{
			if(receiverList[id])
			{
				var obj:Object = DictionaryUtil.delKey(receiverList, id);
				
				DisposeUtil.free(obj);
			}
		}
		
		/**
		 * 同步发送消息
		 * @param msg 消息体
		 * @return 所有接收者的返回对象字典列表
		 * 
		 */		
		public function sendMessage(msg:Msg):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var obj:Object;
			
			if(msgReceiverList[msg.msg])
			{
				var list:Array = msgReceiverList[msg.msg] as Array;
				
				for each(var item:IMsgReceiver in list)
				{
					obj = item.receiveSync(msg);
					if(obj) dic[id] = obj;
				}
			}
			
			for each(var id:String in msg.receivers)
			{
				var receiver:IMsgReceiver = IMsgReceiver(receiverList[id]);
				
				if(receiver == null)
				{
					//throw new Error(id + " 接收者不存在!");
					continue;
				}
				
				obj = receiver.receiveSync(msg);
				if(obj) dic[id] = obj;
			}
			
			return dic;
		}
		
		/**
		 * 异步发送消息
		 * @param msg 消息体
		 * 
		 */		
		public function postMessage(msg:Msg):void
		{
			var receiver:IMsgReceiver;
			
			if(msgReceiverList[msg.msg])
			{
				var list:Array = msgReceiverList[msg.msg] as Array;
				
				for each(receiver in list)
				{
					receiver.receiveAsync(msg);
				}
			}
			
			for each(var id:String in msg.receivers)
			{
				receiver = IMsgReceiver(receiverList[id]);
				
				if(receiver == null)
				{
					//throw new Error(id + " 接收者不存在!");
					continue;
				}
				
				receiver.receiveAsync(msg);
			}
		}
		
		/**
		 * 创建消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 消息对象
		 * 
		 */		
		public function createMsg(msg:uint, sender:String, receivers:Array, wParam:Object = null, lParam:Object = null):Msg
		{
			var m:Msg = new Msg();
			
			m.sender = sender;
			m.receivers = receivers;
			m.msg = msg;
			m.wParam = wParam;
			m.lParam = lParam;
			m.time = getTimer();
			
			return m;
		}
		
		/**
		 * 创建并且同步发送消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 所有接收者的返回对象字典列表，其中"SendedMsg"指示已发送过的消息对象。
		 * 
		 */		
		public function createAndSendMsg(msg:uint, sender:String, receivers:Array, wParam:Object = null, lParam:Object = null):Dictionary
		{
			var m:Msg = createMsg(msg, sender, receivers, wParam, lParam);
			
			var dic:Dictionary = sendMessage(m);
			
			dic["SendedMsg"] = m;
			
			return dic;
		}
		
		/**
		 * 创建并且异步发送消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public function createAndPostMsg(msg:uint, sender:String, receivers:Array, wParam:Object = null, lParam:Object = null):Msg
		{
			var m:Msg = createMsg(msg, sender, receivers, wParam, lParam);
			
			postMessage(m);
			
			return m;
		}
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			for each(var list:Array in msgReceiverList)
			{
				ArrayUtil.removeAll(list);
			}
			
			DictionaryUtil.delAll(msgReceiverList);
			msgReceiverList = null;
			
			DictionaryUtil.delAll(receiverList);
			receiverList = null;
		}
	}
}