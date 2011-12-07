package jsion
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 缓存类，使用前确保已执行过Cache.setup()安装方法。<br /><br />
	 * 
	 * 缓存配置文件格式如下：<br/>
	 * 	　&lt;root&gt;<br/>
	 * 	　　&lt;version from="0" to="1"&gt;<br/>
	 * 	　　　&lt;file value="*" /&gt;<br/>
	 * 	　　　&lt;file value="asset/*.png" /&gt;<br/>
	 * 	　　&lt;/version&gt;<br/>
	 *	　&lt;/root&gt;<br/><br/>
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class Cache
	{
		/**
		 * 初始缓存大小
		 */		
		public static const CacheSize:int = 50 * 1024 * 1024;
		
		private static var indexs:IndexCache = new IndexCache();
		
		private static var datas:DataCache = new DataCache(indexs);
		
		private static var cacheMemory:Dictionary = new Dictionary();
		
		private static var changes:Dictionary = new Dictionary();
		
		private static var _isSetup:Boolean = false, _changed:Boolean = false;
		
		/**
		 * <p>安装缓存，仅第一次执行有效。</p>
		 * 配置格式如下：<br />
		 * 	　&lt;root&gt;<br/>
		 * 	　　&lt;version from="0" to="1"&gt;<br/>
		 * 	　　　&lt;file value="*" /&gt;<br/>
		 * 	　　　&lt;file value="asset/*.png" /&gt;<br/>
		 * 	　　&lt;/version&gt;<br/>
		 *	　&lt;/root&gt;
		 * @param config 包含上述配置格式的XML对象
		 * 
		 * 
		 */		
		public static function setup(config:XML):void
		{
			if(_isSetup == false)
			{
				indexs.loadLocalCache();
				_isSetup = true;
				
				parseConfig(config);
			}
		}
		
		/**
		 * 缓存版本
		 * @return 缓存版本号 
		 * 
		 */		
		public static function get version():int
		{
			return indexs.version;
		}
		
		/**
		 * 记录缓存数据到保存列表，未写入本地缓存文件，可执行 save() 方法写入。
		 * @param key 缓存键
		 * @param data 要缓存的数据
		 * @param cacheInMemory 是否缓存到内存
		 * 
		 */		
		public static function cacheData(key:String, data:*, cacheMemory:Boolean = true):void
		{
			if(indexs.cachable && _isSetup)
			{
				key = JUtil.path2Key(key);
				changes[key] = data;
				_changed = true;
			}
			
			if(cacheMemory) cacheInMemory(key, data);
		}
		
		/**
		 * 加载缓存项
		 * @param key 缓存键
		 * @param cacheInMemory 是否缓存到内存
		 * @return 缓存数据
		 * 
		 */		
		public static function loadData(key:String, cacheInMemory:Boolean = true):*
		{
			key = JUtil.path2Key(key);
			
			var data:* = null;
			
			data = cacheMemory[key];
			if(data) return data;
			
			if(_isSetup == false) return null;
			
			data = changes[key];
			if(data) return data;
			
			if(indexs.hasIndex(key))
				data = datas.loadCacheData(key);
			
			if(cacheInMemory && data)
				cacheMemory[key] = data;
			
			return data;
		}
		
		/**
		 * 保存到本地缓存。
		 */		
		public static function save():void
		{
			if(indexs.cachable && _changed && _isSetup)
			{
				try
				{
					if(indexs.refreshCachable() == false) return;
				}
				catch(e:Error)
				{
					return;
				}
				
				var keys:Array = DictionaryUtil.getKeys(changes);
				for each(var key:String in keys)
				{
					indexs.saveIndex(key);
					datas.saveCacheData(key, changes[key]);
				}
				
				indexs.flush();
				datas.flush();
				
				_changed = false;
				
				changes = new Dictionary();
			}
		}
		
		/**
		 * 删除缓存的数据，未写入本地缓存文件，可执行 save() 方法写入。
		 * @param key 缓存键
		 */		
		public static function delCacheData(key:String):void
		{
			key = JUtil.path2Key(key);
			delete changes[key];
			delete cacheMemory[key];
			indexs.clearIndex(key);
		}
		
		/**
		 * 加载内存中的缓存项
		 * @param key 缓存键
		 * @return 缓存项
		 */		
		public static function loadInMemory(key:String):*
		{
			if(StringUtil.isNullOrEmpty(key)) return null;
			key = JUtil.path2Key(key);
			return cacheMemory[key];
		}
		
		/**
		 * 仅缓存到内存中
		 * @param key 缓存键
		 * @param data 要缓存的数据
		 * 
		 */		
		public static function cacheInMemory(key:String, data:*):void
		{
			if(StringUtil.isNullOrEmpty(key)) return;
			key = JUtil.path2Key(key);
			cacheMemory[key] = data;
		}
		
		/**
		 * 删除指定缓存键的内存缓存，如果key参数为null或Constant.Empty则将删除所有内存缓存项。
		 * @param key 缓存键
		 * 
		 */		
		public static function delMemoryCache(key:String = null):void
		{
			if(StringUtil.isNullOrEmpty(key))
			{
				var keys:Array = DictionaryUtil.getKeys(cacheMemory);
				
				for each(var k:* in keys)
				{
					delete cacheMemory[k];
				}
			}
			else
			{
				key = JUtil.path2Key(key);
				delete cacheMemory[key];
			}
		}
		
		/**
		 * 是否开启缓存并且有缓存数据需要写入本地缓存文件
		 * @return 是否有缓存可以写入
		 * 
		 */		
		public static function get hasCacheToSave():Boolean
		{
			return indexs.cachable && _changed;
		}
		
		/**
		 * 更新缓存配置，配置格式如下：<br />
		 * 	　&lt;root&gt;<br/>
		 * 	　　&lt;version from="0" to="1"&gt;<br/>
		 * 	　　　&lt;file value="*" /&gt;<br/>
		 * 	　　　&lt;file value="asset/*.png" /&gt;<br/>
		 * 	　　&lt;/version&gt;<br/>
		 *	　&lt;/root&gt;
		 * @param config 包含上述配置格式的XML对象
		 */		
		public static function parseConfig(config:XML):void
		{
			var xl:XMLList = config..version;
			var fv:int = -1, tv:int = 0, cx:XML;
			
			for each(var xml:XML in xl)
			{
				if(tv < int(xml.@to))
				{
					fv = int(xml.@from);
					tv = int(xml.@to);
					cx = xml;
				}
			}
			
			xl = cx..file;
			var regList:Array = [];
			
			for each(var x:XML in xl)
			{
				var str:String = String(x.@value);
				//str = StringUtil.replace(str, ".", "_");
				str = JUtil.path2Key(str);
				str = StringUtil.replace(str, "*","\\w*");
				regList.push(new RegExp(str + "$"));
			}
			
			if(tv <= fv) return;
			
			if(indexs.version >= tv) return;
			
			if(indexs.version < fv)
			{
				indexs.version = tv;
				indexs.clearAll();
			}
			else
			{
				var rlt:Array = [];
				var fileList:Array = indexs.getIndexs();
				for each(var reg:RegExp in regList)
				{
					for each(var file:String in fileList)
					{
						if(file.match(reg)) rlt.push(file);
					}
				}
				
				indexs.version = tv;
				indexs.clearIndexs(rlt);
			}
			
			_changed = true;
		}
	}
}