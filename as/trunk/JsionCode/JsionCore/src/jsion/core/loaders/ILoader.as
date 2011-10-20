package jsion.core.loaders
{
	import flash.events.IEventDispatcher;
	
	import jsion.core.cryptor.ICryption;
	
	
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
	 * <p>加载接口，实现类的构造函数应有两个参数：ILoader(url:String, cfg:Object = null)</p>
	 * <p>构造函数中 cfg 参数配置项如下：</p>
	 * <p>
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
	 * </p>
	 * <br/><br/>
	 * 
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public interface ILoader extends IEventDispatcher, IDispose
	{
		/**
		 * 对应的资源类型，参见jcore.org.loader.LoaderGloba中的资源类型常量。
		 * @return 资源类型值
		 * 
		 */		
		function get type():String;
		
		/**
		 * 是否忽略Http本身的缓存
		 * @return true表示不附加随机数参数，false则反之。
		 * 
		 */		
		function get rnd():Boolean;
		
		/**
		 * 加载资源的根地址
		 * @return 根地址
		 * 
		 */		
		function get root():String;
		
		/**
		 * 构造函数传递的Url地址
		 * @return 构造函数的原始参数
		 * 
		 */		
		function get url():String;
		
		/**
		 * 用Url地址转换为字典键
		 * @return 转换后的字典键
		 * 
		 */		
		function get urlKey():String;
		
		/**
		 * 绑定后的加载资源绝对路径，即：root + url
		 * @return 资源绝对路径
		 * 
		 */		
		function get uri():String;
		
		/**
		 * 指示加载时的优先级，数值越大越优先。
		 * @return 优先级
		 * 
		 */		
		function get priority():int;
		
		/**
		 * 指示当前加载器是否使用LoaderMonitor进行管理，默认值 为true。
		 * @return true表示进行管理，false则反之。
		 * 
		 */		
		function get managed():Boolean;
		
		/**
		 * 解密器对象
		 * @return 解密器对象
		 * 
		 */		
		 function get cryptor():ICryption;
		 
		 /**
		  * 请求时用于Http标头的列表
		  * @return URLRequestHeader对象列表
		  * 
		  */		
		 function get headers():Array;
		 
		 /**
		  * 仅允许LoaderContext 或 SoundLoaderContext 类的对象，用于 swf 或 sound 的加载。
		  * @return LoaderContext 或 SoundLoaderContext 类的对象
		  * 
		  */		
		 function get context():Object;
		 
		 /**
		  * 对uri进行格式化绑定的数据
		  * @return 要绑定到uri的数据源
		  * 
		  */		
		 function get bindData():Object;
		 
		 /**
		  * 用于URLRequest.method属性，其可能的值为 URLRequestMethod 类的常量值。
		  * @return URLRequestMethod.GET 或 URLRequestMethod.POST
		  * 
		  */		
		 function get requestMethod():String;
		 
		 /**
		  * 用于URLRequest.data属性
		  * @return Http的请求参数
		  * 
		  */		
		 function get urlVariables():Object;
		 
		 /**
		  * 已加载的字节数
		  * @return 字节数
		  * 
		  */		
		 function get bytesLoaded():int;
		 
		 /**
		  * 所需加载的字节总数
		  * @return 字节总数
		  * 
		  */		
		 function get bytesTotal():int;
		 
		 /**
		  * 剩余所需加载的字节总数
		  * @return 剩余字节总数
		  * 
		  */		
		 function get bytesRemaining():int;
		 
		 /**
		  * 是否已获取加载总字节数
		  * @return true表示已获取，false则反之。
		  * 
		  */		
		 function get isBytesTotal():Boolean;
		
		/**
		 * 是否正在加载中
		 * @return true表示正在加载，false表示不在加载中。
		 * 
		 */		
		function get isLoading():Boolean;
		
		/**
		 * 是否已经加载完成
		 * @return true表示已加载完成，false则反之。
		 * 
		 */		
		function get isComplete():Boolean;
		
		/**
		 * 加载完成后的数据，在JLoaderEvent.Complete事件派发或调用回调函数时生效。
		 */		
		function get content():*;
		
		/**
		 * 当前加载器的状态
		 */		
		function get status():String;
		
		/**
		 * 开始获取所需加载总字节数的时刻
		 * @return 开始获取加载总字节数的时刻
		 * 
		 */		
		function get bytesTotalStartTime():int;
		
		/**
		 * 调用load()方法的时刻
		 * @return 开始load的时刻
		 * 
		 */		
		function get startTime():int;
		
		/**
		 * 服务器收到请求并返回到达客户端的时刻，JLoaderEvent.Open派发时生效。
		 * @return 到达客户端的时刻
		 * 
		 */		
		function get openTime():int;
		
		/**
		 * 从网络接收数据完毕的时刻，JLoaderEvent.Complete派发时生效。
		 * @return 接收数据完毕的时刻
		 * 
		 */		
		function get completeTime():int;
		
		/**
		 * 下载数据所用的时间, JLoaderEvent.Complete 派发时生效
		 * @return 下载数据所用的时间
		 * 
		 */		
		function get downloadTimeSpan():Number;
		
		/**
		 * 服务器收到请求并返回到达客户端所用的时间，JLoaderEvent.Open派发时生效。
		 * @return 到达客户端所用的时间
		 * 
		 */		
		function get responseTimeSpan():Number;
		
		/**
		 * 获取所需加载总字节数所用的时间，JLoaderEvent.BytesTotal派发时生效。
		 * @return 获取所需加载总字节数所用的时间
		 * 
		 */		
		function get bytesTotalTimeSpan():Number;
		
		/**
		 * 下载数据的平均速度，派发JLoaderProgressEvent.Progress事件时更新速度。
		 * @return 平均速度
		 * 
		 */		
		function get downloadSpeed():Number;
		
		/**
		 * 指示加载失败时当前已重试次数
		 * @return 已重试次数
		 * 
		 */		
		function get curTryTimes():int;
		
		/**
		 * 指示加载失败时的可重试次数，默认为3。
		 * @return 可重试次数
		 * 
		 */		
		function get hadTryTimes():int;
		
		/**
		 * 是否为视频资源
		 * @return true表示是视频资源，false则反之。
		 * 
		 */		
		function get isVideo():Boolean;
		
		/**
		 * 是否为声音资源
		 * @return true表示是声音资源，false则反之。
		 * 
		 */		
		function get isSound():Boolean;
		
		/**
		 * 是否为流媒体资源
		 * @return true表示是流媒体资源，false则反之。
		 * 
		 */		
		function get isStreamable():Boolean;
		
		/**
		 * 指示SwcLoader和LibLoader是否自动加载到程序域
		 */		
		function get autoEmbed():Boolean;
		
		/** @private */
		function set autoEmbed(value:Boolean):void;
		
		/**
		 * 手动调用加载到程序域
		 */		
		function embedInDomain(embedCallback:Function = null):void;
		
		/**
		 * 执行加载并设置回调函数和重试次数，其中回调函数以 this 做为参数进行回调。
		 * @param callback 回调函数
		 * 
		 */		
		function loadAsync(fn:Function = null):ILoader;
		
		/**
		 * 停止正在进行的加载并从加载管理中移除，获取所需加载总字节数时不移除。(必需重写)
		 * 
		 */		
		function stop():void;
		
		/**
		 * 获取资源总字节数(必需重写)
		 * 
		 */		
		function getBytesTotal():void;
	}
}