package jsion.core.loaders
{
	import flash.display.*;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import jsion.core.reflection.Assembly;
	
	
	/**
	 * 获取完所有资源所需资源总字节数时派发
	 */	
	[Event(name="bytesTotal", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 开始批量加载时派发
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="open", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 所有加载完成时派发
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="complete", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 所有加载完成并且存在加载失败时派发
	 * @eventType org.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jcore.org.events.JLoaderEvent")]
	
	/**
	 * 加载进度变更时派发
	 * @eventType org.events.JLoaderProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="jcore.org.events.JLoaderProgressEvent")]
	
	/**
	 * <p>批量加载接口，实现类的构造函数应有三个参数：ILoaders(name:String, maxLoadings:int = 8, defaultCfg:Object = null)。</p>
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
	public interface ILoaders extends IEventDispatcher, IDispose
	{
		/**
		 * 加载器名称
		 */
		function get name():String;
		
		/**
		 * 当前最大同时加载数
		 */
		function get maxLoadings():int;
		
		/**
		 * 当前正在加载数
		 */
		function get numLoadings():int;
		
		/**
		 * 是否有资源加载失败。
		 */		
		function get hasError():Boolean;
		
		/**
		 * 当前批量加载器默认配置，配置项如下：<br /><br />
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
		 */
		function get defaultCfg():Object;
		
		/**
		 * 指示是否已经开始加载
		 */
		function get isStarted():Boolean;
		
		/**
		 * 所有资源的加载器列表
		 */
		function get allLoadersDic():Dictionary;
		
		/**
		 * 指示等待加载列表
		 */
		function get waitList():Array;
		
		/**
		 * 正在加载列表
		 */
		function get loadingList():Array;
		
		/**
		 * 加载完成列表，加载时有效。
		 */
		function get completeListDic():Dictionary;
		
		/**
		 * 加载失败列表，加载时有效。
		 */
		function get errorListDic():Dictionary;
		
		/**
		 * 已加载总字节数，加载时有效。
		 */
		function get bytesLoaded():int;
		
		/**
		 * 已完成加载的总字节数，加载时有效。
		 * @private
		 */
		function get completeBytesTotal():int;
		
		/**
		 * 所需加载的总字节数，加载时有效。
		 */		
		function get bytesTotal():int;
		
		/**
		 * <p>加入等待加载列表</p>
		 * @param url 资源地址
		 * @param cfg JSON配置
		 */
		function add(url:String, cfg:Object = null):ILoader;
		
		/**
		 * <p>加入等待加载列表</p>
		 * @param loader 加载器
		 */		
		function addLoader(loader:ILoader):void;
		
		/**
		 * 获取指定资源的Loader对象
		 * @param url  与传递给add方法的资源地址相同
		 * @return ILoader的实现对象
		 * 
		 */		
		function getLoader(url:String):ILoader;
		
		/**
		 * 获取字节流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 节流对象
		 * 
		 */		
		function getBinary(url:String):ByteArray;
		
		/**
		 * 获取文本字符串对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 字符串对象
		 * 
		 */		
		function getText(url:String):String;
		
		/**
		 * 获取Xml对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return Xml对象
		 * 
		 */		
		function getXml(url:String):XML;
		
		/**
		 * 获取Bitmap图片
		 * @param url 与传递给add方法的资源地址相同
		 * @return Bitmap图片，无对应资源时返回null。
		 * 
		 */		
		function getBitmap(url:String):Bitmap;
		
		/**
		 * 获取图片的BitmapData数据
		 * @param url 与传递给add方法的资源地址相同
		 * @return 新的BitmapData数据对象
		 * 
		 */		
		function getBitmapData(url:String):BitmapData;
		
		/**
		 * 获取影片剪辑对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 影片剪辑对象
		 * 
		 */		
		function getMovieClip(url:String):MovieClip;
		
		/**
		 * 获取声音对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 声音对象
		 * 
		 */		
		function getSound(url:String):Sound;
		
		/**
		 * 获取视频流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 视频流对象
		 * 
		 */		
		function getVideo(url:String):NetStream;
		
		/**
		 * 获取swf库的字节流对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return 库字节流对象
		 * 
		 */		
		function getLib(url:String):ByteArray;
		
		/**
		 * 获取Swc库的Assembly对象
		 * @param url 与传递给add方法的资源地址相同
		 * @return Assembly对象
		 * 
		 */		
		function getSwc(url:String):Assembly;
		
		/**
		 * 开始批量加载
		 * 
		 */		
		function start(completeCallback:Function = null, embedCallback:Function = null):ILoaders;
	}
}