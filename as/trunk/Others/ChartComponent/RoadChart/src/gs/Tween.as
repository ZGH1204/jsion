package gs
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import gs.events.TweenEvent;
	
	public class Tween extends EventDispatcher
	{
		private var _timer:Timer = null;
		private var _obj:Object;
		private var _prop:String
		private var _func:Function;
		private var _start:Number;//位置
		private var _end:Number;//位置
		private var _duration:Number;//时间
		private var _time:Number = 0;
		private var _startTime:Number = 1;
		private var _change:Number = 10;
		private var _position:Number;
		
		public function Tween($obj:Object,prop:String,func:Function,start:Number,end:Number,duration:Number)
		{
			this._obj = $obj;
			this._prop = prop;
			this._func = func;
			this._start = start;
			this._end = end;
			this._position = end;
			this._duration = duration;
			
			this._change = end - start;
			
			_timer = new Timer(45);
		}
		
		public function start(delay:Number = NaN):void
		{
			if(isNaN(delay) == false)
			{
				_timer.delay = delay;
			}
			fixTime();
			this._time = -0.1
			_timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			_timer.start();
		}
		
		public function set time(value:Number) : void
		{
			if(value > this._duration)
			{
				this._time = this._duration;
                this.update();
                
                this.stop();
                this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_FINISH, this._time, this._position));
			}
			else if(value < 0)
			{
				this.rewind();
				this.update();
			}
			else
			{
				this._time = value;
				this.update();
			}
		}
		
		public function setProp(value:Number):void
		{
			if(this._prop.length)
			{
				this._position = value;
				this._obj[this._prop] = value;
			}
			this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_CHANGE, this._time, this._position));
		}
		
		public function getNextProp(val:Number):Number
		{
			return this._func(val, this._start, this._change, this._duration);
		}
		
		protected function timerHandler(e:TimerEvent) : void
		{
			this.time = this._time + 0.1;//(getTimer() - this._startTime) / 1000;
			e.updateAfterEvent();
		}
		
		private function update():void
		{
			this.setProp(this.getNextProp(this._time));
		}
		
		private function rewind(val:Number = 0):void
		{
			this._time = val;
			this.fixTime();
			this.update();
		}
		
		private function fixTime() : void
        {
            this._startTime = getTimer() - this._time * 1000;
        }
        
        public function stop():void
        {
        	this._timer.stop();
        	this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_STOP, this._time, this._position));
        }
        
        public function dispose():void
        {
        	if(this._timer)
        	{
	        	this._timer.stop();
	        	_timer.removeEventListener(TimerEvent.TIMER, timerHandler, false);
        	}
        	_timer = null;
        	
        	this._obj = null;
        	this._func = null;
        }
	}
}