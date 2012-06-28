package jsion.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import jsion.Cache;
	import jsion.cryptor.ICryption;
	import jsion.events.JsionEvent;
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.CacheUtil;
	import jsion.utils.PathUtil;
	
	
	/**
	 * 获取到所需加载的总字节数后触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="totalBytes", type="jsion.events.JsionEvent")]
	
	/**
	 * 文件加载完成后触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="complete", type="jsion.events.JsionEvent")]
	/**
	 * 取消加载时触发，如果未在加载或加载完成则不触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="cancel", type="jsion.events.JsionEvent")]
	/**
	 * 文件加载失败时触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jsion.events.JsionEvent")]
	/**
	 * 文件加载进度变更时派发。
	 * @eventType flash.events.ProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * 加载器基类
	 * @author Jsion
	 * 
	 */	
	public class JsionLoader extends JsionEventDispatcher implements ILoader
	{
		/**
		 * 加载器初始化状态。
		 */		
		public static const INITIALIZE:int = 0;
		
		/**
		 * 加载器被 LoaderMgr 阻塞，等待加载状态。
		 */		
		public static const WAITING:int = 1;
		
		/**
		 * 加载器正在加载状态。
		 */		
		public static const LOADING:int = 2;
		
		/**
		 * 加载器加载出错状态。
		 */		
		public static const ERROR:int = 3;
		
		/**
		 * 加载器加载完成状态。
		 */		
		public static const COMPLETE:int = 4;
		
		/**
		 * 取消加载状态。
		 */		
		public static const CANCEL:int = 5;
		
		
		/** @private */
		protected var m_managed:Boolean;
		
		/** @private */
		protected var m_root:String;
		
		/** @private */
		protected var m_file:String;
		
		/** @private */
		protected var m_fullUrl:String;
		
		/** @private */
		protected var m_urlKey:String;
		
		/** @private */
		protected var m_request:URLRequest;
		
		/** @private */
		protected var m_urlVariables:URLVariables;
		
		/** @private */
		protected var m_tag:Object;
		
		/** @private */
		protected var m_status:int;
		
		/** @private */
		protected var m_errorMsg:String;
		
		/** @private */
		protected var m_callback:Function;
		
		/** @private */
		protected var m_totalBytesCallback:Function;
		
		/** @private */
		protected var m_cryptor:ICryption;
		
		
		
		/** @private */
		protected var m_maxTryTimes:int = 3;
		
		/** @private */
		protected var m_tryTimes:int = 0;
		
		
		
		/** @private */
		protected var m_data:Object;
		
		
		
		/** @private */
		protected var m_cache:Boolean;
		
		/** @private */
		protected var m_cacheInMemory:Boolean;
		
		
		/** @private */
		protected var m_loadFromCache:Boolean;
		
		
		/** @private */
		protected var m_loadedBytes:int;
		
		/** @private */
		protected var m_totalBytes:int;
		
		
		public function JsionLoader(file:String, root:String = "", managed:Boolean = true)
		{
			m_managed = managed;
			
			m_file = file;
			m_root = root;
			
			m_urlKey = CacheUtil.path2Key(m_file);
			m_fullUrl = PathUtil.combinPath(m_root, m_file);
			
			m_status = INITIALIZE;
			
			initialize();
		}
		
		/** @private */
		protected function initialize():void
		{
			m_request = new URLRequest(m_fullUrl);
			m_urlVariables = new URLVariables();
			
			m_data = null;
			
			setURLVariables("v", Cache.version);
		}
		
		/**
		 * 获取指定 Url 参数的值。
		 * @param key Url 参数名称
		 */		
		public function getURLVariables(key:String):Object
		{
			return m_urlVariables[key];
		}
		
		/**
		 * 设置 Url 指定的参数和值。
		 * @param key 参数名称
		 * @param value 参数值
		 * 
		 */		
		public function setURLVariables(key:String, value:Object):void
		{
			m_urlVariables[key] = value;
			m_request.data = m_urlVariables;
		}
		
		/**
		 * 设置加载完成后的回调函数
		 * @param callback 回调函数，其形式为 function callback(loader:ILoader, complete:Boolean):void { }。
		 * 
		 */		
		public function setLoadCallback(callback:Function):void
		{
			if(callback != null) m_callback = callback;
		}
		
		/**
		 * 设置获取总字节数后的回调函数
		 * @param callback 回调函数，其形式为 function callback(loader:ILoader, totalBytes:int):void { totalBytes 为0时表示获取失败! }。
		 * 
		 */		
		public function setLoadTotalBytesCallabck(callback:Function):void
		{
			if(callback != null) m_totalBytesCallback = callback;
		}
		
		/**
		 * 开始异步加载。
		 * @param callback 回调函数，其形式为 function callback(loader:ILoader, complete:Boolean):void { }。
		 * 
		 */		
		public function loadAsync(callback:Function = null):void
		{
			setLoadCallback(callback);
			
			if(m_status == ERROR)
			{
				onLoadErrored();
				
				return;
			}
			
			if(m_status == COMPLETE)
			{
				if(m_loadFromCache)
				{
					onLoadCacheComplete();
				}
				else
				{
					onLoadCompleted();
				}
				
				return;
			}
			
			if(m_status == LOADING) return;
			
			if(m_managed == false || LoaderMgr.canLoad(this))
			{
				m_status = LOADING;
				
				if(Cache.contains(m_urlKey))
				{
					m_loadFromCache = true;
					
					loadCache();
				}
				else
				{
					m_loadFromCache = false;
					
					load();
				}
			}
			else
			{
				m_status = WAITING;
				
				LoaderMgr.putLoader(this);
			}
		}
		
		/**
		 * 加载总字节数
		 * @param callback 回调函数，其形式为 function callback(loader:ILoader, totalBytes:int):void { totalBytes 为0时表示获取失败! }。
		 */		
		public function loadTotalBytes(callback:Function = null):void
		{
			setLoadTotalBytesCallabck(callback);
			
			if(m_totalBytes > 0) onLoadTotalBytesComplete();
		}
		
		/**
		 * 取消加载，如果当前状态不是正在加载时不进行任何操作。
		 */		
		public function cancel():void
		{
			if(m_status == LOADING)
			{
				m_status = CANCEL;
				
				LoaderMgr.removeLoader(this);
				
				dispatchEvent(new JsionEvent(JsionEvent.CANCEL));
			}
		}
		
		/**
		 * 子类网络加载实现方法
		 * @private
		 */		
		protected function load():void
		{
		}
		/**
		 * 子类缓存加载实现方法
		 * @private
		 */		
		protected function loadCache():void
		{
		}
		
		/**
		 * 监听网络加载时需要的监听事件
		 */		
		protected function listenLoadEvent(dispatcher:EventDispatcher):void
		{
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				__ioErrorHandler, 		false, int.MAX_VALUE, false);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__securityErrorHandler, false, int.MAX_VALUE, false);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			__progressHandler, 		false, int.MAX_VALUE, false);
			dispatcher.addEventListener(Event.COMPLETE, 					__completeHandler, 		false, int.MAX_VALUE, false);
		}
		
		/**
		 * 移除网络加载时需要的监听事件
		 */		
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
			m_loadedBytes = e.bytesLoaded;
			m_totalBytes = e.bytesTotal;
			dispatchEvent(e.clone());
		}
		
		private function __completeHandler(e:Event):void
		{
			onLoadCompleted();
			
			removeLoadEvent(e.currentTarget as EventDispatcher);
		}
		
		private function tryLoad(errMsg:String):Boolean
		{
			if(m_tryTimes < m_maxTryTimes)
			{
				m_tryTimes++;
				
				if(m_loadFromCache)
				{
					loadCache();
				}
				else
				{
					load();
				}
				
				return true;
			}
			else
			{
				m_errorMsg = errMsg;
				
				onLoadErrored();
				
				return false;
			}
		}
		
		
		
		
		/**
		 * 监听获取总字节数时所需要的监听事件。
		 */		
		protected function listenLoadTotalBytesEvent(dispatcher:EventDispatcher):void
		{
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, 				__totalBytesIOErrorHandler, 		false, int.MAX_VALUE, false);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__totalBytesSecurityErrorHandler, 	false, int.MAX_VALUE, false);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, 			__totalBytesProgressHandler, 		false, int.MAX_VALUE, false);
		}
		
		/**
		 * 移除获取总字节数时所需要的监听事件。
		 */		
		protected function removeLoadTotalBytesEvent(dispatcher:EventDispatcher):void
		{
			if(dispatcher == null) return;
			
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, 				__totalBytesIOErrorHandler, 		false);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__totalBytesSecurityErrorHandler, 	false);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, 				__totalBytesProgressHandler, 		false);
		}
		
		private function __totalBytesIOErrorHandler(e:IOErrorEvent):void
		{
			if(tryLoadTotalBytes(e.text)) return;
			
			m_tryTimes = 0;
			
			removeLoadTotalBytesEvent(e.currentTarget as EventDispatcher);
		}
		
		private function __totalBytesSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			if(tryLoadTotalBytes(e.text)) return;
			
			m_tryTimes = 0;
			
			removeLoadTotalBytesEvent(e.currentTarget as EventDispatcher);
		}
		
		private function __totalBytesProgressHandler(e:ProgressEvent):void
		{
			m_tryTimes = 0;
			
			m_totalBytes = e.bytesTotal;
			
			removeLoadTotalBytesEvent(e.currentTarget as EventDispatcher);
			
			onLoadTotalBytesComplete();
		}
		
		/**
		 * 获取到总字节数时被调用
		 */		
		protected function onLoadTotalBytesComplete():void
		{
			if(m_totalBytesCallback != null) m_totalBytesCallback(this, m_totalBytes);
			
			dispatchEvent(new JsionEvent(JsionEvent.TOTAL_BYTES));
		}
		
		private function tryLoadTotalBytes(errMsg:String):Boolean
		{
			if(m_tryTimes < m_maxTryTimes)
			{
				m_tryTimes++;
				
				loadTotalBytes();
				
				return true;
			}
			else
			{
				m_errorMsg = errMsg;
				
				if(m_totalBytesCallback != null) m_totalBytesCallback(this, m_totalBytes);
				
				return false;
			}
		}
		
		
		
		
		
		/**
		 * 解密字节流，当未设置 cryptor 解密器属性时则返回参数对象。
		 * @param bytes 加载的字节流
		 */		
		protected function decrypt(bytes:ByteArray):ByteArray
		{
			if(m_cryptor && bytes)
			{
				return m_cryptor.decry(bytes);
			}
			
			return bytes;
		}
		
		/**
		 * 网络加载完成时被调用
		 */		
		protected function onLoadCompleted():void
		{
			m_status = COMPLETE;
			
			if(m_callback != null) m_callback(this, true);
			
			fireCompleteEvent();
			
			LoaderMgr.removeLoader(this);
		}
		
		/**
		 * 缓存加载完成时被调用
		 */		
		protected function onLoadCacheComplete():void
		{
			m_status = COMPLETE;
			
			if(m_callback != null) m_callback(this, true);
			
			fireCompleteEvent();
			
			LoaderMgr.removeLoader(this);
		}
		
		/**
		 * 网络加载出错时被调用
		 */		
		protected function onLoadErrored():void
		{
			m_status = ERROR;
			
			if(m_callback != null) m_callback(this, false);
			
			fireErrorEvent();
			
			LoaderMgr.removeLoader(this);
		}
		
		private function fireCompleteEvent():void
		{
			dispatchEvent(new JsionEvent(JsionEvent.COMPLETE));
		}
		
		private function fireErrorEvent():void
		{
			dispatchEvent(new JsionEvent(JsionEvent.ERROR));
		}
		
		/**
		 * 释放资源
		 */		
		override public function dispose():void
		{
			LoaderMgr.removeLoader(this);
			
			m_request = null;
			
			m_callback = null;
			
			m_data = null;
			
			m_urlVariables = null;
			
			m_tag = null;
			
			super.dispose();
		}
		
		/**
		 * 网络加载根目录。
		 */		
		public function get rootPath():String
		{
			return m_root;
		}
		
		/**
		 * 网络加载资源文件。
		 */		
		public function get file():String
		{
			return m_file;
		}
		
		/**
		 * 资源文件 Key 标识。
		 */		
		public function get urlKey():String
		{
			return m_urlKey;
		}

		/**
		 * 加载到的数据，在加载完成时有效。
		 */		
		public function get data():Object
		{
			return m_data;
		}

		/**
		 * 额外保存的数据。
		 */		
		public function get tag():Object
		{
			return m_tag;
		}
		
		/** @private */
		public function set tag(value:Object):void
		{
			m_tag = value;
		}
		
		/**
		 * 加载失败时的错误信息。
		 */		
		public function get errorMsg():String
		{
			return m_errorMsg;
		}
		
		/**
		 * 加载器的当前状态。
		 */
		public function get status():int
		{
			return m_status;
		}

		/**
		 * 完整的资源路径，通过合并 root 和 file 两个路径获取。
		 */		
		public function get fullUrl():String
		{
			return m_fullUrl;
		}
		
		/**
		 * 指示在网络加载完成时是否缓存到本地缓存。
		 */		
		public function get cache():Boolean
		{
			return m_cache;
		}
		
		/** @private */
		public function set cache(value:Boolean):void
		{
			m_cache = value;
		}
		
		/**
		 * 指示在网络加载或缓存加载完成时是否缓存到内存。
		 */		
		public function get cacheInMemory():Boolean
		{
			return m_cacheInMemory;
		}
		
		/** @private */
		public function set cacheInMemory(value:Boolean):void
		{
			m_cacheInMemory = value;
		}

		/**
		 * 字节流解密器。
		 */		
		public function get cryptor():ICryption
		{
			return m_cryptor;
		}
		
		/** @private */
		public function set cryptor(value:ICryption):void
		{
			m_cryptor = value;
		}

		/**
		 * 要加载的总字节数
		 */		
		public function get totalBytes():int
		{
			return m_totalBytes;
		}

		/**
		 * 当前已加载的字节数
		 */		
		public function get loadedBytes():int
		{
			return m_loadedBytes;
		}


	}
}