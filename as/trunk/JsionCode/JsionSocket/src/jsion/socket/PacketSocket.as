package jsion.socket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import jsion.socket.events.SocketEvent;
	
	/**
	 * 处理数据包错误时分派，其中eData为错误提示消息。
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="handleError", type="jsocket.events.SocketEvent")]
	
	/**
	 * 发送数据包错误时分派，其中eData为错误提示消息。
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="sendError", type="jsocket.events.SocketEvent")]
	
	/**
	 * 收到并成功解析数据包时分派，其中eData为Packet对象。
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="received", type="jsocket.events.SocketEvent")]
	
	/**
	 * 连接关闭时分派
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="closed", type="jsocket.events.SocketEvent")]
	
	/**
	 * 发生错误时分派，其中eData为错误提示消息。
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jsocket.events.SocketEvent")]
	
	/**
	 * 连接成功后分派
	 * @eventType jsocket.events.SocketEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="connected", type="jsocket.events.SocketEvent")]
	public class PacketSocket extends EventDispatcher implements IDispose
	{
		public static const UNCONNECTED:String = "unconnected";
		public static const CONNECTING:String = "connecting";
		public static const CONNECTED:String = "connected";
		public static const ERROR:String = "error";
		public static const CLOSE:String = "close";
		
		protected var _ip:String;
		protected var _port:int;
		
		protected var _isConnected:Boolean;
		protected var _statu:String = UNCONNECTED;
		protected var _socket:Socket;
		protected var _reader:PacketReader;
		
		public function PacketSocket(ip:String, port:int)
		{
			_ip = ip;
			_port = port;
			
			_socket = new Socket();
			_reader = new PacketReader();
		}
		
		public function get ip():String
		{
			return _ip;
		}
		
		public function get port():int
		{
			return _port;
		}
		
		public function get isConnected():Boolean
		{
			return _isConnected;
		}
		
		public function get statu():String
		{
			return _statu;
		}
		
		public function connect(force:Boolean = false):void
		{
			if(_statu == CONNECTING) return;
			
			if(force && _isConnected)
			{
				removeEvent(_socket);
				close();
			}
			
			connectImp();
		}
		
		private function connectImp():void
		{
			if(_isConnected || _statu == CONNECTING) return;
			
			try
			{
				if(_socket && _socket.connected == false)
					_socket.connect(_ip, _port);
				addEvent(_socket);
				_isConnected = true;
				_statu = CONNECTING;
			}
			catch(err:Error)
			{
				dispatchEvent(new SocketEvent(SocketEvent.ERROR, err.getStackTrace()));
			}
		}
		
		public function close():void
		{
			if(_isConnected || _statu == CONNECTING)
			{
				if(_socket && _socket.connected)
					_socket.close();
				_isConnected = false;
				_statu = CLOSE;
			}
		}
		
		public function send(pkg:Packet):void
		{
			if(_isConnected == false || pkg == null) return;
			
			try
			{
				pkg.writeHeader();
				pkg.writeData();
				pkg.pack();
				
				PacketFactory.sendCryptor.encrypt(pkg);
				PacketFactory.sendCryptor.update();
				
				_socket.writeBytes(pkg, 0, pkg.length);
				
				_socket.flush();
			}
			catch(err:Error)
			{
				dispatchEvent(new SocketEvent(SocketEvent.SEND_ERROR, err.message));
			}
		}
		
		protected function addEvent(sk:Socket):void
		{
			if(sk)
			{
				sk.addEventListener(Event.CONNECT, __connectHandler);
				sk.addEventListener(Event.CLOSE, __closeHandler);
				sk.addEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
				sk.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __securityErrorHandler);
				sk.addEventListener(ProgressEvent.SOCKET_DATA, __receiveDataHandler);
			}
		}
		
		protected function removeEvent(sk:Socket):void
		{
			if(sk)
			{
				sk.removeEventListener(Event.CONNECT, __connectHandler);
				sk.removeEventListener(Event.CLOSE, __closeHandler);
				sk.removeEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
				sk.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __securityErrorHandler);
				sk.removeEventListener(ProgressEvent.SOCKET_DATA, __receiveDataHandler);
			}
		}
		
		private function __connectHandler(e:Event):void
		{
			if(_statu == CONNECTING)
			{
				_isConnected = true;
				_statu = CONNECTED;
				dispatchEvent(new SocketEvent(SocketEvent.CONNECTED));
			}
		}
		
		private function __closeHandler(e:Event):void
		{
			_isConnected = false;
			_statu = CLOSE;
			dispatchEvent(new SocketEvent(SocketEvent.CLOSED));
		}
		
		private function __ioErrorHandler(e:IOErrorEvent):void
		{
			_isConnected = false;
			_statu = ERROR;
			dispatchEvent(new SocketEvent(SocketEvent.ERROR, e.text));
		}
		
		private function __securityErrorHandler(e:SecurityErrorEvent):void
		{
			_isConnected = false;
			_statu = ERROR;
			dispatchEvent(new SocketEvent(SocketEvent.ERROR, e.text));
		}
		
		private function __receiveDataHandler(e:ProgressEvent):void
		{
			_reader.readBytes(_socket);
			var list:Array = _reader.readPacket();
			
			while(list.length > 0)
			{
				var pkg:Packet = list.shift() as Packet;
				try
				{
					dispatchEvent(new SocketEvent(SocketEvent.RECEIVED, pkg));
				}
				catch(err:Error)
				{
					dispatchEvent(new SocketEvent(SocketEvent.HANDLE_ERROR, err.message));
				}
			}
		}
		
		public function dispose():void
		{
			removeEvent(_socket);
			close();
			_socket = null;
			_reader = null;
		}
	}
}