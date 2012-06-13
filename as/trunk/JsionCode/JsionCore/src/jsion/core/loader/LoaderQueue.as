package jsion.core.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.core.events.JsionEvent;
	import jsion.core.events.JsionEventDispatcher;
	import jsion.core.reflection.Assembly;
	import jsion.utils.ArrayUtil;
	import jsion.utils.CacheUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	
	/**
	 * 所有文件加载完成后触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="complete", type="jsion.core.events.JsionEvent")]
	/**
	 * 所有文件加载完成后，有文件加载失败时触发。
	 * 可通过 errorList、errorUrlList 属性获取加载失败文件列表。
	 * 可通过 hasError、errorCount 属性判断是否有文件加载失败。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="error", type="jsion.core.events.JsionEvent")]
	/**
	 * 单个文件加载进度变更时派发。
	 * @eventType flash.events.ProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * 资源队列加载器。默认文件对应加载器如下：
	 * <ul>
	 * 	<li>jpg  : BitmapDataLoader</li>
	 * 	<li>jpeg : BitmapDataLoader</li>
	 * 	<li>png  : BitmapDataLoader</li>
	 * 	<li>txt  : TextLoader</li>
	 * 	<li>xml  : XmlLoader</li>
	 * 	<li>swf  : SwfLoader</li>
	 * 	<li>swc  : SwcLoader</li>
	 * 	<li>swx  : LibLoader</li>
	 * </ul>
	 * @author Jsion
	 * 
	 */	
	public class LoaderQueue extends JsionEventDispatcher implements IDispose
	{
		/**
		 * 扩展名对应加载类列表
		 * @private
		 */		
		public static var Extension_Loader_Class:Object = {
			"jpg" : BitmapDataLoader,
			"jpeg" : BitmapDataLoader,
			"png" : BitmapDataLoader,
			"txt" : TextLoader,
			"xml" : XmlLoader,
			"swf" : SwfLoader,
			"swc" : SwcLoader,
			"swx" : LibLoader
		};
		
		/**
		 * 通过扩展名注册新的文件加载支持
		 * @param ext 扩展名，不需要 "." 符号。
		 * @param loaderCls 实现 ILoader 接口的加载类。
		 */		
		public static function registeNewType(ext:String, loaderCls:Class):void
		{
			if(StringUtil.isNullOrEmpty(ext) || loaderCls == null)
			{
				throw new ArgumentError("参数错误，有一个或多个参数为空。");
				return;
			}
			
			var index:int = ext.lastIndexOf(".");
			var lstExt:String;
			
			if(index == -1) lstExt = ext;
			else lstExt = ext.substr(index + 1);
			
			//if(Extension_Loader_Class[lstExt]) return;
			
			Extension_Loader_Class[lstExt] = loaderCls;
		}
		
		protected var m_maxSyncLoading:int;
		
		protected var m_loaderList:Array;
		
		protected var m_loadingList:Array;
		
		protected var m_completeList:HashMap;
		
		protected var m_errorList:HashMap;
		
		protected var m_callback:Function;
		
		protected var m_loaderCount:int;
		
		protected var m_progressCallback:Function;
		
		public function LoaderQueue()
		{
			super();
			
			m_maxSyncLoading = 1;
			
			m_loaderList = [];
			
			m_loadingList = [];
			
			m_completeList = new HashMap();
			
			m_errorList = new HashMap();
		}
		
		/**
		 * 最大的同时加载个数。
		 */		
		public function get maxSyncLoading():int
		{
			return m_maxSyncLoading;
		}
		
		/**
		 * 队列中需要加载的资源数。
		 */		
		public function get loaderCount():int
		{
			return m_loaderCount;
		}
		
		/**
		 * 当前加载完成的资源数。
		 */		
		public function get completeCount():int
		{
			return m_completeList.size;
		}
		
		/**
		 * 当前加载失败的资源数。
		 */		
		public function get errorCount():int
		{
			return m_errorList.size;
		}
		
		/**
		 * 指示当前是否有资源加载出错。
		 */		
		public function get hasError():Boolean
		{
			return m_errorList.size != 0;
		}
		
		/**
		 * 加载完成的资源加载器列表。
		 */		
		public function get completeList():Array
		{
			return m_completeList.getValues();
		}
		
		/**
		 * 加载出错的资源加载器列表。
		 */		
		public function get errorList():Array
		{
			return m_errorList.getValues();
		}
		
		/**
		 * 加载完成的资源路径列表。
		 */		
		public function get completeUrlList():Array
		{
			var rlt:Array = [];
			var list:Array = completeList;
			
			for each(var loader:ILoader in list)
			{
				ArrayUtil.push(rlt, loader.fullUrl);
			}
			
			return rlt;
		}
		
		/**
		 * 加载出错的资源路径列表。
		 */		
		public function get errorUrlList():Array
		{
			var rlt:Array = [];
			var list:Array = errorList;
			
			for each(var loader:ILoader in list)
			{
				ArrayUtil.push(rlt, loader.fullUrl);
			}
			
			return rlt;
		}
		
		/**
		 * 设置加载完成时的回调函数。
		 * @param callback 回调函数，其形式为：function callback(queue:LoaderQueue):void { }。
		 */		
		public function setLoadCallback(callback:Function):void
		{
			if(callback != null) m_callback = callback;
		}
		
		/**
		 * 设置进度变更时的回调函数。
		 * @param callback 回调函数，其形式为：function callback(bytesLoaded:int, bytesTotal:int):void { }。
		 */		
		public function setProgressCallback(callback:Function):void
		{
			if(callback != null) m_progressCallback = callback;
		}
		
		/**
		 * 添加资源路径，由队列自动创建加载器进行加载。
		 * @param file 资源文件
		 * @param root 资源根目录
		 * @param managed 指示加载器是否受 LoaderMgr 管理。
		 * 
		 */		
		public function addFile(file:String, root:String = "", managed:Boolean = true):ILoader
		{
			var ext:String = CacheUtil.getExtension(file);
			var cls:Class = Extension_Loader_Class[ext];
			
			if(cls)
			{
				var loader:ILoader = new cls(file, root, managed);
				
				addLoader(loader);
				
				return loader;
			}
			else
			{
				throw new Error("没有找到此文件资源对应的加载器，请通过 registeNewType(String, Class) 方法注册对应的加载器。");
			}
		}
		
		/**
		 * 添加资源加载器到队列中进行加载。
		 * @param loader 资源加载器。
		 * 
		 */		
		public function addLoader(loader:ILoader):void
		{
			ArrayUtil.push(m_loaderList, loader);
			
			m_loaderCount = m_loaderList.length;
		}
		
		/**
		 * 队列开始加载。
		 * @param callback 回调函数，其形式为：function callback(queue:LoaderQueue):void { }。
		 */		
		public function start(callback:Function = null):void
		{
			setLoadCallback(callback);
			
			if(m_loaderCount != 0) tryLoadNext();
		}
		
		/** @private */
		protected function tryLoadNext():void
		{
			while(m_loadingList.length < m_maxSyncLoading && m_loaderList.length > 0)
			{
				var loader:ILoader = m_loaderList.shift() as ILoader;
				
				ArrayUtil.push(m_loadingList, loader);
				
				loader.addEventListener(JsionEvent.COMPLETE, __loaderCompleteHandler);
				loader.addEventListener(JsionEvent.ERROR, __loaderErrorHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, __progressHandler);
				
				loader.loadAsync();
			}
			
			tryLoadComplete();
		}
		
		/** @private */
		protected function __loaderCompleteHandler(e:JsionEvent):void
		{
			// TODO Auto Generated method stub
			var loader:ILoader = e.currentTarget as ILoader;
			
			ArrayUtil.remove(m_loadingList, loader);
			
			m_completeList.put(loader.urlKey, loader);
			
			tryLoadNext();
			
			dispatchEvent(new JsionEvent(JsionEvent.CHANGED));
		}
		
		private function __loaderErrorHandler(e:JsionEvent):void
		{
			// TODO Auto Generated method stub
			var loader:ILoader = e.currentTarget as ILoader;
			
			m_errorList.put(loader.urlKey, loader);
			
			tryLoadNext();
			
			dispatchEvent(new JsionEvent(JsionEvent.CHANGED));
		}
		
		/** @private */
		protected function __progressHandler(e:ProgressEvent):void
		{
			if(m_progressCallback != null) m_progressCallback(e.bytesLoaded, e.bytesTotal);
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function tryLoadComplete():void
		{
			if(m_loadingList.length == 0 && m_loaderList.length == 0 && 
				(m_completeList.size != 0 || m_errorList.size != 0))
			{
				if(m_errorList.size > 0) dispatchEvent(new JsionEvent(JsionEvent.ERROR));
				
				if(m_callback != null) m_callback(this);
				
				dispatchEvent(new JsionEvent(JsionEvent.COMPLETE));
			}
		}
		
		/**
		 * 获取资源文件对应加载器
		 * @param file 资源文件
		 */		
		public function getLoader(file:String):ILoader
		{
			return m_completeList.get(CacheUtil.path2Key(file)) || m_errorList.get(CacheUtil.path2Key(file));
		}
		
		/**
		 * 获取资源文件内容
		 * @param file 资源文件
		 */		
		public function getContent(file:String):*
		{
			var loader:ILoader = getLoader(file);
			
			if(loader) return loader.data;
			
			return null;
		}
		
		/**
		 * 通过资源文件获取 ByteArray 对象字节流
		 * @param file 资源文件
		 */		
		public function getByteArray(file:String):ByteArray
		{
			return getContent(file) as ByteArray;
		}
		
		/**
		 * 通过资源文件获取文本
		 * @param file 资源文件
		 * @return 
		 * 
		 */		
		public function getText(file:String):String
		{
			return getContent(file) as String;
		}
		
		/**
		 * 通过资源文件获取 XML 对象。
		 * @param file 资源文件
		 */		
		public function getXML(file:String):XML
		{
			return getContent(file) as XML;
		}
		
		/**
		 * 通过资源文件获取 BitmapData 对象。
		 * @param file 资源文件
		 */		
		public function getBitmapData(file:String):BitmapData
		{
			return getContent(file) as BitmapData;
		}
		
		/**
		 * 通过资源文件获取 Bitmap 对象。
		 * @param file 资源文件
		 * @param cloneBMD 指示是否使用克隆的 BitmapData 对象
		 */		
		public function getBitmap(file:String, cloneBMD:Boolean = true):Bitmap
		{
			var bmd:BitmapData = getBitmapData(file);
			
			if(bmd)
			{
				if(cloneBMD)
				{
					return new Bitmap(bmd.clone(), PixelSnapping.AUTO, true);
				}
				
				return new Bitmap(bmd, PixelSnapping.AUTO, true);
			}
			
			return null;
		}
		
		/**
		 * 通过资源文件获取显示对象
		 * @param file 资源文件
		 * @param cloneBMD 指示是否使用克隆的 BitmapData 对象
		 */		
		public function getDisplayObject(file:String, cloneBMD:Boolean = true):DisplayObject
		{
			var obj:Object = getContent(file);
			
			if(obj is BitmapData)
			{
				return getBitmap(file, cloneBMD);
			}
			
			return obj as DisplayObject;
		}
		
		/**
		 * 通过资源文件获取 Assembly 对象。
		 * @param file 资源文件
		 */		
		public function getAssembly(file:String):Assembly
		{
			return getContent(file) as Assembly;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_loaderList);
			m_loaderList = null;
			
			DisposeUtil.free(m_loadingList);
			m_loadingList = null;
			
			DisposeUtil.free(m_completeList);
			m_completeList = null;
			
			DisposeUtil.free(m_errorList);
			m_errorList = null;
			
			m_callback = null;
			
			m_progressCallback = null;
			
			m_loaderCount = 0;
			
			super.dispose();
		}
	}
}