package jcore.org.partial
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class ParseXmlPartial implements IDispose
	{
		protected var _step:int;
		protected var _count:int;
		protected var _xl:XMLList;
		protected var _parseFn:Function, _callback:Function;
		
		private var _parsing:Boolean = false;
		
		private var parsed:int = 0;
		
		
		public function start(xl:XMLList, parseFn:Function, callback:Function = null, step:int = 100):void
		{
			_xl = xl;
			_count = _xl.length();
			_step = step;
			_parseFn = parseFn;
			_callback = callback;
			
			_parsing = true;
			
			JUtil.addEnterFrame(__enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			for(; parsed < _count; parsed++)
			{
				var xml:XML = _xl[parsed];
				_parseFn(xml);
				if((parsed % _step) == 0 && parsed != 0)
				{
					parsed++;
					break;
				}
			}
			
			if(parsed >= _count)
			{
				_parsing = false;
				
				JUtil.removeEnterFrame(__enterFrameHandler);
				
				if(_callback != null) _callback();
			}
		}
		
		public function get isParsing():Boolean
		{
			return _parsing;
		}
		
		
		public function dispose():void
		{
			JUtil.removeEnterFrame(__enterFrameHandler);
			
			_xl = null;
			_parseFn = null;
			_callback = null;
		}
	}
}