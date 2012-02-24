package knightage.core.mgrs
{
	import jsion.utils.InstanceUtil;

	public class LoginMgr
	{
		public var account:String;
		
		public var logined:Boolean;
		
		public function LoginMgr()
		{
		}
		
		public static function get Instance():LoginMgr
		{
			return InstanceUtil.createSingletion(LoginMgr) as LoginMgr;
		}
	}
}