package jsion.core.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	
	import jsion.utils.DisposeUtil;

	public class BitmapDataLoader extends BytesLoader
	{
		protected var m_loader:Loader;
		
		public function BitmapDataLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		override protected function onCompleted():void
		{
			if(m_loader == null)
			{
				m_loader = new Loader();
				m_loader.loadBytes(m_urlLoader.data);
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
			}
			else
			{
				super.onCompleted();
			}
		}
		
		private function __embedInDomainHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			m_data = Bitmap(m_loader.content).bitmapData.clone();
			
			super.onCompleted();
		}
		
		override public function dispose():void
		{
			if(m_loader)
			{
				m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
				m_loader.unloadAndStop();
				DisposeUtil.free(m_loader);
				m_loader = null;
			}
			
			super.dispose();
		}
	}
}