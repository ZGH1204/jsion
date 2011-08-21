package
{
	import flash.utils.Dictionary;
	
	public class WeakMap
	{
		
		private var dic:Dictionary;
		
		public function WeakMap()
		{
			super();
			dic = new Dictionary(true);
		}
		
		public function put(key:*, value:*):void
		{
			var wd:Dictionary = new Dictionary(true);
			wd[value] = null;
			dic[key] = wd;
		}
		
		public function getValue(key:*):*
		{
			var wd:Dictionary = dic[key];
			if(wd)
			{
				for(var v:* in wd)
				{
					return v;
				}
			}
			
			dic[key] = null;
			delete dic[key];
			
			return undefined;
		}
		
		public function remove(key:*):*
		{
			var value:* = getValue(key);
			delete dic[key];
			return value;
		}
	}
}