package jsion.core.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import jsion.core.events.JLoaderEvent;
	import jsion.core.events.JLoaderProgressEvent;
	import jsion.core.reflection.Assembly;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.ObjectUtil;
	import jsion.utils.StringUtil;

	/**
	 * 获取完所有资源所需资源总字节数时派发
	 */	
	[Event(name="bytesTotal", type="jsion.core.events.JLoaderEvent")]
	
	/**
	 * 开始批量加载时派发
	 * @eventType jsion.core.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="open", type="jsion.core.events.JLoaderEvent")]
	
	/**
	 * 所有加载完成时派发
	 * @eventType jsion.core.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="complete", type="jsion.core.events.JLoaderEvent")]
	
	/**
	 * 所有加载完成并且存在加载失败时派发
	 * @eventType jsion.core.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jsion.core.events.JLoaderEvent")]
	
	/**
	 * 加载进度变更时派发
	 * @eventType jsion.core.events.JLoaderProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="jsion.core.events.JLoaderProgressEvent")]
	
	/**
	 * 批量加载器，defaultCfg参数配置项参见JLoader类
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class JLoaders extends EventDispatcher implements ILoaders, IDispose
	{
		/**
		 * 所有资源加载器JSON配置的公共默认配置
		 */		
		protected static var DEFAULT_CFG:Object = {managed: false};
		
		protected var _name:String;
		
		protected var _maxLoadings:int;
		
		protected var _numLoadings:int;	
		
		protected var _defaultCfg:Object;
		
		protected var _isStarted:Boolean;
		
		protected var _allLoadersDic:Dictionary;
		
		protected var _waitList:Array;
		
		protected var _loadingList:Array;
		
		protected var _completeListDic:Dictionary;
		
		protected var _errorListDic:Dictionary;
		
		protected var _bytesLoaded:int;
		
		protected var _bytesTotal:int;
		
		protected var _completeBytesTotal:int = 0;
		
		
		/**
		 * 指加载完成时的回调函数，以 this 参数进行调用。
		 */		
		protected var _callback:Function;
		
		/**
		 * 批量获取待加载资源总字节数的封装类
		 * @private
		 */		
		protected var _readyHandler:ReadyJLoader;
		
		
		protected var _listTemp:Array = [];
		
		
		protected var _hasError:Boolean = false;
		
		
		
		/**
		 * 构造函数
		 * @param name 指加载器名称
		 * @param maxLoadings 最大同时加载数LoaderGlobal.DefaultMaxLoadings
		 * @param defaultCfg 单个资源加载器的默认配置，配置项参见 add 方法。
		 * @see jcore.org.loader.JLoaders.add()
		 * 
		 */		
		public function JLoaders(name:String, maxLoadings:int = 8, defaultCfg:Object = null)
		{
			_name = name;
			
			if(maxLoadings > 0) _maxLoadings = maxLoadings;
			
			_defaultCfg = {};
			ObjectUtil.copyDynamicToTarget2(DEFAULT_CFG, _defaultCfg);
			ObjectUtil.copyDynamicToTarget2(defaultCfg, _defaultCfg);
			
			_allLoadersDic = new Dictionary();
			_waitList = [];
			_loadingList = [];
			_completeListDic = new Dictionary();
			_errorListDic = new Dictionary();
		}

		/**
		 * 加载器名称
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * 当前最大同时加载数
		 */
		public function get maxLoadings():int
		{
			return _maxLoadings;
		}

		/**
		 * 当前正在加载数
		 */
		public function get numLoadings():int
		{
			return _numLoadings;
		}
		
		/**
		 * 是否有资源加载失败。
		 */		
		public function get hasError():Boolean
		{
			return _hasError;
		}

		/**
		 * 当前批量加载器默认配置
		 */
		public function get defaultCfg():Object
		{
			return _defaultCfg;
		}

		/**
		 * 指示是否已经开始加载
		 */
		public function get isStarted():Boolean
		{
			return _isStarted;
		}

		/**
		 * 所有资源的加载器列表
		 */
		public function get allLoadersDic():Dictionary
		{
			return _allLoadersDic;
		}

		/**
		 * 指示等待加载列表
		 */
		public function get waitList():Array
		{
			return _waitList;
		}

		/**
		 * 正在加载列表
		 */
		public function get loadingList():Array
		{
			return _loadingList;
		}

		/**
		 * 加载完成列表
		 */
		public function get completeListDic():Dictionary
		{
			return _completeListDic;
		}

		/**
		 * 加载失败列表
		 */
		public function get errorListDic():Dictionary
		{
			return _errorListDic;
		}

		/**
		 * 已加载总字节数
		 */
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}
		
		/**
		 * 已完成加载的总字节数
		 * @private
		 */
		public function get completeBytesTotal():int
		{
			return _completeBytesTotal;
		}

		/**
		 * 所需加载的总字节数，加载时有效。
		 */		
		public function get bytesTotal():int
		{
			return _bytesTotal;
		}
		
		/**
		 * <p>加入等待加载列表</p>
		 * @param url 资源地址
		 * @param cfg JSON配置，配置项如下：<br /><br />
		 * 
		 * 	<table>
	     *		<th>Property name</th>
	     *		<th>Class constant</th>
	     *		<th>Data type</th>
	     *		<th>Description</th>
		 * 		<tr>
		 * 			<td>type</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderGloba</a></td>
		 * 			<td><code>String</code></td>
		 * 			<td>强制资源类型</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>rnd</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Boolean</code></td>
		 * 			<td>是否忽略Http本身的缓存</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>root</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>String</code></td>
		 * 			<td>资源根路径</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>priority</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>int</code></td>
		 * 			<td>指示加载时的优先级，数值越大越优先。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>managed</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Boolean</code></td>
		 * 			<td>指示当前加载器是否使用LoaderMonitor进行管理，默认值 为true。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>cryptor</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>ICryption接口实现类</code></td>
		 * 			<td>解密器，如果资源事先经过加密则需传递此配置参数。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>headers</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>URLRequestHeader对象列表</code></td>
		 * 			<td>请求时用于Http标头的列表，URLRequestHeader对象列表。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>context</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>LoaderContext or SoundLoaderContext</code></td>
		 * 			<td>仅允许LoaderContext 或 SoundLoaderContext 类的对象，用于 swf 或 sound 的加载。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>bindData</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Object(dynamic)</code></td>
		 * 			<td>对uri进行格式化绑定的数据源</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>tryTimes</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>int</code></td>
		 * 			<td>加载失败时的可重试次数，默认为3。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>requestMethod</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>String</code></td>
		 * 			<td>用于URLRequest.method属性，其可能的值为 URLRequestMethod 类的常量值。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>urlVariables</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Object(dynamic)</code></td>
		 * 			<td>用于URLRequest.data属性，Http的请求参数。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>cacheInMemory</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Boolean</code></td>
		 * 			<td>指示是否缓存在内存，仅用于ImageLoader，LibLoader和SwcLoader。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>checkPolicyFile</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Boolean</code></td>
		 * 			<td>仅用于NetStream.play的播放参数。</td>
		 * 		</tr>
		 * 		<tr>
		 * 			<td>pausedAtStart</td>
		 * 			<td><a href="#">jcore.org.loader.LoaderJSON</a></td>
		 * 			<td><code>Boolean</code></td>
		 * 			<td>仅用于指示NetStream打开时是否暂停在开始播放前。</td>
		 * 		</tr>
		 * 	</table>
		 * 
		 * @throws Error 已经开始加载，无法继续添加。
		 * @throws Error 资源地址参数不能为空，无法添加。
		 * @throws Error url 扩展名无效，无法添加。
		 * @throws Error 指定的资源类型不存在
		 * @throws Error 资源对应的加载类不存在
		 */		
		public function add(url:String, cfg:Object = null):ILoader
		{
			if(_isStarted)
			{
				throw new Error("已经开始加载，无法继续添加。");
				return null;
			}
			if(StringUtil.isNullOrEmpty(url))
			{
				throw new Error("资源地址参数不能为空，无法添加。");
				return null;
			}
			
			var ext:String = JUtil.getExtension(url);
			if(LoaderGlobal.AVAILABLE_EXTENSIONS.indexOf(ext) == -1)
			{
				throw new Error("url 扩展名无效，无法添加。");
				return null;
			}
			
			if(_listTemp.indexOf(url) != -1)
			{
				return getLoader(url);
			}
			
			//生成加载类配置
			var _cfg:Object;
			if(cfg == null)
			{
				_cfg = _defaultCfg;
			}
			else
			{
				_cfg = {};
				ObjectUtil.copyDynamicToTarget2(_defaultCfg, _cfg);
				ObjectUtil.copyDynamicToTarget2(cfg, _cfg);
			}
			
			//获取资源类型
			var type:String;
			if(_cfg["type"])
			{
				type = _cfg["type"];
				if(LoaderGlobal.AVAILABLE_TYPE.indexOf(type) == -1)
				{
					throw new Error("指定的资源类型不存在");
					return;
				}
			}
			else
			{
				type = LoaderGlobal.guessType(url);
				_cfg["type"] = type;
			}
			
			//查找对应加载类
			var loaderCls:Class = LoaderGlobal.TYPE_LOADER_CLASS[type];
			
			if(loaderCls == null)
			{
				throw new Error("资源对应的加载类不存在");
				return null;
			}
			
			_listTemp.push(url);
			
			//生成加载器对象
			var loader:ILoader = new loaderCls(url, _cfg);
			
			//保存加载器
			putInLoaderList(loader);
			putInWaitList(loader);
			
			return loader;
		}
		
		/**
		 * 加入等待加载列表
		 * @param loader
		 * 
		 */		
		public function addLoader(loader:ILoader):void
		{
			if(_isStarted)
			{
				throw new Error("已经开始加载，无法继续添加。");
				return;
			}
			
			if(loader == null) return;
			
			_listTemp.push(loader.url);
			
			putInLoaderList(loader);
			putInWaitList(loader);
		}
		
		/**
		 * 放入加载器列表
		 * @param loader 资源加载器
		 * 
		 */		
		private function putInLoaderList(loader:ILoader):void
		{
			_allLoadersDic[loader.urlKey] = loader;
		}
		
		/**
		 * 放入等待加载列表
		 * @param loader 资源加载器
		 * 
		 */		
		private function putInWaitList(loader:ILoader):void
		{
			_waitList.push(loader);
		}
		
		/**
		 * 从等待加载列表中移除
		 * @param loader 资源加载器
		 * 
		 */		
		private function removeOutWaitList(loader:ILoader):void
		{
			if(loader == null) return;
			ArrayUtil.remove(_waitList, loader);
		}
		
		/**
		 * 放入加载完成列表
		 * @param loader 资源加载器
		 * 
		 */		
		private function putInCompleteList(loader:ILoader):void
		{
			_completeListDic[loader.urlKey] = loader;
		}
		
		/**
		 * 放入加载失败列表
		 * @param loader 资源加载器
		 * 
		 */		
		private function putInErrorList(loader:ILoader):void
		{
			_errorListDic[loader.urlKey] = loader;
		}
		
		/**
		 * 放入正在加载列表
		 * @param loader 资源加载器
		 * 
		 */		
		private function putInLoadingList(loader:ILoader):void
		{
			if(loader == null) return;
			_numLoadings++;
			_loadingList.push(loader);
		}
		
		/**
		 * 从正在加载列表中移除
		 * @param loader 资源加载器
		 * 
		 */		
		private function removeOutLoadingList(loader:ILoader):void
		{
			if(loader == null) return;
			_numLoadings--;
			ArrayUtil.remove(_loadingList, loader);
		}
		
		/**
		 * 获取指定资源的Loader对象
		 * @param url  与传递给add方法的资源地址相同
		 * @return ILoader的实现对象
		 * 
		 */		
		public function getLoader(url:String):ILoader
		{
			return _allLoadersDic[JUtil.path2Key(url)] as ILoader;
		}
		
		/**
		 * 获取字节流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 节流对象
		 * 
		 */		
		public function getBinary(url:String):ByteArray
		{
			return getContent(url, LoaderGlobal.TYPE_BINARY) as ByteArray;
		}
		
		/**
		 * 获取文本字符串对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 字符串对象
		 * 
		 */		
		public function getText(url:String):String
		{
			return getContent(url, LoaderGlobal.TYPE_TEXT) as String;
		}
		
		/**
		 * 获取Xml对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return Xml对象
		 * 
		 */		
		public function getXml(url:String):XML
		{
			return getContent(url, LoaderGlobal.TYPE_XML) as XML;
		}
		
		/**
		 * 获取Bitmap图片
		 * @param url 与传递给add方法的资源地址相同
		 * @return Bitmap图片，无对应资源时返回null。
		 * 
		 */		
		public function getBitmap(url:String):Bitmap
		{
			return getContent(url, LoaderGlobal.TYPE_IMAGE) as Bitmap;
		}
		
		/**
		 * 获取图片的BitmapData数据
		 * @param url 与传递给add方法的资源地址相同
		 * @return 新的BitmapData数据对象
		 * 
		 */		
		public function getBitmapData(url:String):BitmapData
		{
			var bmp:Bitmap = getBitmap(url);
			if(bmp == null || bmp.bitmapData == null) return null;
			return bmp.bitmapData.clone();
		}
		
		/**
		 * 获取影片剪辑对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 影片剪辑对象
		 * 
		 */		
		public function getMovieClip(url:String):MovieClip
		{
			return getContent(url, LoaderGlobal.TYPE_IMAGE) as MovieClip;
		}
		
		/**
		 * 获取声音对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 声音对象
		 * 
		 */		
		public function getSound(url:String):Sound
		{
			return getContent(url, LoaderGlobal.TYPE_SOUND) as Sound
		}
		
		/**
		 * 获取视频流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 视频流对象
		 * 
		 */		
		public function getVideo(url:String):NetStream
		{
			return getContent(url, LoaderGlobal.TYPE_VIDEO) as NetStream;
		}
		
		/**
		 * 获取swf库的字节流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 库字节流对象
		 * 
		 */		
		public function getLib(url:String):ByteArray
		{
			return getContent(url, LoaderGlobal.TYPE_LIB) as ByteArray;
		}
		
		/**
		 * 获取Swc库的Assembly对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return Assembly对象
		 * 
		 */		
		public function getSwc(url:String):Assembly
		{
			return getContent(url, LoaderGlobal.TYPE_SWC) as Assembly;
		}
		
		/**
		 * 获取加载后得到的内容，如果t指定的资源类型与加载器的资源类型不符则返回null。
		 * @param url 与传递给add方法的资源地址相同
		 * @param t 资源类型
		 * @return 加载后所得到的内容
		 * 
		 */		
		protected function getContent(url:String, t:String):*
		{
			var loader:ILoader = getLoader(url);
			
			if(loader == null || loader.type != t) return null;
			
			return loader.content;
		}
		
		/**
		 * 开始批量加载
		 * 
		 */		
		public function start(callback:Function = null):ILoaders
		{
			if(callback != null) _callback = callback;
			
			if(_isStarted) return this;
			
			_isStarted = true;
			
			if(_loadingList.length == 0 && _waitList.length == 0)
			{
				JUtil.addEnterFrame(__tryCompleteHandler);
				return this;
			}
			
			ArrayUtil.sortDescByNum(_waitList, "priority");
			
			if(_readyHandler == null) _readyHandler = new ReadyJLoader(ArrayUtil.clone(_waitList), putInErrorList, _maxLoadings);
			
			_readyHandler.ready(readyCallback);
			
			return this;
		}
		
		private function __tryCompleteHandler(e:Event):void
		{
			JUtil.removeEnterFrame(__tryCompleteHandler);
			tryComplete();
		}
		
		/**
		 * 获取所有待加载资源总字节数完成的回调
		 * 
		 */		
		protected function readyCallback():void
		{
			var loader:ILoader;
			var list:Array = DictionaryUtil.getValues(_errorListDic);
			for each(loader in list)
			{
				removeOutWaitList(loader);
			}
			
			var bTotals:int = 0;;
			
			for each(loader in _waitList)
			{
				bTotals += loader.bytesTotal;
			}
			
			_bytesTotal = bTotals;
			_bytesLoaded = 0;
			_completeBytesTotal = 0;
			
			dispatchEvent(new JLoaderEvent(JLoaderEvent.BytesTotal, _bytesTotal));
			
			DisposeUtil.free(_readyHandler);
			_readyHandler = null;
			
			tryLoadNext();
			
			dispatchEvent(new JLoaderEvent(JLoaderEvent.Open));
		}
		
		/**
		 * 尝试对下一个加载器进行加载
		 * 
		 */		
		protected function tryLoadNext():void
		{
			while(_numLoadings < _maxLoadings && _waitList.length > 0)
			{
				var loader:ILoader = _waitList.shift();
				
				loader.addEventListener(JLoaderProgressEvent.Progress, __progressHandler);
				loader.addEventListener(JLoaderEvent.Complete, __completeHandler);
				loader.addEventListener(JLoaderEvent.Error, __errorHandler);
				
				putInLoadingList(loader);
				
				loader.loadAsync();
			}
			
			if(_numLoadings <= 0) tryComplete();
		}
		
		/**
		 * 加载进度事件处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function __progressHandler(e:JLoaderProgressEvent):void
		{
			var bLoaded:int = _completeBytesTotal;
			
			for each(var loader:ILoader in _loadingList)
			{
				bLoaded += loader.bytesLoaded;
			}
			
			if(bLoaded > _bytesLoaded)
			{
				_bytesLoaded = bLoaded;
				dispatchEvent(new JLoaderProgressEvent(JLoaderProgressEvent.Progress, _bytesLoaded, _bytesTotal));
			}
		}
		
		/**
		 * 加载完成事件处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function __completeHandler(e:JLoaderEvent):void
		{
			//_numLoadings--;
			
			var loader:ILoader = e.currentTarget as ILoader;
			
			_completeBytesTotal += loader.bytesLoaded;
			
			loader.removeEventListener(JLoaderProgressEvent.Progress, __progressHandler);
			loader.removeEventListener(JLoaderEvent.Complete, __completeHandler);
			loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
			
			removeOutLoadingList(loader);
			putInCompleteList(loader);
			
			if(_waitList && _waitList.length > 0) tryLoadNext();
			tryComplete();
		}
		
		/**
		 * 加载失败事件处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function __errorHandler(e:JLoaderEvent):void
		{
			//_numLoadings--;
			
			var loader:ILoader = e.currentTarget as ILoader;
			
			_completeBytesTotal += loader.bytesTotal;
			
			loader.removeEventListener(JLoaderProgressEvent.Progress, __progressHandler);
			loader.removeEventListener(JLoaderEvent.Complete, __completeHandler);
			loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
			
			removeOutLoadingList(loader);
			putInErrorList(loader);
			
			if(_waitList && _waitList.length > 0) tryLoadNext();
			tryComplete();
		}
		
		/**
		 * 检测所有资源是否已加载完成
		 * 
		 */		
		protected function tryComplete():void
		{
			if(_loadingList && _loadingList.length == 0 && _waitList && _waitList.length == 0)
			{
				if(DictionaryUtil.hasValue(_errorListDic))
				{
					_hasError = true;
					dispatchEvent(new JLoaderEvent(JLoaderEvent.Error, "批量加载中存在部分加载错误"));
				}
				if(_callback != null) _callback(this);
				dispatchEvent(new JLoaderEvent(JLoaderEvent.Complete));
			}
		}
		
		/**
		 * 释放内存
		 * 
		 */		
		public function dispose():void
		{
			var list:Array = DictionaryUtil.getValues(_allLoadersDic)
			for each(var loader:ILoader in list)
			{
				loader.removeEventListener(JLoaderProgressEvent.Progress, __progressHandler);
				loader.removeEventListener(JLoaderEvent.Complete, __completeHandler);
				loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
			}
			
			DictionaryUtil.delAll(_allLoadersDic);
			_allLoadersDic = null;
			
			DictionaryUtil.delAll(_completeListDic);
			_completeListDic = null;
			
			DictionaryUtil.delAll(_errorListDic);
			_errorListDic = null;
			
			ArrayUtil.removeAll(_waitList);
			_waitList = null;
			
			ArrayUtil.removeAll(_loadingList);
			_loadingList = null;
			
			DisposeUtil.free(_readyHandler);
			_readyHandler = null;
			
			_defaultCfg = null;
			
			_listTemp = null;
		}
	}
}

