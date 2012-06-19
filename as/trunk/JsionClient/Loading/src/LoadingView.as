package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	
	import jsion.IDispose;
	import jsion.loaders.LoaderQueue;
	import jsion.loaders.LoaderQueue2;
	
	public class LoadingView extends Sprite implements IDispose
	{
		private var m_stage:Stage;
		
		private var m_config:XML;
		
		
		
		private var m_libRoot:String;
		
		
		
		private var m_queue:LoaderQueue;
		
		public function LoadingView(stg:Stage, config:XML)
		{
			super();
			
			m_stage = stg;
			
			m_config = config;
			
			initialize();
		}
		
		private function initialize():void
		{
			m_libRoot = String(m_config.@LibRoot);
			
			var loadingMode:int = int(m_config.@LoadingMode);
			
			if(loadingMode == 1)
			{
				m_queue = new LoaderQueue();
			}
			else
			{
				m_queue = new LoaderQueue2();
			}
			
			var libXL:XMLList = m_config..Loading;
			
			for each(var libXml:XML in libXL)
			{
				var libPath:String = String(libXml.@libPath);
				
				m_queue.addFile(libPath, m_libRoot, false);
			}
			
			m_queue.setProgressCallback(progressCallback);
			
			m_queue.start(loadCallback);
		}
		
		private function progressCallback(bytesLoaded:int, bytesTotal:int):void
		{
			var loading:int = m_queue.completeCount + m_queue.errorCount + 1;
			
			trace("正在加载第", loading + "/" + m_queue.loaderCount, "个", "已加载：", bytesLoaded, "\t\t\t需加载：", bytesTotal);
		}
		
		private function loadCallback(queue:LoaderQueue):void
		{
			var mainFns:Array = String(m_config.@Mains).split(",");
			
			for each(var fnStr:String in mainFns)
			{
				if(ApplicationDomain.currentDomain.hasDefinition(fnStr))
				{
					var fn:Function = ApplicationDomain.currentDomain.getDefinition(fnStr) as Function;
					
					if(fn != null) fn(m_stage, m_config, queue);
				}
				else
				{
					trace("函数", fnStr, "未定义!");
				}
			}
		}
		
		public function dispose():void
		{
			m_stage = null;
			
			m_config = null;
		}
	}
}