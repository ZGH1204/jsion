package jsion.core.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import jsion.core.cryptor.*;
	import jsion.core.events.*;
	import jsion.utils.*;
	
	
	/**
	 * 建立加载时分派
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="open", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 加载完成时分派
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="complete", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 如果发生错误并导致发送或加载操作失败，将分派 Error 事件，其中事件数据data为要显示错误消息的文本。
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 在网络请求返回 HTTP 状态代码时，应用程序将分派 HttpStatus 事件，其中事件数据data为Http状态代码。<br/><br/>
	 * 
	 * 在错误或完成事件之前，将始终发送 HttpStatus 事件。HttpStatus 事件不一定指示错误条件；
	 * 它仅反映网络堆栈提供的 HTTP 状态代码（如果有的话）。一些 Flash Player 环境可能无法检测到 HTTP 状态代码；
	 * 在这些情况下，将总是报告状态代码 0。 
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="httpStatus", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 资源加载总字节数获取后分派，其中事件数据data为资源总字节数。
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="bytesTotal", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 用于通知视频或音频可以开始播放
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="canBeginPlaying", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 当加载操作已开始或套接字已接收到数据时，将分派 JLoaderProgressEvent 对象。这些事件通常在将 SWF 文件、图像或数据加载到应用程序中时生成。
	 * @eventType org.events.JLoaderProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="jcore.org.events.JLoaderProgressEvent")]
	
	/**
	 * <p>JLoader 类是JCore库所有加载器的抽象基类。</p>
	 * <p>JLoader 类未实现具体的加载操作，因此直接调用将不会进行任何的加载操作。</p>
	 * 
	 * <p>构造函数中 cfg 参数配置项如下：</p>
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
	 * 			<td>对应的资源类型，未配置时其值为空字符串，通过批量加载器生成并且未配置时其值为扩展名对应的资源类型。</td>
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
	 * <br/><br/>
	 * 
	 * @see BinaryLoader
	 * @see ImageLoader
	 * @see LibLoader
	 * @see SwcLoader
	 * @see TextLoader
	 * @see XmlLoader
	 * 
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JCore 1
	 * 
	 */	
	public class JLoader extends EventDispatcher implements ILoader, IDispose
	{
		protected static const Default_Cfg:Object = {root: ""};
		
		protected var _url:String;
		protected var _urlKey:String;
		protected var _uri:String;
		
		protected var _request:URLRequest;
		
		protected var _isBytesTotal:Boolean;
		protected var _isComplete:Boolean;
		protected var _isLoading:Boolean;
		
		protected var _httpStatus:int = -1;
		protected var _bytesLoaded:int = 0;
		protected var _bytesTotal:int = 0;
		protected var _bytesRemaining:int = int.MAX_VALUE;
		protected var _content:* = null;
		
		
		protected var _bytesTotalStartTime:int;
		protected var _startTime:int;
		protected var _openTime:int;
		protected var _completeTime:int;
		
		protected var _downloadTimeSpan:Number;
		protected var _responseTimeSpan:Number;
		protected var _bytesTotalTimeSpan:Number;
		
		protected var _downloadSpeed:Number = 0;
		
		protected var _callback:Function;
		
		protected var _curTryTimes:int = 0;
		
		
		protected var _status:String = LoaderGlobal.StatusInitialized;
		
		
		
		////////////////////////////////////////	JSON配置		////////////////////////////////////////
		
		/**
		 * 对应的资源类型，参见jcore.org.loader.LoaderGloba中的资源类型常量。
		 */		
		protected var _type:String;
		
		/**
		 * 是否忽略Http本身的缓存
		 */		
		protected var _rnd:Boolean;
		
		/**
		 * 资源根路径
		 */		
		protected var _root:String;
		
		/**
		 * 指示加载时的优先级，数值越大越优先。
		 */		
		protected var _priority:int;
		
		/**
		 * 指示当前加载器是否使用LoaderMonitor进行管理
		 */		
		protected var _managed:Boolean;
		
		/**
		 * 解密器
		 */		
		protected var _cryptor:ICryption;
		
		/**
		 * 请求时用于Http标头的列表，URLRequestHeader对象列表。
		 */		
		protected var _headers:Array;
		
		/**
		 * 仅允许LoaderContext 或 SoundLoaderContext 类的对象，用于 swf 或 sound 的加载。
		 */		
		protected var _context:Object;
		
		/**
		 * 对uri进行格式化绑定的数据源
		 */		
		protected var _bindData:Object;
		
		/**
		 * 加载失败时的可重试次数，默认为3。
		 */		
		protected var _hadTryTimes:int;
		
		/**
		 * 用于URLRequest.method属性，其可能的值为 URLRequestMethod 类的常量值。
		 */		
		protected var _requestMethod:String;
		
		/**
		 * 用于URLRequest.data属性，Http的请求参数。
		 */		
		protected var _urlVariables:Object;
		
		/**
		 * 用于指示是否缓存在内存中
		 */		
		protected var _cacheInMemory:Boolean;
		
		/**
		 * 用于NetStream.play的播放参数。
		 */		
		protected var _checkPolicyFile:Boolean;
		
		/**
		 * 用于指示NetStream打开时是否暂停在开始播放前。
		 */		
		protected var _pausedAtStart:Boolean;
		
		
		////////////////////////////////////////	JSON配置		////////////////////////////////////////
		
		
		public function JLoader(url:String, cfg:Object = null)
		{
			super();
			
			_url = url;
			
			_urlKey = JUtil.path2Key(_url);
			
			var c:Object = {};
			
			ObjectUtil.copyDynamicToTarget2(Default_Cfg, c);
			ObjectUtil.copyDynamicToTarget2(cfg, c);
			
			parseCfgJSON(c);
			
			initialize();
			
			configLoader();
		}
		
		/**
		 * 解析JSON配置并更新对应值
		 * 
		 */		
		protected function parseCfgJSON(cfg:Object):void
		{
			cfg = cfg || {};
			
			if(cfg[LoaderJSON.managed] == null) cfg[LoaderJSON.managed] = true;
			
			_rnd = cfg[LoaderJSON.rnd] || false;
			_managed = cfg[LoaderJSON.managed] || false;
			_cacheInMemory = cfg[LoaderJSON.cacheInMemory] || false;
			_checkPolicyFile = cfg[LoaderJSON.checkPolicyFile] || false;
			_pausedAtStart = cfg[LoaderJSON.pausedAtStart] || false;
			_priority = cfg[LoaderJSON.priority] || Constant.Zero;
			_hadTryTimes = cfg[LoaderJSON.tryTimes] || 3;
			_type = cfg[LoaderJSON.type] || Constant.Empty;
			_root = cfg[LoaderJSON.root] || Constant.Empty;
			_cryptor = cfg[LoaderJSON.cryptor];
			_bindData = cfg[LoaderJSON];
			_requestMethod = cfg[LoaderJSON.requestMethod] || URLRequestMethod.GET;
			_headers = cfg[LoaderJSON.headers];
			_urlVariables = cfg[LoaderJSON.urlVariables];
			
			_context = cfg[LoaderJSON.context];
		}
		
		/**
		 * 初始化 URLRequest 对象
		 * 
		 */		
		protected function initialize():void
		{
			_uri = _root + url;
			
			_uri = StringUtil.bindString(_uri, _bindData);
			
			_request = new URLRequest(_uri);
			
			_request.method = _requestMethod;
			_request.requestHeaders = _headers;
		}
		
		/**
		 * 配置加载器(必需重写)
		 * 
		 */		
		protected function configLoader():void
		{
			
		}
		
		/**
		 * 对应的资源类型，参见jcore.org.loader.LoaderGloba中的资源类型常量。
		 * @return 资源类型值
		 * 
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 是否忽略Http本身的缓存
		 * @return true表示不附加随机数参数，false则反之。
		 * 
		 */		
		public function get rnd():Boolean
		{
			return _rnd;
		}
		
		/**
		 * 加载资源的根地址
		 * @return 根地址
		 * 
		 */		
		public function get root():String
		{
			return _root;
		}
		
		/**
		 * 构造函数传递的Url地址
		 * @return 构造函数的原始参数
		 * 
		 */		
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * 用Url地址转换为字典键
		 * @return 转换后的字典键
		 * 
		 */		
		public function get urlKey():String
		{
			return _urlKey;
		}
		
		/**
		 * 绑定后的加载资源绝对路径，即：root + url
		 * @return 资源绝对路径
		 * 
		 */		
		public function get uri():String
		{
			return _uri;
		}
		
		/**
		 * 指示加载时的优先级，数值越大越优先。
		 * @return 优先级
		 * 
		 */		
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * 指示当前加载器是否使用LoaderMonitor进行管理，默认值 为true。
		 * @return true表示进行管理，false则反之。
		 * 
		 */		
		public function get managed():Boolean
		{
			return _managed;
		}
		
		/**
		 * 解密器对象
		 * @return 解密器对象
		 * 
		 */		
		public function get cryptor():ICryption
		{
			return _cryptor;
		}
		
		/**
		 * 请求时用于Http标头的列表
		 * @return URLRequestHeader对象列表
		 * 
		 */		
		public function get headers():Array
		{
			return _headers;
		}
		
		/**
		 * 仅允许LoaderContext 或 SoundLoaderContext 类的对象，用于 swf 或 sound 的加载。
		 * @return LoaderContext 或 SoundLoaderContext 类的对象
		 * 
		 */		
		public function get context():Object
		{
			return _context;
		}
		
		/**
		 * 对uri进行格式化绑定的数据
		 * @return 要绑定到uri的数据源
		 * 
		 */		
		public function get bindData():Object
		{
			return _bindData;
		}
		
		/**
		 * 用于URLRequest.method属性，其可能的值为 URLRequestMethod 类的常量值。
		 * @return URLRequestMethod.GET 或 URLRequestMethod.POST
		 * 
		 */		
		public function get requestMethod():String
		{
			return _requestMethod;
		}
		
		/**
		 * 用于URLRequest.data属性
		 * @return Http的请求参数
		 * 
		 */		
		public function get urlVariables():Object
		{
			return _urlVariables;
		}
		
		/**
		 * 已加载的字节数
		 * @return 字节数
		 * 
		 */		
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}
		
		/**
		 * 所需加载的字节总数
		 * @return 字节总数
		 * 
		 */		
		public function get bytesTotal():int
		{
			return _bytesTotal;
		}
		
		/**
		 * 剩余所需加载的字节总数
		 * @return 剩余字节总数
		 * 
		 */		
		public function get bytesRemaining():int
		{
			return _bytesRemaining;
		}
		
		/**
		 * 是否已获取加载总字节数
		 * @return true表示已获取，false则反之。
		 * 
		 */		
		public function get isBytesTotal():Boolean
		{
			return _isBytesTotal;
		}
		
		/**
		 * 是否正在加载中
		 * @return true表示正在加载，false表示不在加载中。
		 * 
		 */		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		/**
		 * 是否已经加载完成
		 * @return true表示已加载完成，false则反之。
		 * 
		 */		
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		/**
		 * 加载完成后的数据，需在JLoaderEvent.Complete事件派发时生效。
		 * @return 加载完成所得到的数据
		 * 
		 */		
		public function get content():*
		{
			return _content;
		}
		
		/**
		 * 当前加载器的状态，其值参考LoaderGloba的Status常量。
		 * @return 当前状态
		 * 
		 */		
		public function get status():String
		{
			return _status;
		}
		
		/**
		 * 开始获取所需加载总字节数的时刻
		 * @return 开始获取加载总字节数的时刻
		 * 
		 */		
		public function get bytesTotalStartTime():int
		{
			return _bytesTotalStartTime;
		}
		
		/**
		 * 调用load()方法的时刻
		 * @return 开始load的时刻
		 * 
		 */		
		public function get startTime():int
		{
			return _startTime;
		}
		
		/**
		 * 服务器收到请求并返回到达客户端的时刻，JLoaderEvent.Open派发时生效。
		 * @return 到达客户端的时刻
		 * 
		 */		
		public function get openTime():int
		{
			return _openTime;
		}
		
		/**
		 * 从网络接收数据完毕的时刻，JLoaderEvent.Complete派发时生效。
		 * @return 接收数据完毕的时刻
		 * 
		 */		
		public function get completeTime():int
		{
			return _completeTime;
		}
		
		/**
		 * 下载数据所用的时间, JLoaderEvent.Complete 派发时生效
		 * @return 下载数据所用的时间
		 * 
		 */		
		public function get downloadTimeSpan():Number
		{
			return _downloadTimeSpan;
		}
		
		/**
		 * 服务器收到请求并返回到达客户端所用的时间，JLoaderEvent.Open派发时生效。
		 * @return 到达客户端所用的时间
		 * 
		 */		
		public function get responseTimeSpan():Number
		{
			return _responseTimeSpan;
		}
		
		/**
		 * 获取所需加载总字节数所用的时间，JLoaderEvent.BytesTotal派发时生效。
		 * @return 获取所需加载总字节数所用的时间
		 * 
		 */		
		public function get bytesTotalTimeSpan():Number
		{
			return _bytesTotalTimeSpan;
		}
		
		/**
		 * 下载数据的平均速度，派发JLoaderProgressEvent.Progress事件时更新速度。
		 * @return 平均速度
		 * 
		 */		
		public function get downloadSpeed():Number
		{
			return _downloadSpeed;
		}
		
		/**
		 * 指示加载失败时当前已重试次数
		 * @return 已重试次数
		 * 
		 */		
		public function get curTryTimes():int
		{
			return _curTryTimes;
		}
		
		/**
		 * 指示加载失败时的可重试次数，默认为3。
		 * @return 可重试次数
		 * 
		 */		
		public function get hadTryTimes():int
		{
			return _hadTryTimes;
		}
		
		/**
		 * 是否为视频资源
		 * @return true表示是视频资源，false则反之。
		 * 
		 */		
		public function get isVideo():Boolean
		{
			return false;
		}
		
		/**
		 * 是否为声音资源
		 * @return true表示是声音资源，false则反之。
		 * 
		 */		
		public function get isSound():Boolean
		{
			return false;
		}
		
		/**
		 * 是否为流媒体资源
		 * @return true表示是流媒体资源，false则反之。
		 * 
		 */		
		public function get isStreamable():Boolean
		{
			return false;
		}
		
		/**
		 * 执行加载(必需重写)，与加载管理类无关。
		 * 
		 */		
		protected function load():void
		{
			if(_isComplete || _isLoading) return;
			_startTime = getTimer();
			_isLoading = true;
			
			if(_request)
			{
				var urlVar:URLVariables = _request.data as URLVariables;
				if(urlVar == null && _urlVariables != null) urlVar = new URLVariables();
				
				if(_rnd)
				{
					var str:String = "rnd=" + String(Math.random());
					
					if(_request.url.indexOf("rnd=") == -1)
					{
						if(_request.url.indexOf("?") == -1) str = "?" + str;
						else str = "&" + str;
						
						_request.url += str;
					}
					else
					{
						_request.url = _request.url.replace(/rnd=[0-9.]*/g, str);
					}
				}
				
				ObjectUtil.copyDynamicToTarget2(_urlVariables, urlVar);
				
				_request.data = urlVar;
			}
		}
		
		/**
		 * 添加监听事件，其中监听事件列表如下：<br/><br/>
		 * 
		 *　　IOErrorEvent.IO_ERROR　　　　　　　　　　　　onErrorHandler<br/>
		 *　　SecurityErrorEvent.SECURITY_ERROR　　　　　　onSecurityErrorHandler<br/>
		 *　　Event.OPEN　　　　　　　　　　　　　　　　 　onOpenHandler<br/>
		 *　　HTTPStatusEvent.HTTP_STATUS　　　　　　　　onHttpStatusHandler<br/>
		 *　　ProgressEvent.PROGRESS　　　　　　　　　　　onProgressHandler<br/>
		 *　　Event.COMPLETE　　　　　　　　　　　　　　　onCompleteHandler<br/><br/>
		 * 
		 * @param ed 事件分发器
		 * 
		 */		
		protected function addLoadEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.addEventListener(IOErrorEvent.IO_ERROR, 				onErrorHandler, 		false, int.MAX_VALUE, false);
			ed.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityErrorHandler, false, int.MAX_VALUE, false);
			ed.addEventListener(Event.OPEN, 						onOpenHandler, 			false, int.MAX_VALUE, false);
			ed.addEventListener(HTTPStatusEvent.HTTP_STATUS, 		onHttpStatusHandler, 	false, int.MAX_VALUE, false);
			ed.addEventListener(ProgressEvent.PROGRESS, 			onProgressHandler, 		false, int.MAX_VALUE, false);
			ed.addEventListener(Event.COMPLETE, 					onCompleteHandler, 		false, int.MAX_VALUE, false);
		}
		
		/**
		 * 移除由 addLoadEvent 方法监听的事件
		 * @param ed 事件分发器
		 * 
		 */		
		protected function removeLoadEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.removeEventListener(IOErrorEvent.IO_ERROR, 				onErrorHandler, 		false);
			ed.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityErrorHandler, false);
			ed.removeEventListener(Event.OPEN, 							onOpenHandler, 			false);
			ed.removeEventListener(HTTPStatusEvent.HTTP_STATUS, 		onHttpStatusHandler, 	false);
			ed.removeEventListener(ProgressEvent.PROGRESS, 				onProgressHandler, 		false);
			ed.removeEventListener(Event.COMPLETE, 						onCompleteHandler, 		false);
		}
		
		/**
		 * 执行加载并设置回调函数和重试次数，加载前会先判断是否受加载管理类的队列管理。
		 * @param callback 回调函数，无论加载成功或失败都会以 this 做为参数调用此函数。
		 * 
		 */		
		public function loadAsync(callback:Function = null):ILoader
		{
			if(callback != null) _callback = callback;
			
			if(_isComplete || _isLoading) return this;
			
			if(_managed == false || LoaderMonitor.getCanLoad(this))
			{
				load();
			}
			else
			{
				LoaderMonitor.joinManaged(this);
			}
			
			return this;
		}
		
		/**
		 * 停止正在进行的加载并从加载管理中移除，获取所需加载总字节数时不移除。(必需重写)
		 * 
		 */		
		public function stop():void
		{
			if(_isComplete || _status == LoaderGlobal.StatusError) return;
			
			_isLoading = false;
			if(_status == LoaderGlobal.StatusGetBytesTotal) return;
			_status = LoaderGlobal.StatusStopped;
			LoaderMonitor.exitManaged(this);
		}
		
		/**
		 * 添加获取资源总字节数监听事件
		 * @param ed 事件分发器
		 * 
		 */		
		protected function addBytesTotalEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.addEventListener(IOErrorEvent.IO_ERROR, 				onErrorHandler, 				false);
			ed.addEventListener(ProgressEvent.PROGRESS, 			onBytesTotalProgressHandler,	false);
			ed.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityErrorHandler, 		false);
		}
		
		/**
		 * 移除addBytesTotalEvent访求监听的事件
		 * @param ed 事件分发器
		 * 
		 */		
		protected function removeBytesTotalEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.removeEventListener(IOErrorEvent.IO_ERROR, 				onErrorHandler, 				false);
			ed.removeEventListener(ProgressEvent.PROGRESS, 				onBytesTotalProgressHandler,	false);
			ed.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onSecurityErrorHandler, 		false);
		}
		
		/**
		 * 获取资源总字节数(必需重写)
		 * 
		 */		
		public function getBytesTotal():void
		{
			_bytesTotalStartTime = getTimer();
			_status = LoaderGlobal.StatusGetBytesTotal;
		}
		
		/**
		 * 获取到资源总字节数的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onBytesTotalProgressHandler(e:ProgressEvent):void
		{
			stop();
			_bytesTotal = e.bytesTotal;
			_bytesRemaining = e.bytesTotal;
			var ed:EventDispatcher = e.currentTarget as EventDispatcher;
			removeBytesTotalEvent(ed);
			_bytesTotalTimeSpan = (getTimer() - _bytesTotalStartTime) / 1000;
			dispatchEvent(new JLoaderEvent(JLoaderEvent.BytesTotal, _bytesTotal));
		}
		
		
		/**
		 * 打开资源下载链接时的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onOpenHandler(e:Event):void
		{
			_openTime = getTimer();
			_responseTimeSpan = (_openTime - _startTime) / 1000;
			_status = LoaderGlobal.StatusStarted;
			dispatchEvent(new JLoaderEvent(JLoaderEvent.Open));
		}
		
		/**
		 * HttpStatus改变的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onHttpStatusHandler(e:HTTPStatusEvent):void
		{
			_httpStatus = e.status;
			dispatchEvent(new JLoaderEvent(JLoaderEvent.HttpStatus, e.status));
		}
		
		/**
		 * 加载错误的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onErrorHandler(e:IOErrorEvent):void
		{
			if(_curTryTimes < _hadTryTimes)
			{
				_curTryTimes++;
				
				load();
			}
			else
			{
				_isLoading = false;
				_isComplete = false;
				_status = LoaderGlobal.StatusError;
				_curTryTimes = 0;
				
				removeLoadEvent(e.currentTarget as EventDispatcher);
				removeBytesTotalEvent(e.currentTarget as EventDispatcher);
				
				if(_callback != null) _callback(this);
				
				dispatchEvent(new JLoaderEvent(JLoaderEvent.Error, e.text));
				
				LoaderMonitor.completeLoad(this);
			}
		}
		
		/**
		 * 安全沙箱错误的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			_isLoading = false;
			_isComplete = false;
			_status = LoaderGlobal.StatusError;
			
			removeLoadEvent(e.currentTarget as EventDispatcher);
			removeBytesTotalEvent(e.currentTarget as EventDispatcher);
			
			if(_callback != null) _callback(this);
			
			dispatchEvent(new JLoaderEvent(JLoaderEvent.Error, e.text));
			
			LoaderMonitor.completeLoad(this);
		}
		
		/**
		 * 加载进度的处理函数
		 * @param e 事件对象
		 * 
		 */		
		protected function onProgressHandler(e:ProgressEvent):void
		{
			_bytesLoaded = e.bytesLoaded;
			if(_bytesTotal <= 0)
			{
				_bytesTotal = e.bytesTotal;
				_bytesRemaining = e.bytesTotal;
			}
			_bytesRemaining = e.bytesTotal - e.bytesLoaded;
			_downloadSpeed = (_bytesLoaded / ((getTimer() - _openTime) / 1000)) / 1024;
			dispatchEvent(new JLoaderProgressEvent(JLoaderProgressEvent.Progress, e.bytesLoaded, e.bytesTotal));
		}
		
		/**
		 * 加载完成的处理函数(必需重写)
		 * @param e 事件对象
		 * 
		 */		
		protected function onCompleteHandler(e:Event):void
		{
			_completeTime = getTimer();
			_downloadTimeSpan = (_completeTime - _openTime) / 1000;
			_isComplete = true;
			_isLoading = false;
			_status = LoaderGlobal.StatusFinished;
			
			if(e)
			{
				removeLoadEvent(e.currentTarget as EventDispatcher);
				removeBytesTotalEvent(e.currentTarget as EventDispatcher);
			}
			
			if(_callback != null) _callback(this);
			
			dispatchEvent(new JLoaderEvent(JLoaderEvent.Complete));
			
			LoaderMonitor.completeLoad(this);
		}
		
		/**
		 * 如果 cryptor 解密器存在则对 bytes 进行解密操作，否则返回 bytes。
		 * @param bytes 要解密的字节流
		 * @return 如果进行解密操作则返回解密后的字节流，否则返回 bytes。
		 * 
		 */		
		protected function decrypt(bytes:ByteArray):ByteArray
		{
			if(_cryptor)
				return _cryptor.decry(bytes);
			return bytes;
		}
		
		/**
		 * 释放内在资源
		 * 
		 */		
		public function dispose():void
		{
			_headers = null;
			_context = null;
			_cryptor = null;
			_bindData = null;
			_urlVariables = null;
			_content = null;
			_request = null;
			_callback = null;
			
			if(_request) _request.data = null;
			
			stop();
		}
	}
}