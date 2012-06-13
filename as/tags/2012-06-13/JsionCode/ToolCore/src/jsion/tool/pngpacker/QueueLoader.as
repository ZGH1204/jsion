package jsion.tool.pngpacker
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.IDispose;
	
	public class QueueLoader extends EventDispatcher implements IDispose
	{
		private var m_filesList:Array;
		
		private var m_callback:Function;
		
		private var m_loader:Loader;
		
		private var m_bmdList:Array;
		
		public function QueueLoader()
		{
			m_filesList = [];
			m_bmdList = [];
		}
		
		public function add(f:File):void
		{
			m_filesList.push(f);
		}
		
		public function start(callback:Function):void
		{
			m_callback = callback;
			
			tryStartNext();
		}
		
		private function tryStartNext():void
		{
			if(m_loader)
			{
				m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				m_loader.unloadAndStop();
				m_loader = null;
			}
			
			if(m_filesList.length > 0)
			{
				m_loader = new Loader();
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler);
				
				var f:File = m_filesList.shift() as File;
				
				while(f.exists == false && m_filesList.length > 0)
				{
					f = m_filesList.shift() as File;
				}
				
				if(f.exists)
				{
					var bytes:ByteArray = readBytes(f);
					
					m_loader.loadBytes(bytes);
				}
				else
				{
					tryComplete();
				}
			}
			else
			{
				tryComplete();
			}
		}
		
		private function tryComplete():void
		{
			if(m_filesList.length == 0)
			{
				if(m_callback != null) m_callback(m_bmdList);
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function readBytes(f:File):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			return bytes;
		}
		
		private function __completeHandler(e:Event):void
		{
			var bmp:Bitmap = Bitmap(m_loader.content);
			
			if(bmp) m_bmdList.push(bmp.bitmapData.clone());
			
			tryStartNext();
		}
		
		public function dispose():void
		{
			if(m_loader)
			{
				m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				m_loader.unloadAndStop();
			}
			
			m_filesList = null;
			
			m_loader = null;
			
			m_bmdList = null;
			
			m_callback = null;
		}
	}
}