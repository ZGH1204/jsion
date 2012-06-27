package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import jsion.Cache;
	import jsion.IDispose;
	import jsion.loaders.ILoader;
	import jsion.loaders.JsionLoader;
	import jsion.loaders.LoaderQueue;
	import jsion.loaders.LoaderQueue2;
	import jsion.utils.DisposeUtil;
	
	public class LoadingView extends Sprite implements IDispose
	{
		private var m_progressView:ProgressView;
		
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
			m_progressView = new ProgressView();
			addChild(m_progressView);
			
			m_progressView.x = (m_stage.stageWidth - m_progressView.width) / 2;
			m_progressView.y = (m_stage.stageHeight - m_progressView.height) / 2 + 150;
			
			m_progressView.setCallback(progressCompleteCallback);
			
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
				
				var loader:JsionLoader = m_queue.addFile(libPath, m_libRoot, false) as JsionLoader;
				
				loader.setURLVariables("v", Cache.version);
			}
			
			m_queue.setProgressCallback(progressCallback);
			
			//m_queue.start(loadCallback);
			m_queue.start();
		}
		
		private function progressCompleteCallback():void
		{
			// TODO Auto Generated method stub
			
			loadCallback(m_queue);
		}
		
		private function progressCallback(bytesLoaded:int, bytesTotal:int):void
		{
			var loading:int = m_queue.completeCount + m_queue.errorCount + 1;
			
			//trace("正在加载第", loading + "/" + m_queue.loaderCount, "个", "已加载：", bytesLoaded, "\t\t\t需加载：", bytesTotal);
			
			m_progressView.updateProgress(bytesLoaded, bytesTotal);
		}
		
		private function loadCallback(queue:LoaderQueue):void
		{
			DisposeUtil.free(m_progressView);
			m_progressView = null;
			
			var mainFns:Array = String(m_config.@Mains).split(",");
			
			if(mainFns.length == 0)
			{
				throw new Error("游戏启动主函数未定义!");
				return;
			}
			
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
			
			DisposeUtil.free(this);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_progressView);
			m_progressView = null;
			
			DisposeUtil.free(m_queue);
			m_queue = null;
			
			m_stage = null;
			
			m_config = null;
		}
	}
}