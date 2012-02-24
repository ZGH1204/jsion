package knightage.core.net
{
	/**
	 * 网关服务器数据包基类
	 * @author Jsion
	 */	
	public class GatewayPacket extends KPacket
	{
		public function GatewayPacket(code:int=0)
		{
			super(code, 0);
		}
	}
}