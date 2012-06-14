package jsion
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 数据缓存
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	internal class DataCache
	{
		private var _localFile:String;
		private var _index:IndexCache;
		
		private var _changed:Boolean;
		private var _changedList:Dictionary;
		
		public function DataCache(index:IndexCache, localFile:String = "entityData")
		{
			_index = index;
			_localFile = localFile;
			
			_changedList = new Dictionary();
		}
		
		/**
		 * 获取指定缓存数据
		 * @param key 要获取缓存数据的缓存键
		 * @return 缓存的数据
		 * 
		 */		
		public function loadCacheData(key:String):*
		{
			var so:SharedObject = SharedObject.getLocal(key);
			var data:* = so.data["data"];
			return data;
			
			//if(_index.cachable)
			//{
			//}
			//return null;
		}
		
		/**
		 * 保存缓存数据，未写入本地缓存，可稍后执行 flush() 方法写入。
		 * @param key 数据缓存键
		 * @param data 要保存的数据
		 * 
		 */		
		public function saveCacheData(key:String, data:*):void
		{
			try
			{
				var so:SharedObject;
				
				if(_changedList[key]) so = _changedList[key] as SharedObject;
				else so = SharedObject.getLocal(key);
				
				so.data["data"] = data;
				_changedList[key] = so;
				_changed = true;
				
				//if(_index.cachable)
				//{
					//return so.flush();
				//}
			}
			catch(e:Error)
			{
				//return "failed";
			}
			
			//return "failed";
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
				if(_index.cachable && _changed)
				{
					for each(var val:* in _changedList)
					{
						if(val is Function) continue;
						
						var so:SharedObject = val as SharedObject;
						state = so.flush();
						if(state == SharedObjectFlushStatus.PENDING) break;
					}
					
					if(state == SharedObjectFlushStatus.FLUSHED) _changed = false;
				}
			}
			catch(e:Error)
			{
				state = "failed";
			}
			
			return state;
		}
	}
}