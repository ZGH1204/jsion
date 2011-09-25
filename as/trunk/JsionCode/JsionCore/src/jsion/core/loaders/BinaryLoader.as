package jsion.core.loaders
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	/**
	 * <p>二进制数据流加载类</p>
	 * 
	 * @see JLoader
	 * 
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class BinaryLoader extends JLoader
	{
		protected var _loader:URLLoader;
		
		public function BinaryLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		override protected function configLoader():void
		{
			super.configLoader();
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		override protected function load():void
		{
			if(_managed == false || LoaderMonitor.getCanLoad(this))
			{
				super.load();
				
				if(_isLoading == false || _isComplete) return;
				
				addLoadEvent(_loader);
				
				try
				{
					_loader.load(_request);
				}
				catch(err:Error)
				{
					removeLoadEvent(_loader);
					removeBytesTotalEvent(_loader);
					throw err;
				}
			}
			else
			{
				LoaderMonitor.joinManaged(this);
			}
		}
		
		override public function stop():void
		{
			super.stop();
			
			if(_isLoading) return;
			
			try
			{
				removeLoadEvent(_loader);
				removeBytesTotalEvent(_loader);
				_loader.close();
			}
			catch(e:Error){}
		}
		
		override public function getBytesTotal():void
		{
			super.getBytesTotal();
			addBytesTotalEvent(_loader);
			
			try
			{
				_loader.load(_request);
			}
			catch(err:Error)
			{
				removeLoadEvent(_loader);
				removeBytesTotalEvent(_loader);
				throw err;
			}
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			setContent(_loader.data);
			super.onCompleteHandler(e);
		}
		
		protected function setContent(data:*):void
		{
			_content = decrypt(data as ByteArray)
		}
		
		override public function dispose():void
		{
			removeLoadEvent(_loader);
			removeBytesTotalEvent(_loader);
			_loader = null;
			super.dispose();
		}
	}
}