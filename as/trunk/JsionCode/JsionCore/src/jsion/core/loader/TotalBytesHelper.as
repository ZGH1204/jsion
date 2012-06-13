package jsion.core.loader
{
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;
	
	internal class TotalBytesHelper implements IDispose
	{
		private var m_list:Array;
		
		private var m_errorList:HashMap;
		
		private var m_callback:Function;
		
		private var m_totalBytes:int;
		
		private var m_maxLoading:int;
		
		private var m_loadingList:Array;
		
		public function TotalBytesHelper(list:Array, errorList:HashMap)
		{
			m_list = list;
			m_errorList = errorList;
			
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
				
				ArrayUtil.push(m_loadingList, loader);
				
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
				m_errorList.put(loader.urlKey, loader);
			}
			
			ArrayUtil.remove(m_loadingList, loader);
			
			tryLoadTotalBytesNext();
			
			tryComplete();
		}
		
		public function dispose():void
		{
			m_errorList = null;
			
			ArrayUtil.removeAll(m_list);
			m_list = null;
			
			ArrayUtil.removeAll(m_loadingList);
			m_loadingList = null;
			
			m_callback = null;
		}
	}
}