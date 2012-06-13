package jsion.core.partial
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.IDispose;
	import jsion.utils.JUtil;

	/**
	 * 分步解析Xml
	 * @author Jsion
	 * 
	 */	
	public class ParseXmlPartial implements IDispose
	{
		/** @private */
		protected var _step:int;
		/** @private */
		protected var _count:int;
		/** @private */
		protected var _xl:XMLList;
		/** @private */
		protected var _parseFn:Function, _callback:Function;
		
		private var _parsing:Boolean = false;
		
		private var parsed:int = 0;
		
		/**
		 * 开始分步解析Xml信息
		 * @param xl XMLList对象
		 * @param parseFn 以一个XML对象为参数的解析函数
		 * @param callback 解析完成后的回调函数
		 * @param step 每次解析的个数
		 */		
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
		
		/**
		 * 指示是否正在解析
		 */		
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