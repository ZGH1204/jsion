package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.startup.Startuper;
	
	[SWF(width="760", height="690", frameRate="30", backgroundColor="#FFFFFF")]
	public class Loader extends Sprite
	{
		private var m_loadingView:SmallLoadingAsset;
		
		private var m_startuper:Startuper;
		
		public function Loader()
		{
			if(stage)
			{
				initialize();
			}
			else 
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			}
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			initialize();
		}
		
		private function initialize():void
		{
			m_loadingView = new SmallLoadingAsset();
			
			addChild(m_loadingView);
			
			m_loadingView.x = (stage.stageWidth - m_loadingView.width) / 2;
			m_loadingView.y = (stage.stageHeight - m_loadingView.height) / 2;
			
			m_startuper = new Startuper(stage);
			
			m_startuper.startup("config.xml", loadCallback);
		}
		
		private function loadCallback():void
		{
			if(m_loadingView && m_loadingView.parent)
			{
				m_loadingView.parent.removeChild(m_loadingView);
				
				m_loadingView = null;
			}
		}
	}
}