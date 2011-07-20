package
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * 索引缓存
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	internal class IndexCache
	{
		private var _localName:String;
		
		private var _localCache:SharedObject;
		
		private var _indexData:Object;
		
		private var _cachable:Boolean = true;
		
		private var _changed:Boolean;
		
		private var _version:int;
		
		public function IndexCache(localName:String = "indexData")
		{
			_localName = localName;
		}
		
		/**
		 * 本地缓存名称
		 * @return 缓存名称
		 * 
		 */		
		public function get localName():String
		{
			return _localName;
		}
		
		/**
		 * 本地 SharedObject 对象
		 * @return 本地 SharedObject 缓存对象
		 * 
		 */		
		public function get localCache():SharedObject
		{
			return _localCache;
		}
		
		/**
		 * 是否允许本地缓存。
		 * @return 
		 * 
		 */		
		public function get cachable():Boolean
		{
			return _cachable;
		}
		/**
		 * 是否允许本地缓存。
		 * @param value true为允许，false为不允许。
		 * 
		 */		
		public function set cachable(value:Boolean):void
		{
			_cachable = value;
		}
		
		/**
		 * 版本号
		 * @return 
		 * 
		 */		
		public function get version():int
		{
			return _version;
		}
		
		public function set version(value:int):void
		{
			_version = value;
			_indexData["version"] = _version;
		}
		
		/**
		 * 刷新本地缓存状态，指示用户是否开启本地缓存。
		 * @return 
		 * 
		 */		
		public function refreshCachable():Boolean
		{
			try
			{
				if(_localCache && _cachable)
				{
					if(_localCache.flush(Cache.CacheSize) == SharedObjectFlushStatus.PENDING)
					{
						_cachable = false;
						return false;
					}
					return true;
				}
				
				_cachable = false;
				return false;
			}
			catch(e:Error) { }
			
			_cachable = false;
			return false;
		}
		
		/**
		 * 加载本地缓存索引。
		 * 
		 */		
		public function loadLocalCache():void
		{
			_localCache = SharedObject.getLocal(_localName);
			_localCache.addEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
			
			_indexData = _localCache.data["index"];
			
			try
			{
				if(_indexData == null)
				{
					_indexData = {};
					_version = 0;
					_indexData["version"] = _version;
					_localCache.data["index"] = _indexData;
					_localCache.flush(Cache.CacheSize);
				}
				
				_version = int(_indexData["version"]);
			}
			catch(err:Error)
			{
				_localCache.removeEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
				_cachable = false;
			}
		}
		
		/**
		 * 判断是否存在指定缓存对象
		 * @param key 缓存键
		 * @return 
		 * 
		 */		
		public function hasIndex(key:String):Boolean
		{
			if(_indexData[key]) return true;
			
			return false;
		}
		
		/**
		 * 获取所有索引键
		 * @return 索引键列表
		 * 
		 */		
		public function getIndexs():Array
		{
			var list:Array = [];
			
			for(var key:* in _indexData)
			{
				if(key != "version") list.push(key);
			}
			
			return list;
		}
		
		/**
		 * 保存指定缓存索引，未写入本地缓存，可稍后执行 flush() 方法写入。
		 * @param key
		 * 
		 */		
		public function saveIndex(key:String):void
		{
			_indexData[key] = true;
			_changed = true;
			//if(_cachable)
			//{
				//return flush();
			//}
			
			//return "failed";
		}
		
		/**
		 * 清除指定缓存索引，未写入本地缓存，可稍后执行 flush() 方法写入。
		 * @param key 索引键
		 */		
		public function clearIndex(key:String):void
		{
			delete _indexData[key];
			_changed = true;
			//if(_cachable)
			//{
				//return flush();
			//}
			
			//return "failed";
		}
		
		/**
		 * 清除指定缓存索引，未写入本地缓存，可稍后执行 flush() 方法写入。
		 * @param list 索引键列表
		 * 
		 */		
		public function clearIndexs(list:Array):void
		{
			for each(var key:String in list)
			{
				delete _indexData[key];
				_changed = true;
			}
			
			//return flush();
		}
		
		/**
		 * 清除所有缓存索引，未写入本地缓存，可稍后执行 flush() 方法写入。
		 * 
		 */		
		public function clearAll():void
		{
			for(var key:* in _indexData)
			{
				delete _indexData[key];
				_changed = true;
			}
			//return flush();
		}
		
		/**
		 * 保存到本地缓存文件
		 * @return 失败返回"failed"，其他返回结果为SharedObjectFlushStatus类的常量。
		 * 
		 */		
		public function flush():String
		{
			var state:String = "failed";
			try
			{
				if(_cachable && _changed)
				{
					state = _localCache.flush();
					if(state == SharedObjectFlushStatus.FLUSHED)
						_changed = false;
				}
			}
			catch(e:Error)
			{
				state = "failed";
				_cachable = false;
			}
			return state;
		}
		
		private function __netStatusHandler(e:NetStatusEvent):void
		{
			/*
			"SharedObject.Flush.Success"	"status"	“待定”状态已解析并且 SharedObject.flush() 调用成功。 
			"SharedObject.Flush.Failed"		"error"		“待定”状态已解析，但 SharedObject.flush() 失败。 
			"SharedObject.BadPersistence"	"error"		使用永久性标志对共享对象进行了请求，但请求无法被批准，因为已经使用其它标记创建了该对象。 
			"SharedObject.UriMismatch"		"error"		试图连接到拥有与共享对象不同的 URI (URL) 的 NetConnection 对象。 
			*/
			switch (e.info.code)
			{
				case "SharedObject.Flush.Failed":
				{
					_localCache.removeEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
					_cachable = false;
					break;
				}
				case "SharedObject.Flush.Success":
				{
					_cachable = true;
					break;
				}
			}
		}
	}
}