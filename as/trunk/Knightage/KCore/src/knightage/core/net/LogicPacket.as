package knightage.core.net
{
	/**
	 * 逻辑服务器数据包基类
	 * @author Jsion
	 */	
	public class LogicPacket extends KPacket
	{
		public function LogicPacket(code:int=0)
		{
			super(code, PacketCodes.LogicCode);
		}
	}
}