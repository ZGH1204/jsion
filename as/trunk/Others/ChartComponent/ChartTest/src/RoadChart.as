package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import road.index.Analyser;
	import road.index.CursorManager;
	import road.v.core.DVBase;
	
	[SWF(width="550", height="400", backgroundColor="#FFFFFF")]
	public class RoadChart extends DVBase
	{
		private var _analyser:Analyser;
		
		public function RoadChart()
		{
			if(root)
			{
				var parameters:Object = root.loaderInfo.parameters;
				if(parameters["crossdomain"])
				{
					Security.loadPolicyFile(parameters["crossdomain"].toString());
				}
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
			initExternalInterface();
			initEvent();
		}
		
		private function init():void
		{
			CursorManager.getInstance().root = this;
			
			_analyser = new Analyser();
			addChild(_analyser);
			
			_analyser.x = 5;
			
			_analyser.width = stage.stageWidth - 10;
			_analyser.height = stage.stageHeight;
		}
		
		private function initExternalInterface():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("loadDataByStartDate", _analyser.loadDataByStartDate);
				ExternalInterface.addCallback("loadDataByEndDate", _analyser.loadDataByEndDate);
				ExternalInterface.addCallback("loadDataByCustom", _analyser.loadDataByCustom);
				ExternalInterface.addCallback("loadDataByStartAndEndDate", _analyser.loadDataByStartAndEndDate);
				ExternalInterface.addCallback("loadDataByStartEndDateAndCustom", _analyser.loadDataByStartEndDateAndCustom);
			}
		}
		
		private function initEvent():void
		{
			addEventListener(Event.RESIZE, __resizeHandler);
			stage.addEventListener(Event.RESIZE, __resizeHandler);
		}
		
		private function __resizeHandler(e:Event):void
		{
			_analyser.width = stage.stageWidth - 10;
			_analyser.height = stage.stageHeight;
		}
	}
}