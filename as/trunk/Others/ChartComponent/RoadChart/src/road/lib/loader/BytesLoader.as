package road.lib.loader
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class BytesLoader extends URLLoader
	{
		protected var _url:URLRequest;
		protected var _hadTryTime:int;
		protected var _tryTime:int;
		protected var _callBack:Function;
		
		public function BytesLoader(path:String)
		{
			super();
			dataFormat = URLLoaderDataFormat.BINARY;
			_url = new URLRequest(path);
			
			this.addEventListener(Event.COMPLETE,__completed);
			this.addEventListener(IOErrorEvent.IO_ERROR,__error);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,__error);
			
			_hadTryTime = 0;
		}
		
		private function __completed(event:Event):void
		{
			onCompleted();
		}
		
		private function __error(event:Event):void
		{
			try
			{
				if(_hadTryTime >= _tryTime)
				{
					onError(event);
				}
				else
				{
					load(_url);
				}
			}
			catch(e:Error)
			{
				trace(e.message);
				trace(e.getStackTrace());
			}
			
		}
		
		protected function onCompleted():void
		{
			if(_callBack != null)
			{
				_callBack(this);
			}
		}
		
		protected function onError(event:Event):void
		{
			
		}
		
		public function loadSync(func:Function = null,tryTime:int = 1):void
		{
			_tryTime  = tryTime;
			
			if(func != null)
			{
				_callBack = func;
			}
			
			load(_url);
		}
		
		override public function load(request:URLRequest):void
		{
			_hadTryTime++;
			try
			{
				super.load(request);
			}
			catch(e:Error)
			{
				__error(new ErrorEvent(ErrorEvent.ERROR,false,false,e.message));
			}
		}
		
	}
}