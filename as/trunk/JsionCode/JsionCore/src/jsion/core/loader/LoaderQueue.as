package jsion.core.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.core.events.JsionEvent;
	import jsion.core.events.JsionEventDispatcher;
	import jsion.core.reflection.Assembly;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	
	public class LoaderQueue extends JsionEventDispatcher implements IDispose
	{
		private var m_maxSyncLoading:int;
		
		private var m_loaderList:Array;
		
		private var m_loadingList:Array;
		
		private var m_completeList:HashMap;
		
		private var m_errorList:HashMap;
		
		private var m_callback:Function;
		
		private var m_loaderCount:int;
		
		public function LoaderQueue(syncLoading:int = 1)
		{
			super();
			
			m_maxSyncLoading = syncLoading;
			
			m_loaderList = [];
			
			m_loadingList = [];
			
			m_completeList = new HashMap();
			
			m_errorList = new HashMap();
		}
		
		public function get maxSyncLoading():int
		{
			return m_maxSyncLoading;
		}
		
		public function set maxSyncLoading(value:int):void
		{
			m_maxSyncLoading = value;
			
			m_maxSyncLoading = Math.max(m_maxSyncLoading, 1);
		}
		
		public function get loaderCount():int
		{
			return m_loaderCount;
		}
		
		public function get completeCount():int
		{
			return m_completeList.size;
		}
		
		public function get errorCount():int
		{
			return m_errorList.size;
		}
		
		public function get hasError():Boolean
		{
			return m_errorList.size != 0;
		}
		
		public function get completeList():Array
		{
			return m_completeList.getValues();
		}
		
		public function get errorList():Array
		{
			return m_errorList.getValues();
		}
		
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
		
		public function addLoader(loader:ILoader):void
		{
			ArrayUtil.push(m_loaderList, loader);
			
			m_loaderCount = m_loaderList.length;
		}
		
		public function start(callback:Function = null):void
		{
			if(callback != null) m_callback = callback;
			
			if(m_loaderCount != 0) tryLoadNext();
		}
		
		private function tryLoadNext():void
		{
			while(m_loadingList.length < m_maxSyncLoading && m_loaderList.length > 0)
			{
				var loader:ILoader = m_loaderList.shift() as ILoader;
				
				ArrayUtil.push(m_loadingList, loader);
				
				loader.addEventListener(JsionEvent.COMPLETE, __loaderCompleteHandler);
				loader.addEventListener(JsionEvent.ERROR, __loaderErrorHandler);
				
				loader.loadAsync();
			}
			
			tryLoadComplete();
		}
		
		private function __loaderCompleteHandler(e:JsionEvent):void
		{
			// TODO Auto Generated method stub
			var loader:ILoader = e.currentTarget as ILoader;
			
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
		
		public function getLoader(file:String):ILoader
		{
			return m_completeList.get(JUtil.path2Key(file)) || m_errorList.get(JUtil.path2Key(file));
		}
		
		public function getContent(file:String):*
		{
			var loader:ILoader = getLoader(file);
			
			if(loader) return loader.data;
			
			return null;
		}
		
		public function getByteArray(file:String):ByteArray
		{
			return getContent(file) as ByteArray;
		}
		
		public function getText(file:String):String
		{
			return getContent(file) as String;
		}
		
		public function getXML(file:String):XML
		{
			return getContent(file) as XML;
		}
		
		public function getBitmapData(file:String):BitmapData
		{
			return getContent(file) as BitmapData;
		}
		
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
		
		public function getDisplayObject(file:String, cloneBMD:Boolean = true):DisplayObject
		{
			var obj:Object = getContent(file);
			
			if(obj is BitmapData)
			{
				return getBitmap(file, cloneBMD);
			}
			
			return obj as DisplayObject;
		}
		
		public function getAssembly(file:String):Assembly
		{
			return getContent(file) as Assembly;
		}
		
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
			
			m_loaderCount = 0;
			
			super.dispose();
		}
	}
}