package jsion.utils
{
	import flash.events.Event;

	public class DelayUtil
	{
		private static var list:Array = [];
		
		public static function setDelayApply(fn:Function, delay:int = 5):void
		{
			if(fn == null) return;
			
			if(list.length == 0)
			{
				JUtil.addEnterFrame(__enterFrameHandler);
			}
			
			var obj:DelayInfo = new DelayInfo();
			
			obj.fn = fn;
			obj.delay = delay;
			obj.cur = 0;
			
			list.push(obj);
		}
		
		public static function removeDelayApply(fn:Function):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var di:DelayInfo = list[i] as DelayInfo;
				if(di.fn == fn)
				{
					ArrayUtil.remove(list, di);
					i--;
				}
			}
		}
		
		private static function __enterFrameHandler(e:Event):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var obj:DelayInfo = list[i] as DelayInfo;
				
				obj.cur++;
				
				if(obj.cur > obj.delay)
				{
					if(obj.fn != null) obj.fn.apply();
					ArrayUtil.removeAt(list, i);
					DisposeUtil.free(obj);
					i--;
					continue;
				}
			}
			
			if(list.length == 0) JUtil.removeEnterFrame(__enterFrameHandler);
		}
	}
}
import jsion.IDispose;

class DelayInfo implements IDispose
{
	public var fn:Function;
	
	public var delay:int;
	
	public var cur:int;
	
	public function dispose():void
	{
		fn = null;
	}
}