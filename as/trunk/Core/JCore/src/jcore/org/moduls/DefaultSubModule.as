package jcore.org.moduls
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import jcore.org.message.IMsgReceiver;
	import jcore.org.message.Message;
	import jcore.org.message.MessageMonitor;
	import jcore.org.message.MessageMonitorImp;
	
	import jutils.org.reflection.Assembly;
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DictionaryUtil;
	
	public class DefaultSubModule implements IMsgReceiver, IDispose
	{
		protected var _subID:String;
		
		protected var _isInstalled:Boolean;
		
		protected var _msgMonitor:MessageMonitorImp;
		
		protected var _msgQueue:Array = [];
		
		protected var _msgHandleFnList:Dictionary = new Dictionary();
		
		public function DefaultSubModule(subID:String, msgMonitor:MessageMonitorImp)
		{
			if(msgMonitor == null) throw new ArgumentError("参数 msgMonitor 不能为空!");
			
			_subID = subID;
			_msgMonitor = msgMonitor;
			
			registeMsgHandleFn(ModuleDefaultMsg.Install, install);
			registeMsgHandleFn(ModuleDefaultMsg.Uninstall, uninstall);
			
			JUtil.addEnterFrame(__enterFrameHandler);
		}
		
		public function get id():String
		{
			return _subID;
		}
		
		public function get subID():String
		{
			return _subID;
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
		public function sendMessage(msg:uint, receivers:Array, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return MessageMonitor.createAndSendMsg(msg, subID, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且异步发送消息对象给模块对象
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public function postMessage(msg:uint, receivers:Array, wParam:Object = null, lParam:Object = null):Message
		{
			return MessageMonitor.createAndPostMsg(msg, subID, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且同步发送消息对象给同级的子模块
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 所有接收者的返回对象字典列表，其中"SendedMsg"指示已发送过的消息对象。
		 * 
		 */		
		public function sendMsgToSub(msg:uint, receivers:Array, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return _msgMonitor.createAndSendMsg(msg, subID, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且异步发送消息对象给同级的子模块
		 * @param msg 消息标识
		 * @param receivers 接收者列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public function postMsgToSub(msg:uint, receivers:Array, wParam:Object = null, lParam:Object = null):Message
		{
			return _msgMonitor.createAndPostMsg(msg, subID, receivers, wParam, lParam);
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
		 */		
		public function registeReceiveMsg(msg:uint, fn:Function):void
		{
			_msgMonitor.registeMsgReceiver(msg, this);
			
			registeMsgHandleFn(msg, fn);
		}
		
		/**
		 * 移除接收指定消息
		 * @param msg 消息标识
		 */		
		public function removeReceiveMsg(msg:uint):void
		{
			_msgMonitor.removeMsgReceiver(msg, this);
			
			removeMsgHandleFn(msg);
		}
		
		/**
		 * 注册消息响应函数
		 * @param msg 消息标识
		 * @param fn 带一个Message参数的函数
		 * 
		 */		
		public function registeMsgHandleFn(msg:uint, fn:Function):void
		{
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
			
			return null;
		}
		
		/**
		 * 卸载模块
		 */		
		protected function uninstall(msg:Message):Object
		{
			_isInstalled = false;
			
			return null;
		}
		
		////////////////////////////////////	模块相关		////////////////////////////////////
		
		
		public function dispose():void
		{
			uninstall(null);
			
			_msgMonitor.removeReceiver(subID);
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			DictionaryUtil.delAll(_msgHandleFnList);
			_msgHandleFnList = null;
			
			ArrayUtil.removeAll(_msgQueue);
			_msgQueue = null;
			
			_msgMonitor = null;
		}
	}
}