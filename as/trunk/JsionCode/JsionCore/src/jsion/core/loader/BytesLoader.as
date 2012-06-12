package jsion.core.loader
{
	import flash.events.ErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	public class BytesLoader extends JsionLoader
	{
		protected var m_urlLoader:URLLoader;
		
		public function BytesLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_urlLoader = new URLLoader();
			m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			addEventListener(ErrorEvent.ERROR, __errorHandler);
		}
		
		private function __errorHandler(e:ErrorEvent):void
		{
			LoaderMgr.ErrorHandler.error(this);
		}
		
		override protected function load():void
		{
			super.load();
			
			listenLoadEvent(m_urlLoader);
			m_urlLoader.load(m_request);
		}
		
		override public function cancel():void
		{
			if(m_status == LOADING)
			{
				removeLoadEvent(m_urlLoader);
				if(m_urlLoader) m_urlLoader.close();
			}
			
			super.cancel();
		}
		
		override protected function onCompleted():void
		{
			if(m_data == null) m_data = m_urlLoader.data;
			
			super.onCompleted();
		}
		
		override public function dispose():void
		{
			LoaderMgr.removeLoader(this);
			
			removeLoadEvent(m_urlLoader);
			m_urlLoader = null;
			
			super.dispose();
		}
	}
}