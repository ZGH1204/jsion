package jsion.ddrop
{
	import jsion.List;

	internal class DDGroup extends List
	{
		private var _group:String;
		
		public function DDGroup(group:String)
		{
			super();
			_group = group;
		}
		
		/**
		 * 分组名称
		 */		
		public function get group():String
		{
			return _group;
		}
	}
}