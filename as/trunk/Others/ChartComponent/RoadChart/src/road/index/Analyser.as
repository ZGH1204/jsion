package road.index
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.lib.utils.DateFormatter;
	import road.v.core.DVBase;

	public class Analyser extends DVBase
	{
		private var _dataAccessor:DataAccessor;
        private var _chart:Chart;
        private var _slider:Slider;
        private var _statusBar:StatusBar;
        private var _txtRange:TextField;
        
        private var _statusBarOldWidth:Number;
        
        private var _dates:Array;
        private var _labels:Array;
        
        private var paramKeys:Array;
        
        private var _currentRange:Point;
        private var _dragStartRange:Point;
        
        private const HEIGHT_FOOTER:Number = 20;
        private const HEIGHT_MIDDLE_GAP:Number = 8;
        private const HEIGHT_PERCENT_SLIDER:Number = 0.13;
        
		public function Analyser()
		{
			addEventListener(Event.ADDED_TO_STAGE, __addToStage);
		}
		
		private function init():void
		{
			_chart = new Chart();
            addChild(_chart);
            
            _slider = new Slider();
            addChild(_slider);
            
            var tf:TextFormat = new TextFormat();
            tf.color = 0;
            tf.size = 12;
            tf.font = "微软雅黑";
            _txtRange = new TextField();
            addChild(_txtRange);
            _txtRange.defaultTextFormat = tf;
            _txtRange.autoSize = "left";
            _txtRange.y = 2;
            _txtRange.x = 0;
            _txtRange.mouseEnabled = false;
            
            showLoading();
            
//            this.width = 1000;
//            this.height = 600;
		}
		
		private function __addToStage(e:Event):void
		{
			getParams();
			init();
			initEvent();
			initData();
		}
		
		private function initData():void
		{
			_dataAccessor = new DataAccessor();
			
			_dataAccessor.addEventListener(DataEvent.INDEXES_LOADED, doDataLoaded);
            _dataAccessor.addEventListener(DataEvent.ERROR, doDataLoadError);
			
			
			loadData();
			//测试时注释掉上面一句，将下面的注释语句打开
//			_dataAccessor.loadIndexes(paramKeys, ["0"], ["2006-06-01|2007-05-01"]);
			ConfigManager.setTimeInterval(loadData);
		}
		
		public function loadData():void
		{
			_dataAccessor.loadData(paramKeys,getDateString(ConfigManager.START_DATA_DATE), getDateString(ConfigManager.showEndDate));
		}
		
		public function loadDataByStartDate(startDate:String):void
		{
			var sd:Date = DateFormatter.parse(startDate, "YYYY-MM-DD hh:mm:ss");
			if(isNaN(sd.fullYear)) return;
			ConfigManager.START_DATA_DATE = sd;
			loadData();
			resetTimeInterval();
		}
		
		public function loadDataByEndDate(endDate:String):void
		{
			var ed:Date = DateFormatter.parse(endDate, "YYYY-MM-DD hh:mm:ss");
			if(isNaN(ed.fullYear)) return;
			ConfigManager.showEndDate = ed;
			loadData();
			resetTimeInterval();
		}
		
		public function loadDataByCustom(custom:String):void
		{
			if(custom == null || custom == "null") return;
			
			ConfigManager.customParam = custom;
			loadData();
			resetTimeInterval();
		}
		
		public function loadDataByStartAndEndDate(startDate:String, endDate:String):void
		{
			var sd:Date = DateFormatter.parse(startDate, "YYYY-MM-DD hh:mm:ss");
			var ed:Date = DateFormatter.parse(endDate, "YYYY-MM-DD hh:mm:ss");
			
			if(isNaN(sd.fullYear) || isNaN(ed.fullYear)) return;
			
			ConfigManager.START_DATA_DATE = sd;
			ConfigManager.showEndDate = ed;
			loadData();
			resetTimeInterval();
		}
		
		public function loadDataByStartEndDateAndCustom(startDate:String, endDate:String, custom:String):void
		{
			var sd:Date = DateFormatter.parse(startDate, "YYYY-MM-DD hh:mm:ss");
			var ed:Date = DateFormatter.parse(endDate, "YYYY-MM-DD hh:mm:ss");
			
			if(isNaN(sd.fullYear) || isNaN(ed.fullYear)) return;
			if(custom == null || custom == "null") return;
			
			ConfigManager.START_DATA_DATE = sd;
			ConfigManager.showEndDate = ed;
			ConfigManager.customParam = custom;
			loadData();
			resetTimeInterval();
		}
		
		public function resetTimeInterval():void
		{
			ConfigManager.clearTimeInterval();
			ConfigManager.setTimeInterval(loadData);
		}
		
		private function getParams():void
		{
			paramKeys = [];
			if(root)
			{
				var parameters:Object = root.loaderInfo.parameters;
				
				if(parameters["keys"])
				{
					paramKeys = parameters["keys"].split(",");
					DataAccessor.gateway = parameters["gateway"].toString();
					ConfigManager.minShowUnit = parameters["type"].toString();
					ConfigManager.ChartTitle = parameters["charttitle"].toString();
					ConfigManager.showEndDate = DateFormatter.parse(parameters["showenddate"].toString(),"YYYY-MM-DD hh:mm:ss");
					ConfigManager.START_DATA_DATE = DateFormatter.parse(parameters["datastartdate"].toString(),"YYYY-MM-DD hh:mm:ss");
				}
				if(parameters["timeinterval"])
					ConfigManager.TimeInterval = Number(parameters["timeinterval"]);
				if(parameters["mindistance"])
					ConfigManager.minShowDistance = Number(parameters["mindistance"].toString());
				if(parameters["initshowdistance"])
					ConfigManager.initShowDistance = Number(parameters["initshowdistance"]);
				if(parameters["graphcolors"])
					ConfigManager.COLORS_OF_GRAPHS = String(parameters["graphcolors"]).split("|");
				if(parameters["showintactlabel"])
					ConfigManager.showIntactLabel = Boolean(int(parameters["showintactlabel"]));
				if(parameters["showverticalsplitline"])
					ConfigManager.showVerticalSplitLine = Boolean(int(parameters["showverticalsplitline"]));
				if(parameters["showhorizontalsplitline"])
					ConfigManager.showHorizontalSplitLine = Boolean(int(parameters["showhorizontalsplitline"]));
				if(parameters["custom"])
					ConfigManager.customParam = String(parameters["custom"]);
			}
			else
			{
				paramKeys.push("买房");
				paramKeys.push("买车");
			}
		}
		
		private function initEvent():void
		{
			_chart.addEventListener(Chart.EVENT_START_DRAG, doChartStartDrag);
            _chart.addEventListener(Chart.EVENT_DRAGGING, doChartDragging);
            _chart.addEventListener(Chart.EVENT_END_DRAG, doChartEndDrag);
			
			_slider.addEventListener(Slider.EVENT_RANGE_CHANGE, __sliderRangeChange);
			_slider.addEventListener(Slider.EVENT_RANGE_SELECTING, __sliderRangeSelecting);
			_slider.addEventListener(Slider.EVENT_RANGE_STABLE, __sliderRangeStable);
		}
		
		private function getDateString(d:Date):String
		{
			var year:int = d.fullYear;
			var month:int = d.month + 1;
			var date:int = d.date;
			var hour:int = d.hours;
			var minutes:int = d.minutes;
			var second:int = d.seconds;
			
			var result:String = year + "-" + month + "-" + date + " " + hour + ":" + minutes + ":" + second;
			
			return result;
		}
		
		private function showLoading():void
		{
            _statusBar = new StatusBar();
            addChild(_statusBar);
            
            _statusBarOldWidth = _statusBar.width;
			
            refreshStatusBar();
            _statusBar.gotoAndStop("loading");
		}
		
		private function hideLoading():void
		{
			if(_statusBar && _statusBar.parent)
			{
				_statusBar.parent.removeChild(_statusBar);
				_statusBar = null;
			}
		}
		
		private function errorLoading():void
		{
			_statusBar.gotoAndStop("error");
		}
		
		private function refreshStatusBar():void
		{
			if(_statusBar)
			{
				var g:Graphics = _statusBar.graphics;
				g.clear();
				
				g.beginFill(0xAAAAAA,0.2);
				g.drawRect(-(_width + 10) / 2, -(_height) / 2, _width + 10 + _statusBarOldWidth, _height);
				g.endFill();
				
				_statusBar.x = (_width + 20 - _statusBarOldWidth) / 2;
            	_statusBar.y = (_height - 20) / 2;
			}
		}
		
		private function doChartStartDrag(e:Event):void
		{
			_dragStartRange = _currentRange.clone();
		}
		
		private function doChartDragging(e:DataEvent):void
		{
			var d:Number = e.data as Number;
			_slider.moveRange(_dragStartRange, d);
		}
		
		private function doChartEndDrag(e:Event):void
		{
			refreshNews();
		}
		
		private function refreshChartDataByRange() : void
		{
			var ds:Object = {};
			ds.dates = _dates.slice(_currentRange.x, _currentRange.y + 1);
			ds.dateGroups = [ds.dates];
			
			var array1:Array = [];
			var array2:Array = [];
			
			for each(var obj:Object in _data)
			{
				array1.push(obj.userIndexes.slice(_currentRange.x, _currentRange.y + 1));
				array2.push(obj.mediaIndexes.slice(_currentRange.x, _currentRange.y + 1));
			}
			
			ds.userValueGroups = array1;
			ds.mediaValueGroups = array2;
			ds.labels = _labels;
			_chart.data = ds;
		}
		
		private function refreshRangeText(range:Point) : void
		{
			if(ConfigManager.minShowUnit == "5分钟")
			{
				_txtRange.text = DateFormatter.format(_dates[range.x], "hh:mm") + " 至 " + DateFormatter.format(_dates[range.y], "hh:mm");
				return;
			}
			_txtRange.text = DateFormatter.format(_dates[range.x], ConfigManager.getFormatString()) + " 至 " + DateFormatter.format(_dates[range.y], ConfigManager.getFormatString());
		}
		
		private function __sliderRangeChange(e:Event):void
		{
			var p:Point = _slider.currentRange.clone();
			
			if(_currentRange && _currentRange.x == p.x && _currentRange.y == p.y) return;
			
			_currentRange = p;
			refreshChartDataByRange();
			refreshRangeText(_currentRange);
		}
		
		private function __sliderRangeSelecting(e:Event):void
		{
			refreshRangeText(_slider.currentRange);
		}
		
		private function __sliderRangeStable(e:Event):void
		{
			refreshNews();
		}
		
		private function refreshNews():void
		{
			
		}
		
		private function doDataLoaded(de:DataEvent) : void
		{
			_data = de.data as Array;
			
			setupData();
			
			hideLoading();
			
			_currentRange = null;
			
			__sliderRangeChange(null);
		}
		
		private function doDataLoadError(de:DataEvent) : void
		{
			errorLoading();
		}
		
		private function setupData():void
		{
			var chartData:Object = {};
			_dates = getDates()
			chartData.dates = _dates;
			chartData.dateGroups = getDateGroups();
			chartData.userValueGroups = getUserValueGroups();
			chartData.mediaValueGroups = getMediaValueGroups();
			_labels = getLabels();
			chartData.labels = _labels;
			
			
			var sliderData:Object = {};
			sliderData.dates = _dates;
			sliderData.values = _data[0].userIndexes;
			
			
			_chart.data = chartData;
			
			_slider.data = sliderData;
		}
		
		private function getDates():Array
		{
			var array:Array = [];
			
			
//			var ed:Date = new Date;
//			ed = new Date(ed.fullYear,ed.month,ed.date - 1);
			
			var startTimeSpan:Number = ConfigManager.START_DATA_DATE.valueOf();
            var endTimeSpan:Number = ConfigManager.showEndDate.valueOf();
			if(ConfigManager.minShowUnit == "5分钟")
			{
				endTimeSpan = startTimeSpan + ConfigManager.DAY_TIME_VALUE;
			}
            
            var start:int = 0;
            var end:int = (endTimeSpan - startTimeSpan) / ConfigManager.getCalcValueByUnit() + 1;
            
            while(start < end)
            {
            	array.push(new Date(startTimeSpan + start * ConfigManager.getCalcValueByUnit()));
            	start++;
            }
            
            return array;
		}
		
		private function getDateGroups():Array
		{
			var dateGroups:Array = [];
			
//			var ed:Date = new Date;
//			ed = new Date(ed.fullYear,ed.month,ed.date - 1);
			
			for each(var obj:Object in _data)
			{
				var array:Array = [];
				
				var startTimeSpan:Number = ConfigManager.START_DATA_DATE.valueOf();
				var endTimeSpan:Number = ConfigManager.showEndDate.valueOf();
				
				var startIndex:int = 0;
				var count:int = (endTimeSpan - startTimeSpan) / ConfigManager.getCalcValueByUnit() + 1;
				
				while(startIndex < count)
				{
					array.push(new Date(startTimeSpan + startIndex * ConfigManager.getCalcValueByUnit()));
					startIndex++;
				}
				
				dateGroups.push(array);
			}
			
			return dateGroups;
		}
		
		//获取所有项的用户关注度
		private function getUserValueGroups():Array
		{
			var result:Array = [];
			
			for each(var obj:Object in _data)
			{
				result.push(obj.userIndexes);
			}
			
			return result;
		}
		
		//获取所有项的媒体关注度
		private function getMediaValueGroups():Array
		{
			var result:Array = [];
			
			for each(var obj:Object in _data)
			{
				result.push(obj.mediaIndexes);
			}
			
			return result;
		}
		
		private function getLabels():Array
		{
			var result:Array = [];
			if(_data.length > 1)
			{
				var i:int = 0;
				if(_data[0].area != _data[1].area)
				{
					while(i < _data.length)
					{
						result.push(_data[i].areaName);
						i++;
					}
				}
				else
				{
					while(i < _data.length)
					{
						result.push(_data[i].key);
						i++;
					}
				}
			}
			else
			{
				result.push(_data[0].key);
			}
			
			return result;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_chart.width = _width;
			_slider.width = _width;
			_slider.refreshBarPos();
			refreshStatusBar();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			var realHeight:Number = _height - HEIGHT_FOOTER - HEIGHT_MIDDLE_GAP;
			
			_chart.height = realHeight * (1 - HEIGHT_PERCENT_SLIDER);
			_slider.height = realHeight * HEIGHT_PERCENT_SLIDER;
			_slider.y = _chart.height + HEIGHT_MIDDLE_GAP;
			_slider.refreshBarPos();
			refreshStatusBar();
		}
	}
}