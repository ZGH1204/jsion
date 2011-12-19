package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class CompUtil
	{
		public function CompUtil()
		{
		}
		
		/**
		 * 指示ancestor容器中是否包含child显示对象
		 * @param ancestor 显示对象容器
		 * @param child 显示对象
		 * @return true表示包含,false反之.
		 */		
		public static function isAncestorDisplayObject(ancestor:DisplayObjectContainer, child:DisplayObject):Boolean
		{
			if(ancestor == null || child == null) return false;
			
			var pa:DisplayObjectContainer = child.parent;
			
			while(pa != null)
			{
				if(pa == ancestor)
				{
					return true;
				}
				
				pa = pa.parent;
			}
			
			return false;
		}
	}
}