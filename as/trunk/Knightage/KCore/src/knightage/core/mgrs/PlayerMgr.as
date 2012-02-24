package knightage.core.mgrs
{
	import jsion.utils.InstanceUtil;

	public class PlayerMgr
	{
		
		
		public function PlayerMgr()
		{
		}
		
		public static function get Instance():PlayerMgr
		{
			return InstanceUtil.createSingletion(PlayerMgr) as PlayerMgr;
		}
	}
}