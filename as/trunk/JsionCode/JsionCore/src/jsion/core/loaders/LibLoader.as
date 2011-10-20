package jsion.core.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jsion.core.events.JLoaderEvent;
	import jsion.core.events.JLoaderProgressEvent;
	import jsion.utils.JUtil;
	
	/**
	 * 嵌入程序域完成时分派,仅SwcLoader和LibLoader发生.
	 * @eventType jsion.core.events.JLoaderEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="embedComplete", type="jsion.core.events.JLoaderEvent")]
	/**
	 * <p>未加密类库的加载类(swf格式的类库)</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JCore 1
	 * 
	 */	
	public class LibLoader extends BinaryLoader
	{
		/** @private */
		protected var _libLoader:Loader;
		/** @private */
		protected var _embed:Boolean;
		/** @private */
		protected var _embedCallback:Function;
		/** @private */
		protected var _waitEmbedBytes:ByteArray;
		
		private var cacheBytes:ByteArray;
		
		public function LibLoader(url:String, cfg:Object = null)
		{
			_embed = false;
			super(url, cfg);
		}
		
		/** @private */
		override protected function load():void
		{
			if(_isComplete || _isLoading) return;
			
			cacheBytes = Cache.loadData(url, _cacheInMemory);
			
			if(cacheBytes)
			{
				JUtil.addEnterFrame(__loadCompletedAsyncHandler);
			}
			else
			{
				super.load();
			}
		}
		
		private function __loadCompletedAsyncHandler(e:Event):void
		{
			JUtil.removeEnterFrame(__loadCompletedAsyncHandler);
			
			onOpenHandler(null);
			onProgressHandler(new JLoaderProgressEvent(JLoaderProgressEvent.Progress, cacheBytes.length * 0.999, cacheBytes.length));
			loadInDomain(cacheBytes);
			cacheBytes = null;
		}
		
		/** @private */
		override protected function onCompleteHandler(e:Event):void
		{
			removeLoadEvent(_loader);
			removeBytesTotalEvent(_loader);
			
			_content = decrypt(_loader.data as ByteArray);
			
			Cache.cacheData(url, _content, _cacheInMemory);
			
			if(autoEmbed == false)
			{
				_waitEmbedBytes = _content as ByteArray;
				_waitEmbedBytes.position = 0;
			}
			
			super.onCompleteHandler(e);
			
			if(autoEmbed) loadInDomain(_content as ByteArray);
		}
		
		/** @private */
		protected function loadInDomain(bytes:ByteArray):void
		{
			var oldPos:uint = bytes.position;
			
			_content = bytes;
			
			_libLoader = new Loader();
			
			_libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler, false, int.MAX_VALUE);
			
			_libLoader.loadBytes(bytes, _context as LoaderContext);
			
			bytes.position = oldPos;
		}
		
		override public function embedInDomain(embedCallback:Function = null):void
		{
			if(_embed || autoEmbed)
			{
				if(embedCallback != null) embedCallback(this);
				return;
			}
			
			if(_waitEmbedBytes)
			{
				_embedCallback = embedCallback;
				
				loadInDomain(_waitEmbedBytes);
				
				_waitEmbedBytes = null;
			}
		}
		
		private function __completeHandler(e:Event):void
		{
			_embed = true;
			
			_libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
			
			if(_embedCallback != null) _embedCallback(this);
			
			dispatchEvent(new JLoaderEvent(JLoaderEvent.EmbedComplete));
		}
		
		/** @private */
		override protected function setContent(data:*):void
		{
			
		}
		
		override public function dispose():void
		{
			_waitEmbedBytes = null;
			_embedCallback = null;
			cacheBytes = null;
			
			if(_libLoader)
			{
				if(_libLoader.contentLoaderInfo)
					_libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				//_libLoader.unloadAndStop();
			}
			_libLoader = null;
			
			super.dispose();
		}
	}
}