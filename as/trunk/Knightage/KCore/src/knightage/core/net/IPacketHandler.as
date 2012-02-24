package knightage.core.net
{

	public interface IPacketHandler
	{
		function get code():int;
		
		function handle(pkg:KPacket):void;
	}
}