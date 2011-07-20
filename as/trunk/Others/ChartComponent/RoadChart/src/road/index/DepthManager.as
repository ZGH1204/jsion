package road.index
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DepthManager
	{
		public function DepthManager()
		{
		}
		
		
		public static function isBottom(display:DisplayObject) : Boolean
        {
            var container:DisplayObjectContainer = display.parent;
            if (container == null)
            {
                return true;
            }
            return container.getChildIndex(display) == 0;
        }// end function

        public static function isJustAbove(param1:DisplayObject, param2:DisplayObject) : Boolean
        {
            return isJustBelow(param2, param1);
        }// end function

        public static function bringToBottom(display:DisplayObject) : void
        {
            var container:DisplayObjectContainer = display.parent;
            if (container == null)
            {
                return;
            }
            if (container.getChildIndex(display) != 0)
            {
                container.setChildIndex(display, 0);
            }
            return;
        }// end function

        public static function isJustBelow(dis1:DisplayObject, dis2:DisplayObject) : Boolean
        {
            var container:DisplayObjectContainer = dis1.parent;
            if (container == null)
            {
                return false;
            }
            if (dis2.parent != container)
            {
                return false;
            }
            return container.getChildIndex(dis1) == container.getChildIndex(dis2)-1;
        }// end function

        public static function isTop(dis:DisplayObject) : Boolean
        {
            var container:DisplayObjectContainer = dis.parent;
            if (container == null)
            {
                return true;
            }
            return container.numChildren-1 == container.getChildIndex(dis);
        }// end function

        public static function bringToTop(dis:DisplayObject) : void
        {
            var container:DisplayObjectContainer = dis.parent;
            if (container == null)
            {
                return;
            }
            if (container.getChildIndex(dis) != container.numChildren-1)
            {
                container.setChildIndex(dis, container.numChildren-1);
            }
            return;
        }// end function
	}
}