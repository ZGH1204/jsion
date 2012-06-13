package jsion.socket
{
	import jsion.core.messages.Msg;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.socket.events.SocketEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 网络通信模块
	 * @author Jsion
	 * 
	 */	
	public class SocketModule extends BaseModule
	{
		private var _socket:PacketSocket;
		
		public function SocketModule(moduleInfo:ModuleInfo)
		{
			super(moduleInfo);
		}
		
		override public function startup():void
		{
			registeHandler(SocketMessage.SetPacketClass, setPacketClsss);
			registeHandler(SocketMessage.SetSendCryptor, setSendCryptor);
			registeHandler(SocketMessage.SetReceiveCryptor, setReceiveCryptor);
			
			registeHandler(SocketMessage.Connect, connect);
			registeHandler(SocketMessage.ForceConnect, forceConnect);
			registeHandler(SocketMessage.Close, close);
			registeHandler(SocketMessage.Send, send);
		}
		
		override public function stop():void
		{
			removeHandler(SocketMessage.SetPacketClass);
			removeHandler(SocketMessage.SetSendCryptor);
			removeHandler(SocketMessage.SetReceiveCryptor);
			
			removeHandler(SocketMessage.Connect);
			removeHandler(SocketMessage.ForceConnect);
			removeHandler(SocketMessage.Close);
			removeHandler(SocketMessage.Send);
			
			removeSocketEvent(_socket);
			
			DisposeUtil.free(_socket);
			_socket = null;
		}
		
		protected function setPacketClsss(msg:Msg):void
		{
			PacketFactory.setPacketClass(msg.wParam as Class);
		}
		
		protected function setSendCryptor(msg:Msg):void
		{
			PacketFactory.setSendCryptor(msg.wParam as IPacketCryptor);
		}
		
		protected function setReceiveCryptor(msg:Msg):void
		{
			PacketFactory.setReceiveCryptor(msg.wParam as IPacketCryptor);
		}
		
		protected function connect(msg:Msg):void
		{
			var ip:String = msg.wParam as String;
			var port:int = msg.lParam as int;
			
			if(_socket == null) _socket = new PacketSocket(ip, port);
			
			_socket.connect();
			addSocketEvent(_socket);
		}
		
		protected function addSocketEvent(sk:PacketSocket):void
		{
			if(sk)
			{
				sk.addEventListener(SocketEvent.CONNECTED, __connectedHandler);
				sk.addEventListener(SocketEvent.CLOSED, __closedHandler);
				sk.addEventListener(SocketEvent.ERROR, __errorHandler);
				sk.addEventListener(SocketEvent.RECEIVED, __receivedHandler);
			}
		}
		
		protected function removeSocketEvent(sk:PacketSocket):void
		{
			if(sk)
			{
				sk.removeEventListener(SocketEvent.CONNECTED, __connectedHandler);
				sk.removeEventListener(SocketEvent.CLOSED, __closedHandler);
				sk.removeEventListener(SocketEvent.ERROR, __errorHandler);
				sk.removeEventListener(SocketEvent.RECEIVED, __receivedHandler);
			}
		}
		
		private function __connectedHandler(e:SocketEvent):void
		{
			sendMsg(SocketMessage.Connected);
		}
		
		private function __closedHandler(e:SocketEvent):void
		{
			sendMsg(SocketMessage.Closed);
		}
		
		private function __errorHandler(e:SocketEvent):void
		{
			sendMsg(SocketMessage.Errored, null, e.eData);
		}
		
		private function __receivedHandler(e:SocketEvent):void
		{
			sendMsg(SocketMessage.Received, null, e.eData);
		}
		
		protected function forceConnect(msg:Msg):void
		{
			var ip:String = msg.wParam as String;
			var port:int = msg.lParam as int;
			
			removeSocketEvent(_socket);
			DisposeUtil.free(_socket);
			_socket = new PacketSocket(ip, port);
			
			_socket.connect();
			addSocketEvent(_socket);
		}
		
		protected function close(msg:Msg):void
		{
			if(_socket && _socket.isConnected)
				_socket.close();
		}
		
		protected function send(msg:Msg):void
		{
			var pkg:Packet = msg.wParam as Packet;
			
			if(_socket && _socket.isConnected)
				_socket.send(pkg);
		}
	}
}