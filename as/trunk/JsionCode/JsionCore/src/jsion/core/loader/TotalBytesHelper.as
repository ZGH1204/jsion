package jsion.core.loader
{
	import jsion.IDispose;
	
	internal class TotalBytesHelper implements IDispose
	{
		private var m_list:Array;
		
		private var m_addToErrorListFn:Function;
		
		private var m_callback:Function;
		
		private var m_totalBytes:int;
		
		private var m_maxLoading:int;
		
		private var m_loadingList:Array;
		
		public function TotalBytesHelper(list:Array, addToErrorListFn:Function)
		{
			m_list = list;
			m_addToErrorListFn = addToErrorListFn;
			
			m_totalBytes = 0;
			m_maxLoading = 1;
			m_loadingList = [];
		}
		
		public function start(callback:Function):void
		{
			m_callback = callback;
			
			tryLoadTotalBytesNext();
		}
		
		private function tryLoadTotalBytesNext():void
		{
			while(m_loadingList.length < m_maxLoading && m_list.length > 0)
			{
				var loader:ILoader = m_list.shift() as ILoader;
				
				pushLoadingLoader(loader);
				
				loader.loadTotalBytes(loadCallback);
			}
		}
		
		private function tryComplete():void
		{
			if(m_loadingList.length == 0 && m_list.length == 0)
			{
				if(m_callback != null) m_callback(m_totalBytes);
			}
		}
		
		private function loadCallback(loader:ILoader, totalBytes:int):void
		{
			if(totalBytes > 0)
			{
				m_totalBytes += totalBytes;
			}
			else
			{
				m_addToErrorListFn(loader);
			}
			
			removeLoadingLoader(loader);
			
			tryLoadTotalBytesNext();
			
			tryComplete();
		}
		
		public function pushLoadingLoader(loader:ILoader):void
		{
			if(m_loadingList.indexOf(loader) == -1)
			{
				m_loadingList.push(loader);
			}
		}
		
		public function removeLoadingLoader(loader:ILoader):void
		{
			var index:int = m_loadingList.indexOf(loader);
			
			if(index == -1) return;
			
			m_loadingList.splice(index, 1);
		}
		
		public function dispose():void
		{
			if(m_list) m_list.splice(0);
			m_list = null;
			
			if(m_loadingList) m_loadingList.splice(0);
			m_loadingList = null;
			
			m_callback = null;
			
			m_addToErrorListFn = null;
		}
	}
}