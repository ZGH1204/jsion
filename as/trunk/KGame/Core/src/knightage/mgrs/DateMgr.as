package knightage.mgrs
{
	import flash.utils.getTimer;

	public class DateMgr
	{
		private static var m_time:*;
		
		public function DateMgr()
		{
		}
		
		public static function setup(date:Date):void
		{
			if(m_time != null || date == null)  return;
			
			m_time = date.time - getTimer();
		}
		
		public static function getCurrentDateTime():Date
		{
			return new Date(m_time + getTimer());
		}
	}
}