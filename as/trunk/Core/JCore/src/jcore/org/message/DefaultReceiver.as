package jcore.org.message
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import jcore.org.moduls.ModuleDefaultMsg;
	
	import jutils.org.reflection.Assembly;
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DictionaryUtil;
	import jutils.org.util.DisposeUtil;

	public class DefaultReceiver implements IMsgReceiver, IDispose
	{
		protected var _id:String;
		
		protected var _isInstalled:Boolean;
		
		protected var _msgQueue:Array = [];
		
		protected var _msgHandleFnList:Dictionary = new Dictionary();
		
		
		protected var _subs:Dictionary = new Dictionary();
		
		protected var _subsMsgMonitor:MessageMonitorImp = new MessageMonitorImp();
		
		public function DefaultReceiver(id:String)
		{
			_id = id;
			
			_isInstalled = false;
			
			registeMsgHandleFn(ModuleDefaultMsg.Install, install);
			registeMsgHandleFn(ModuleDefaultMsg.Uninstall, uninstall);
			
			JUtil.addEnterFrame(__enterFrameHandler);
			MessageMonitor.registeReceiver(this);
		}
		
		/**
		 * 模块标识
		 */		
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * 指示模块是否安装
		 */		
		public function get isInstalled():Boolean
		{
			return _isInstalled;
		}
		
		/**
		 * 模块内的消息队列
		 */		
		public function get msgQueue():Array
		{
			return _msgQueue;
		}
		
		/**
		 * 模块内注册的消息处理函数
		 */		
		public function get msgHandleFnList():Dictionary
		{
			return _msgHandleFnList;
		}
		
		////////////////////////////////////	消息系统相关		////////////////////////////////////
		
		/**
		 * 创建并且同步发送消息对象给模块对象
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 所有接收者的返回对象字典列表，其中"SendedMsg"指示已发送过的消息对象。
		 * 
		 */		
		public function sendMessage(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return MessageMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且异步发送消息对象给模块对象
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public function postMessage(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Message
		{
			return MessageMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且同步发送消息对象给子模块对象
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 所有接收者的返回对象字典列表，其中"SendedMsg"指示已发送过的消息对象。
		 * 
		 */		
		public function sendMsgToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return _subsMsgMonitor.createAndSendMsg(msg, id, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且异步发送消息对象给子模块对象
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public function postMsgToSub(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Message
		{
			return _subsMsgMonitor.createAndPostMsg(msg, id, receivers, wParam, lParam);
		}
		
		public function allowReceived(msg:Message):Boolean
		{
			return _msgHandleFnList[msg.msg] is Function;
		}
		
		public function receiveSync(msg:Message):Object
		{
			if(_isInstalled)
			{
				if(_msgHandleFnList[msg.msg] == null)
				{
					throw new Error(msg.msg + " 消息未注册对应的处理函数");
					return;
				}
				
				return _msgHandleFnList[msg.msg].apply(null, [msg]);
			}
			
			if(msg.msg == ModuleDefaultMsg.Install)
				return install(msg);
			
			return null;
		}
		
		public function receiveAsync(msg:Message):void
		{
			_msgQueue.push(msg);
		}
		
		/**
		 * 注册接收指定消息
		 * @param msg 消息标识
		 * @param fn 带一个Message参数的处理函数
		 */		
		public function registeReceiveMsg(msg:uint, fn:Function):void
		{
			MessageMonitor.registeMsgReceiver(msg, this);
			
			registeMsgHandleFn(msg, fn);
		}
		
		/**
		 * 移除接收指定消息
		 * @param msg 消息标识
		 * @param fn 带一个Message参数的处理函数
		 */		
		public function removeReceiveMsg(msg:uint, fn:Function):void
		{
			MessageMonitor.removeMsgReceiver(msg, this);
			
			removeMsgHandleFn(msg);
		}
		
		/**
		 * 注册消息响应函数
		 * @param msg 消息标识
		 * @param fn 带一个Message参数的处理函数
		 * 
		 */		
		public function registeMsgHandleFn(msg:uint, fn:Function):void
		{
			if(fn == null) return;
			if(_msgHandleFnList[msg])
			{
				throw new Error(msg + " 消息处理函数已注册，请更换消息标识 msg。");
				return;
			}
			
			_msgHandleFnList[msg] = fn;
		}
		
		/**
		 * 移除消息响应函数
		 * @param msg 消息标识
		 * 
		 */		
		public function removeMsgHandleFn(msg:uint):void
		{
			DictionaryUtil.delKey(_msgHandleFnList, msg);
		}
		
		protected function __enterFrameHandler(e:Event):void
		{
			while(_msgQueue && _msgQueue.length > 0)
			{
				var msg:Message = _msgQueue.shift() as Message;
				
				receiveSync(msg);
			}
		}
		
		////////////////////////////////////	消息系统相关		////////////////////////////////////
		
		
		////////////////////////////////////	模块相关		////////////////////////////////////
		
		/**
		 * IOC控制反转
		 * @param assembly 当前模块程序集信息
		 */		
		internal function reflection(assembly:Assembly):void
		{
			
		}
		
		/**
		 * 安装模块
		 */		
		protected function install(msg:Message):Object
		{
			_isInstalled = true;
			
			//转发消息到所有子模块
			transToSubsSync(msg);
			
			return null;
		}
		
		/**
		 * 卸载模块
		 */		
		protected function uninstall(msg:Message):Object
		{
			_isInstalled = false;
			
			//转发消息到所有子模块
			transToSubsSync(msg);
			
			return null;
		}
		
		/**
		 * 转发消息给所有子模块(同步执行)
		 * @param msg 消息对象
		 * 
		 */		
		public function transToSubsSync(msg:Message):void
		{
			sendMsgToSub(msg.msg, DictionaryUtil.getKeys(_subs), msg.wParam, msg.lParam);
		}
		
		/**
		 * 转发消息给所有子模块(异步执行)
		 * @param msg 消息对象
		 * 
		 */		
		public function transToSubsAsync(msg:Message):void
		{
			postMsgToSub(msg.msg, DictionaryUtil.getKeys(_subs), msg.wParam, msg.lParam);
		}
		
		/**
		 * 注册子模块
		 * @param subID 子模块ID
		 * @param subModuleCls 子模块对应的类
		 * 
		 */		
		public function registeSubReceive(subID:String, subReceiverCls:Class):DefaultSubReceiver
		{
			if(_subs[subID])
			{
				throw new Error(subID + " 对应的子模块已注册，请更换子模块ID。");
				return;
			}
			
			if(subReceiverCls == null)
			{
				throw new Error(subID + " 对应的子模块不能为空。");
				return;
			}
			
			var sub:DefaultSubReceiver = new subReceiverCls();
			sub.setIdAndMonitor(subID, _subsMsgMonitor);
			//sub.reflection(_moduleInfo.assembly);
			_subsMsgMonitor.registeReceiver(sub);
			_subs[subID] = sub;
			
			return sub;
		}
		
		////////////////////////////////////	模块相关		////////////////////////////////////
		
		public function dispose():void
		{
			uninstall(null);
			
			MessageMonitor.removeReceiver(id);
			
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			DictionaryUtil.delAll(_subs);
			_subs = null;
			
			DictionaryUtil.delAll(_msgHandleFnList);
			_msgHandleFnList = null;
			
			ArrayUtil.removeAll(_msgQueue);
			_msgQueue = null;
			
			DisposeUtil.free(_subsMsgMonitor);
			_subsMsgMonitor = null;
		}
	}
}