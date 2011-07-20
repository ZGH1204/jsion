package jsocket
{
	import jcore.org.message.Message;
	import jcore.org.moduls.DefaultModule;
	import jcore.org.moduls.ModuleInfo;
	
	import jsocket.events.SocketEvent;
	import jsocket.net.IPacketCryptor;
	import jsocket.net.PacketFactory;
	import jsocket.net.PacketSocket;
	
	public class SocketModule extends DefaultModule
	{
		private var _socket:PacketSocket;
		
		public function SocketModule(moduleInfo:ModuleInfo)
		{
			super(moduleInfo);
		}
		
		override protected function install(msg:Message):Object
		{
			registeReceiveMsg(SocketMessage.SetPacketClass, setPacketClsss);
			registeReceiveMsg(SocketMessage.SetSendCryptor, setSendCryptor);
			registeReceiveMsg(SocketMessage.SetReceiveCryptor, setReceiveCryptor);
			
			registeReceiveMsg(SocketMessage.Connect, connect);
			registeReceiveMsg(SocketMessage.ForceConnect, forceConnect);
			registeReceiveMsg(SocketMessage.Close, close);
			registeReceiveMsg(SocketMessage.Send, send);
			
			return super.install(msg);
		}
		
		override protected function uninstall(msg:Message):Object
		{
			removeReceiveMsg(SocketMessage.SetPacketClass, setPacketClsss);
			removeReceiveMsg(SocketMessage.SetSendCryptor, setSendCryptor);
			removeReceiveMsg(SocketMessage.SetReceiveCryptor, setReceiveCryptor);
			
			removeReceiveMsg(SocketMessage.Connect, connect);
			removeReceiveMsg(SocketMessage.ForceConnect, forceConnect);
			removeReceiveMsg(SocketMessage.Close, close);
			removeReceiveMsg(SocketMessage.Send, send);
			removeSocketEvent(_socket);
			
			return super.uninstall(msg);
		}
		
		protected function setPacketClsss(msg:Message):void
		{
			PacketFactory.setPacketClass(msg.wParam as Class);
		}
		
		protected function setSendCryptor(msg:Message):void
		{
			PacketFactory.setSendCryptor(msg.wParam as IPacketCryptor);
		}
		
		protected function setReceiveCryptor(msg:Message):void
		{
			PacketFactory.setReceiveCryptor(msg.wParam as IPacketCryptor);
		}
		
		protected function connect(msg:Message):void
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
			sendMessage(SocketMessage.Connected);
		}
		
		private function __closedHandler(e:SocketEvent):void
		{
			sendMessage(SocketMessage.Closed);
		}
		
		private function __errorHandler(e:SocketEvent):void
		{
			sendMessage(SocketMessage.Errored, null, e.eData);
		}
		
		private function __receivedHandler(e:SocketEvent):void
		{
			sendMessage(SocketMessage.Received, null, e.eData);
		}
		
		protected function forceConnect(msg:Message):void
		{
			var ip:String = msg.wParam as String;
			var port:int = msg.lParam as int;
			
			if(_socket == null) _socket = new PacketSocket(ip, port);
			
			_socket.connect(true);
			addSocketEvent(_socket);
		}
		
		protected function close(msg:Message):void
		{
			if(_socket && _socket.isConnected)
				_socket.close();
		}
		
		protected function send(msg:Message):void
		{
			var pkg:Packet = msg.wParam as Packet;
			
			if(_socket && _socket.isConnected)
				_socket.send(pkg);
		}
	}
}