class ReadyJLoader implements IDispose
{
	import jsion.core.events.JLoaderEvent;
	import jsion.core.loaders.ILoader;
	import jsion.utils.ArrayUtil;

	private var _maxReadying:int;
	private var _list:Array;
	private var _putErrorFn:Function;
	private var _callback:Function;
	
	private var _curReadying:int;
	private var _readyingList:Array = [];
	private var _readiedList:Array = [];
	
	
	private var _allList:Array;
	
	
	public function ReadyJLoader(list:Array, putErrorFn:Function, maxReadying:int)
	{
		_list = list;
		_allList = ArrayUtil.clone(list);
		_putErrorFn = putErrorFn;
		_maxReadying = maxReadying;
	}
	
	public function ready(callback:Function):void
	{
		_callback = callback;
		
		tryGetBytesTotal();
	}
	
	protected function tryGetBytesTotal():void
	{
		while(_curReadying < _maxReadying && _list.length > 0)
		{
			var loader:ILoader = _list.shift();
			loader.addEventListener(JLoaderEvent.BytesTotal, __bytesTotalHandler);
			loader.addEventListener(JLoaderEvent.Error, __errorHandler);
			_curReadying++;
			_readyingList.push(loader);
			loader.getBytesTotal();
		}
	}
	
	protected function __bytesTotalHandler(e:JLoaderEvent):void
	{
		_curReadying--;
		var loader:ILoader = e.currentTarget as ILoader;
		ArrayUtil.remove(_readyingList, loader);
		_readiedList.push(loader);
		loader.removeEventListener(JLoaderEvent.BytesTotal, __bytesTotalHandler);
		loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
		tryGetBytesTotal();
		tryComplete();
	}
	
	protected function __errorHandler(e:JLoaderEvent):void
	{
		_curReadying--;
		var loader:ILoader = e.currentTarget as ILoader;
		ArrayUtil.remove(_readyingList, loader);
		if(_putErrorFn != null) _putErrorFn(loader);
		loader.removeEventListener(JLoaderEvent.BytesTotal, __bytesTotalHandler);
		loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
		tryGetBytesTotal();
		tryComplete();
	}
	
	protected function tryComplete():void
	{
		if(_list.length == 0 && _readyingList.length == 0 && _callback != null)
		{
			_callback.apply();
		}
	}
	
	public function dispose():void
	{
		for each(var loader:ILoader in _allList)
		{
			loader.removeEventListener(JLoaderEvent.BytesTotal, __bytesTotalHandler);
			loader.removeEventListener(JLoaderEvent.Error, __errorHandler);
		}
		
		ArrayUtil.removeAll(_list);
		_list = null;
		
		ArrayUtil.removeAll(_allList);
		_allList = null;
		
		ArrayUtil.removeAll(_readyingList);
		_readyingList = null;
		
		ArrayUtil.removeAll(_readiedList);
		_readiedList = null;
		
		_putErrorFn = null;
		
		_callback = null;
	}
}