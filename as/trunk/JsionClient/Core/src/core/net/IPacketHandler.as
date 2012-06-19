package core.net
{
	public interface IPacketHandler
	{
		function get code():int;
		
		function handle(pkg:GamePacket):void;
	}
}