package jsion.core.loader
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import jsion.core.events.JsionEventDispatcher;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.PathUtil;
	
	public class JsionLoader extends JsionEventDispatcher implements ILoader
	{
		public static const INITIALIZE:int = 0;
		
		public static const WAITING:int = 1;
		
		public static const LOADING:int = 2;
		
		public static const ERROR:int = 3;
		
		public static const COMPLETE:int = 4;
		
		
		
		protected var m_managed:Boolean;
		
		protected var m_root:String;
		
		protected var m_file:String;
		
		protected var m_fullUrl:String;
		
		protected var m_urlKey:String;
		
		protected var m_request:URLRequest;
		
		protected var m_urlVariables:URLVariables;
		
		protected var m_tag:Object;
		
		protected var m_status:int;
		
		protected var m_errorMsg:String;
		
		protected var m_callback:Function;
		
		
		
		protected var m_maxTryTimes:int = 3;
		
		protected var m_tryTimes:int = 0;
		
		
		
		protected var m_data:Object;
		
		
		
		public function JsionLoader(file:String, root:String = "", managed:Boolean = true)
		{
			m_managed = managed;
			
			m_file = file;
			m_root = root;
			
			m_urlKey = JUtil.path2Key(m_file);
			m_fullUrl = PathUtil.combinPath(m_root, m_file);
			
			m_status = INITIALIZE;
			
			initialize();
		}
		
		protected function initialize():void
		{
			m_request = new URLRequest(m_fullUrl);
			m_urlVariables = new URLVariables();
			
			m_data = null;
		}
		
		public function getURLVariables(key:String):Object
		{
			return m_urlVariables[key];
		}
		
		public function setURLVariables(key:String, value:Object):void
		{
			m_urlVariables[key] = value;
			m_request.data = m_urlVariables;
		}
		
		public function setLoadCallback(callback:Function):void
		{
			if(callback != null) m_callback = callback;
		}
		
		public function loadAsync(callback:Function = null):void
		{
			setLoadCallback(callback);
			
			if(m_status == ERROR)
			{
				onErrored();
				
				return;
			}
			
			if(m_status == COMPLETE)
			{
				onCompleted();
				
				return;
			}
			
			if(m_status == LOADING) return;
			
			if(m_managed == false || LoaderMgr.canLoad(this))
			{
				m_status = LOADING;
				
				load();
			}
			else
			{
				LoaderMgr.putLoader(this);
			}
		}
		
		public function cancel():void
		{
			if(m_status == LOADING)
			{
				LoaderMgr.removeLoader(this);
				DisposeUtil.free(this);
			}
		}
		
		protected function load():void
		{
			
		}
		
		protected function listenLoadEvent(dispatcher:EventDispatcher):void
		{
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				__ioErrorHandler, 		false, int.MAX_VALUE, false);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__securityErrorHandler, false, int.MAX_VALUE, false);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			__progressHandler, 		false, int.MAX_VALUE, false);
			dispatcher.addEventListener(Event.COMPLETE, 					__completeHandler, 		false, int.MAX_VALUE, false);
		}
		
		protected function removeLoadEvent(dispatcher:EventDispatcher):void
		{
			if(dispatcher == null) return;
			
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				__ioErrorHandler, 		false);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__securityErrorHandler, false);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, 				__progressHandler, 		false);
			dispatcher.removeEventListener(Event.COMPLETE, 						__completeHandler, 		false);
		}
		
		private function __ioErrorHandler(e:IOErrorEvent):void
		{
			if(tryLoad(e.text)) return;
			
			removeLoadEvent(e.currentTarget as EventDispatcher);
		}
		
		private function __securityErrorHandler(e:SecurityErrorEvent):void
		{
			if(tryLoad(e.text)) return;
			
			removeLoadEvent(e.currentTarget as EventDispatcher);
		}
		
		private function __progressHandler(e:ProgressEvent):void
		{
			dispatchEvent(e.clone());
		}
		
		private function __completeHandler(e:Event):void
		{
			m_status = COMPLETE;
			
			onCompleted();
			
			LoaderMgr.removeLoader(this);
			
			removeLoadEvent(e.currentTarget as EventDispatcher);
		}
		
		private function tryLoad(errMsg:String):Boolean
		{
			if(m_tryTimes < m_maxTryTimes)
			{
				m_tryTimes++;
				
				load();
				
				return true;
			}
			else
			{
				m_status = ERROR;
				
				m_errorMsg = errMsg;
				
				onErrored();
				
				LoaderMgr.removeLoader(this);
				
				return false;
			}
		}
		
		
		
		
		protected function onCompleted():void
		{
			if(m_callback != null) m_callback(this, true);
			
			fireCompleteEvent();
		}
		
		protected function onErrored():void
		{
			if(m_callback != null) m_callback(this, false);
			
			fireErrorEvent();
		}
		
		private function fireCompleteEvent():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function fireErrorEvent():void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, m_errorMsg));
		}
		
		override public function dispose():void
		{
			m_request = null;
			
			m_callback = null;
			
			m_data = null;
			
			m_urlVariables = null;
			
			m_tag = null;
			
			super.dispose();
		}
		
		public function get root():String
		{
			return m_root;
		}
		
		public function get file():String
		{
			return m_file;
		}
		
		public function get urlKey():String
		{
			return m_urlKey;
		}

		public function get data():Object
		{
			return m_data;
		}

		public function get tag():Object
		{
			return m_tag;
		}

		public function set tag(value:Object):void
		{
			m_tag = value;
		}
		
		public function get errorMsg():String
		{
			return m_errorMsg;
		}

		public function get status():int
		{
			return m_status;
		}

		public function get fullUrl():String
		{
			return m_fullUrl;
		}
	}
}