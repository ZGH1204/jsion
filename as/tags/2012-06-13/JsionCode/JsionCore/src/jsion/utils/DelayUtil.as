package jsion.utils
{
	import flash.events.Event;

	/**
	 * 延迟执行 使用ENTER_FRAME事件
	 * @author Jsion
	 * 
	 */	
	public class DelayUtil
	{
		private static var list:Array = [];
		
		/**
		 * 延迟执行指定函数
		 * @param fn 要延迟执行的无参数函数
		 * @param delay 延迟帧数
		 * 
		 */		
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
		
		/**
		 * 移除延迟执行函数
		 * @param fn 要移除的函数
		 * 
		 */		
		public static function removeDelayApply(fn:Function):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var di:DelayInfo = list[i] as DelayInfo;
				if(di.fn == fn)
				{
					di.fn = null;
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

/**
 * 延迟信息
 * @author Jsion
 * 
 */
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