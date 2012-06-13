package jsion.rpg
{
	public class StaticMethod
	{
		public static function t(...args):void
		{
			trace.apply(null, args);
		}
	}
}