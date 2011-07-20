package road.index
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import road.lib.utils.DateFormatter;
	import road.v.core.DVBase;
	import road.v.core.Grid;
	import road.v.core.GridPlacement;
	import road.v.core.LineStyle;
	import road.v.graphs.AreaGraph;
	import road.v.graphs.GridBasedGraph;
	import road.v.graphs.LineGraph;
	
	public class Chart extends DVBase
	{
        public static const EVENT_START_DRAG:String = "startDrag";
        public static const EVENT_DRAGGING:String = "dragging";
        public static const EVENT_END_DRAG:String = "endDrag";
        
        private var _categoryGrid:ChartCategoryGrid;
        private var _userValueGrid:SpecialValueGrid;
        private var _mediaValueGrid:SpecialValueGrid;
        
        private var _userLabel:TextField;
//        private var _mediaLabel:TextField;
        private var _txtCurrentPointDate:TextField;
        
        private var _graphContainer:Sprite;
        private var _graphPointContainer:Sprite;
        private var _legend:Sprite;
        
        private var _mouseLayer:Sprite;
        
        private var _dragCursor:DragCursor;
        
        private var _unitTip:UnitTip;
        
        private var _userGraphs:Array;
        private var _mediaGraphs:Array;
        private var _graphPoints:Array;
        private var _rawFirstDates:Array;
        private var _labels:Array;
        private var _legendItems:Array;
        private var _legendPoints:Array;
        private var _legendKeyLabels:Array;
        private var _legendValueLabels:Array;
        
        
        private var _dates:Array;//起始日期到结束日期的所有日期数据
        private var _dateGroups:Array;//起始日期到结束日期的所有日期数据
        private var _userValueGroups:Array;//用户关注度值
        private var _mediaValueGroups:Array;//媒体关注度值
        
        private var _hideUnitTimeoutId:Number;
        private var _currentPointIndex:Number;
        private var _mouseStartMouseX:Number;
        
        private var _isUnitWeek:Boolean = false;
        private var _isDragging:Boolean = false;
        
        private const HEIGHT_HEADER:Number = 20;
        private const HEIGHT_CATEGORY_BAR:Number = 20;
        private const HEIGHT_PERCENT_MEDIA:Number = 0;//0.25;
        
        private const USER_VALUE_GRID_SPLIT:int = 6;
        private const MEDIA_VALUE_GRID_SPLIT:Number = 2;
        
        
        public static const COLORS_OF_GRAPHS:Array = [0xFFA333, 0x009149, 0x0058C6, 0xA918BA, 0x666633, 0xFF00CC];
        
        
		public function Chart()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
//			init(null);
		}
		
		
		private function init(e:Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
            
            initArray();
            
            initCategoryGrid();
            
            initUserValueGrid();
            
            initMediaValueGrid();
            
            initTextField();
            
            initContainers();
            
            initLayer();
		}
		
		private function initArray():void
		{
			_userGraphs = [];
            _mediaGraphs = [];
            _graphPoints = [];
            _legendItems = [];
            _legendPoints = [];
            _legendKeyLabels = [];
            _legendValueLabels = [];
		}
		
		private function initCategoryGrid():void
		{
			_categoryGrid = new ChartCategoryGrid();
            addChild(_categoryGrid);
            _categoryGrid.showAxisLine = false;
            _categoryGrid.showAxisLabel = true;
            _categoryGrid.showSplitLine = ConfigManager.showVerticalSplitLine;
            _categoryGrid.setStyle(Grid.SPLIT_LINE_STYLE, new LineStyle(15000804, 1, 1));
            _categoryGrid.setStyle(Grid.AXIS_LABEL_PADDING, 0);
            _categoryGrid.y = HEIGHT_HEADER;
		}
		
		private function initUserValueGrid():void
		{
			_userValueGrid = new SpecialValueGrid();
            addChild(_userValueGrid);
            _userValueGrid.showAxisLine = false;
            _userValueGrid.placement = GridPlacement.RIGHT;
            _userValueGrid.averageBit = 0;
            _userValueGrid.splitNumber = USER_VALUE_GRID_SPLIT;
            _userValueGrid.showSplitLine = ConfigManager.showHorizontalSplitLine;
            _userValueGrid.showAxisLabel = true;
            _userValueGrid.gapOfMax = 0.1;
            _userValueGrid.showLastSplitLine = false;
            _userValueGrid.showFirstAxisLabel = false;
            var textFormat:TextFormat = new TextFormat();
            textFormat.font = "Verdana";
            textFormat.bold = false;
            textFormat.size = 10;
            textFormat.color = 0x444444;
            _userValueGrid.setStyle(Grid.AXIS_LABEL_TEXT_FORMAT, textFormat);
            _userValueGrid.setStyle(Grid.SPLIT_LINE_STYLE, new LineStyle(0xE4E4E4, 1, 1));
            _userValueGrid.y = HEIGHT_HEADER;
		}
		
		private function initMediaValueGrid():void
		{
			_mediaValueGrid = new SpecialValueGrid();
            addChild(_mediaValueGrid);
            _mediaValueGrid.showAxisLine = false;
            _mediaValueGrid.placement = GridPlacement.RIGHT;
            _mediaValueGrid.averageBit = 0;
            _mediaValueGrid.splitNumber = MEDIA_VALUE_GRID_SPLIT;
            _mediaValueGrid.showSplitLine = true;
            _mediaValueGrid.showAxisLabel = true;
            _mediaValueGrid.gapOfMax = 0.1;
            _mediaValueGrid.showLastSplitLine = true;
            _mediaValueGrid.showFirstAxisLabel = false;
            var _loc_3:TextFormat = new TextFormat();
            _loc_3.font = "Verdana";
            _loc_3.bold = false;
            _loc_3.size = 10;
            _loc_3.color = 0x444444;
            _mediaValueGrid.setStyle(Grid.AXIS_LABEL_TEXT_FORMAT, _loc_3);
            _mediaValueGrid.setStyle(Grid.SPLIT_LINE_STYLE, new LineStyle(0xE4E4E4, 1, 1));
            //HEIGHT_PERCENT_MEDIA 变量不为0时改为true
            _mediaValueGrid.visible = false;
		}
		
		private function initTextField():void
		{
			var _loc_5:TextFormat = new TextFormat();
            _loc_5.color = 8947848;
            _loc_5.size = 12;
            _loc_5.font = "微软雅黑";
			_userLabel = new TextField();
            addChild(_userLabel);
            _userLabel.defaultTextFormat = _loc_5;
            _userLabel.text = ConfigManager.ChartTitle;
            _userLabel.x = 2;
            _userLabel.y = HEIGHT_HEADER + 2;
            _userLabel.mouseEnabled = false;
            
//            _mediaLabel = new TextField();
//            addChild(_mediaLabel);
//            _mediaLabel.defaultTextFormat = _loc_5;
//            _mediaLabel.text = "媒体关注度";
//            _mediaLabel.x = 2;
//            _mediaLabel.mouseEnabled = false;
            
            var _loc_6:TextFormat = new TextFormat();
            _loc_6.color = 0;
            _loc_6.size = 12;
            _loc_6.font = "微软雅黑";
            _txtCurrentPointDate = new TextField();
            addChild(_txtCurrentPointDate);
            _txtCurrentPointDate.defaultTextFormat = _loc_6;
            _txtCurrentPointDate.autoSize = "left";
            _txtCurrentPointDate.y = HEIGHT_HEADER + 2;
            _txtCurrentPointDate.mouseEnabled = false;
            _txtCurrentPointDate.visible = false;
		}
		
		private function initContainers():void
		{
            _graphContainer = new Sprite();
            addChild(_graphContainer);
            _graphContainer.y = HEIGHT_HEADER;
            
            _graphPointContainer = new Sprite();
            addChild(_graphPointContainer);
            _graphPointContainer.y = HEIGHT_HEADER;
            
            _legend = new Sprite();
            addChild(_legend);
            _legend.y = 2;
            _legend.visible = false;
		}
		
		private function initLayer():void
		{
            _dragCursor = new DragCursor();
            _dragCursor.gotoAndStop("normal");
			
			_mouseLayer = new Sprite();
            addChild(_mouseLayer);
            _mouseLayer.addEventListener(MouseEvent.ROLL_OVER, doMouseLayerRollOver);
            _mouseLayer.addEventListener(MouseEvent.ROLL_OUT, doMouseLayerRollOut);
            _mouseLayer.addEventListener(MouseEvent.MOUSE_DOWN, doMouseLayerMouseDown);
		}
		
		private function doMouseLayerRollOver(e:MouseEvent):void
		{
			CursorManager.getInstance().showCursor(_dragCursor);
			if(_categoryGrid.data && !_isDragging)
			{
				doMouseLayerMouseMove(null);
				setPointElementsVisible(true);
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doMouseLayerMouseMove);
		}
		
		private function doMouseLayerRollOut(e:MouseEvent):void
		{
			if(!e.buttonDown)
			{
				CursorManager.getInstance().hideCursor(_dragCursor);
			}
			setPointElementsVisible(false);
			refreshLegend(false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseLayerMouseMove);
		}
		
		private function doMouseLayerMouseDown(e:MouseEvent):void
		{
			_isDragging = true;
			_dragCursor.gotoAndStop("dragging");
			CursorManager.getInstance().showCursor(_dragCursor);
			stage.addEventListener(Event.ENTER_FRAME, doDragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, doMouseLayerMouseUp);
			setPointElementsVisible(false);
			refreshLegend(false);
            _mouseStartMouseX = stage.mouseX;
            dispatchEvent(new Event(EVENT_START_DRAG));
		}
		
		private function doMouseLayerMouseMove(e:MouseEvent):void
		{
			if(_categoryGrid.data == null) return;
			_currentPointIndex = _categoryGrid.getIndexByPosition(_mouseLayer.mouseX);
            if (!_isDragging)
            {
                refreshPointElements();
            }
		}
		
		private function doMouseLayerMouseUp(e:MouseEvent) : void
		{
			_isDragging = false;
			_dragCursor.gotoAndStop("normal");
			
			if (!_mouseLayer.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				CursorManager.getInstance().showCursor(_dragCursor);
			}
			else
			{
				_currentPointIndex = _categoryGrid.getIndexByPosition(_mouseLayer.mouseX);
				refreshPointElements();
                setPointElementsVisible(true);
			}
			
			stage.removeEventListener(Event.ENTER_FRAME, doDragging);
            stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseLayerMouseUp);
            dispatchEvent(new Event(EVENT_END_DRAG));
		}
		
		private function doDragging(e:Event) : void
		{
			var distance:Number = stage.mouseX - _mouseStartMouseX;
			var movieIndex:int = -Math.round(distance / _categoryGrid.unitSize);
			if(_isUnitWeek)
			{
				movieIndex = movieIndex * 7;
			}
			
			var de:DataEvent = new DataEvent(EVENT_DRAGGING);
			de.data = movieIndex;
			dispatchEvent(de);
		}
		
		private function refreshPointElements():void
		{
			var xPos:Number = _categoryGrid.getPositionByIndex(_currentPointIndex);
			var i:int = 0;
			while(i < _userValueGroups.length)
			{
				var shape:Shape = _graphPoints[i];
				shape.x = xPos;
				var val:Number = _userValueGroups[i][_currentPointIndex];
				if(!isNaN(val))
				{
					shape.y = _userValueGrid.getPositionByValue(_userValueGroups[i][_currentPointIndex]);
				}
				else
				{
					shape.y = -100;
				}
				i++;
			}
			
			var curDate:Date = _dates[_currentPointIndex];
			var hasDateDistance:Boolean = false;
			var startDate:Date;
			
			
			if(curDate)
			{
				if(_isUnitWeek)
				{
					if(_currentPointIndex == 0)
					{
						if(curDate.valueOf() != _rawFirstDates[0].valueOf())
						{
							hasDateDistance = true;
							startDate = _rawFirstDates[0];
						}
					}
					else if(_currentPointIndex == (_dates.length - 1))
					{
						if(curDate.day != 1)
						{
							hasDateDistance = true;
							startDate = new Date(curDate.valueOf());
							startDate.date = startDate.date - (curDate.day == 0 ? 7 : curDate.day) - 1;
						}
					}
					else
					{
						hasDateDistance = true;
						startDate = new Date(curDate.valueOf());
						startDate.date = startDate.date - 6;
					}
				}
				
				if(hasDateDistance)
				{
					_txtCurrentPointDate.text = DateFormatter.format(startDate, ConfigManager.getFormatString()) + "/" + DateFormatter.format(curDate, ConfigManager.getFormatString());
				}
				else
				{
					_txtCurrentPointDate.text = DateFormatter.format(curDate, ConfigManager.getFormatString());
					if(ConfigManager.minShowUnit == "5分钟")
					{
						_txtCurrentPointDate.text = _txtCurrentPointDate.text.substring(_txtCurrentPointDate.text.indexOf(" "));
					}
				}
			}
			
			_txtCurrentPointDate.x = _width - _txtCurrentPointDate.width - 2;
			
			refreshLegend(true);
		}
		
		private function refreshLegend(param1:Boolean) : void
		{
			var labelsCount:int = _userValueGroups.length;
			var i:int = 0;
			var valStr:String = "";
			
			var legendXPos:Number = 0;
			
			while(i < labelsCount)
			{
				var container:Sprite = _legendItems[i];
				var circlePoint:Shape = _legendPoints[i];
				var keyLab:TextField = _legendKeyLabels[i];
				var valLab:TextField = _legendValueLabels[i];
				if(param1 && _userValueGroups[i][_currentPointIndex])
				{
					var val:Number = _userValueGroups[i][_currentPointIndex];
					if(!isNaN(val))
					{
						valStr = val.toString();
					}
					
					keyLab.text = _labels[i];
					valLab.text = " " + valStr;
				}
				else
				{
					keyLab.text = _labels[i];
					valLab.text = "";
				}
				
				keyLab.x = circlePoint.width - 2;
				valLab.x = keyLab.x + keyLab.width - 2;
				
				container.x = legendXPos;
				legendXPos = legendXPos + container.width + 6;
				
				i++;
			}
			
			_legend.x = _width - _legend.width;
			_currentPointIndex = NaN;
		}
		
		private function setPointElementsVisible(param1:Boolean) : void
		{
			var i:int = 0;
            while (i < _userValueGroups.length)
            {
                
                _graphPoints[i].visible = param1;
                i++;
            }
            _txtCurrentPointDate.visible = param1;
		}
		
		override public function set data(obj:*):void
		{
			var hasDates:Boolean = _dates != null;
			_dates = obj.dates;
			_labels = obj.labels;
			_dateGroups = obj.dateGroups;
			_userValueGroups = obj.userValueGroups;
			_mediaValueGroups = obj.mediaValueGroups;
			
			var labelsCount:int = _labels.length;
			var i:int = 0;
			_userLabel.text = "";
			while(i < labelsCount)
			{
				if(_userValueGroups[i])
				{
					_userLabel.appendText(_labels[i] + " 选区峰值：" + getMinMaxValueBySingle(_userValueGroups[i]).max + "\n");
				}
				i++;
			}
			_userLabel.width = _userLabel.textWidth + 10;
//			_userLabel.height = _userLabel.textHeight * _userLabel.text.split("\n").length;
			
			adjustUnit(hasDates);
			
			setCategoryGridData();
			
			setUserValueGridData();
			
			setMediaValueGridData();
			
			setUserValueGraphData();
			
			setMediaValueGraphData();
			
			setGraphPointAndLegendItemData();
			
			_legend.visible = true;
			
			if(!_isDragging)
				refreshPointElements();
		}
		
		private function setCategoryGridData():void
		{
			_categoryGrid.data = _dates;
		}
		
		private function setUserValueGridData():void
		{
			var userValueMaxAndMin:Object = getMinMaxValue(_userValueGroups);
			var userValueSpan:Number = userValueMaxAndMin.max - userValueMaxAndMin.min;
			var averageBit:int = Math.max(Math.round(userValueSpan / USER_VALUE_GRID_SPLIT).toString().length - 1,0);
			
			_userValueGrid.assignMinValue = NaN;
            _userValueGrid.assignMaxValue = NaN;
            _userValueGrid.dataValueMin = 0;
            _userValueGrid.dataValueMax = userValueMaxAndMin.max + userValueMaxAndMin.min;
            _userValueGrid.averageBit = averageBit;
		}
		
		private function setMediaValueGridData():void
		{
			var mediaValueMaxAndMin:Object = getMinMaxValue(_mediaValueGroups);
			var mediaValueSpan:Number = mediaValueMaxAndMin.max - mediaValueMaxAndMin.min;
			var averageBit:int = Math.max(Math.round(mediaValueSpan / MEDIA_VALUE_GRID_SPLIT).toString().length - 1,0);
			
			_mediaValueGrid.assignMinValue = NaN;
            _mediaValueGrid.assignMaxValue = NaN;
            _mediaValueGrid.dataValueMin = 0;
            _mediaValueGrid.dataValueMax = mediaValueMaxAndMin.max;
            _mediaValueGrid.averageBit = averageBit;
		}
		
		private function setUserValueGraphData():void
		{
			var i:uint = 0;
			
			while(i < _userValueGroups.length)
			{
				var array:Array = _userValueGroups[i];
				
				var lg:LineGraph = _userGraphs[i] as LineGraph;
				
				var _loc_2:* = _height - HEIGHT_CATEGORY_BAR - HEIGHT_HEADER;
            	var _loc_3:* = _loc_2 * (1 - HEIGHT_PERCENT_MEDIA);//用户关注度的高度
            	
				if(lg == null)
				{
					lg = new LineGraph();
					_graphContainer.addChild(lg);
					lg.width = _width;
					
					lg.height = _loc_3;
					lg.categoryGrid = _categoryGrid;
					lg.valueGrid = _userValueGrid;
					lg.setStyle(GridBasedGraph.GRAPH_LINE_STYLE, new LineStyle(ConfigManager.COLORS_OF_GRAPHS[i], 1, 1));
					_userGraphs[i] = lg;
				}
				
				lg.data = array;
				lg.visible = true;
				i++;
			}
		}
		
		private function setMediaValueGraphData():void
		{
			var i:uint = 0;
			
			while(i < _mediaValueGroups.length)
			{
				var array:Array = _mediaValueGroups[i];
				var ag:AreaGraph = _mediaGraphs[i];
				
				if(ag == null)
				{
					ag = new AreaGraph();
					_graphContainer.addChild(ag);
					ag.width = _width;
					
					var _loc_2:* = _height - HEIGHT_CATEGORY_BAR - HEIGHT_HEADER;
            		var _loc_3:* = _loc_2 * HEIGHT_PERCENT_MEDIA;
					
					ag.height = _loc_3;
					ag.y = _userValueGrid.y + _userValueGrid.height;
					
					ag.categoryGrid = _categoryGrid;
					ag.valueGrid = _mediaValueGrid;
					ag.setStyle(GridBasedGraph.GRAPH_LINE_STYLE, new LineStyle(ConfigManager.COLORS_OF_GRAPHS[i], 1, 1));
                    ag.setStyle(AreaGraph.GRAPH_AREA_COLOR, ConfigManager.COLORS_OF_GRAPHS[i]);
                    ag.setStyle(AreaGraph.GRAPH_AREA_ALPHA, 0.3);
                    _mediaGraphs[i] = ag;
				}
				ag.data = array;
				ag.visible = true;
				i++;
			}
		}
		
		private function setGraphPointAndLegendItemData():void
		{
			var i:uint = 0;
			
			while (i < _userValueGroups.length)
			{
				var shape:Shape = _graphPoints[i];
				
				if(shape == null)
				{
					shape = new Shape();
					_graphPointContainer.addChild(shape);
					_graphPoints[i] = shape;
                    var g:Graphics = shape.graphics;
                    g.clear();
                    g.beginFill(ConfigManager.COLORS_OF_GRAPHS[i], 1);
                    g.drawCircle(0, 0, 3);
                    g.endFill();
                    shape.visible = false;
				}
				
				var sprite:Sprite = _legendItems[i];
				
				if(sprite == null)
				{
					sprite = new Sprite();
					_legend.addChild(sprite);
					_legendItems[i] = sprite;
					
					var shapes:Shape = new Shape();
					sprite.addChild(shapes);
					_legendPoints[i] = shapes;
					var ghs:Graphics = shapes.graphics;
					ghs.clear();
                    ghs.beginFill(ConfigManager.COLORS_OF_GRAPHS[i], 1);
                    ghs.drawCircle(2, 2, 4);
                    ghs.endFill();
                    shapes.y = 8;
                    
                    var tf:TextFormat = new TextFormat();
                    tf.color = ConfigManager.COLORS_OF_GRAPHS[i];
                    tf.size = 12;
                    tf.font = "微软雅黑";
                    
                    var textField1:TextField = new TextField();
                    sprite.addChild(textField1);
                    _legendKeyLabels[i] = textField1;
                    textField1.autoSize = "left";
                    textField1.defaultTextFormat = tf;
                    textField1.selectable = false;
                    
                    var textField2:TextField = new TextField();
                    sprite.addChild(textField2);
                    _legendValueLabels[i] = textField2;
                    textField2.autoSize = "left";
                    textField2.defaultTextFormat = tf;
                    textField2.selectable = false;
				}
				
				i++;
			}
		}
		
		private function drawMouseLayer() : void
        {
            var g:Graphics = _mouseLayer.graphics;
            g.clear();
            g.beginFill(0, 0);
            g.drawRect(0, HEIGHT_HEADER, _width, _height - HEIGHT_HEADER);
            g.endFill();
            return;
        }
		private var _isUnit5Minutes:Boolean;
		private function adjustUnit(val:Boolean):void
		{
			if(val == false) return;
			
			var isUnitWeekOld:Boolean = _isUnitWeek;
			
			if(_dates[_dates.length - 1].valueOf() - _dates[0].valueOf() > ConfigManager.YEAR_TIME_VALUE)
			{
				_isUnitWeek = true;
				if(isUnitWeekOld == false && val)
				{
					showUnitTip(1);
				}
			}
			else
			{
				_isUnitWeek = false;
				if(isUnitWeekOld == true && val)
				{
					showUnitTip(2);
				}
			}
			
			if(_isUnitWeek)
			{
				var i:int = 0;
				var icount:int = _userValueGroups.length;
				
				var dgs:Array = [];
				var uvgs:Array = [];
				var mvgs:Array = [];
				
				_rawFirstDates = [];
				
				while(i < icount)
				{
					var dateAry:Array = _dateGroups[0];
					var uvAry:Array = _userValueGroups[i];
					var mvAry:Array = _mediaValueGroups[i];
					
					var j:int = 0;
					var jcount:int = dateAry.length;
					
					var uvWeekCount:Number = 0;
					var mvWeekCount:Number = 0;
					
					var weekCount:int = 0;
					
					var userValueGroup:Array = [];
					var mediaValueGroup:Array = [];
					
					var weekDataGroup:Array = [];
					
					if(i == 0)
					{
						_rawFirstDates[i] = dateAry[0];
					}
					
					while(j < jcount)
					{
						var d:Date = dateAry[j];
						
						uvWeekCount = uvWeekCount + uvAry[j];
						mvWeekCount = mvWeekCount + mvAry[j];
						
						weekCount++;
						
						if(d.day == 0 || j == (jcount - 1))
						{
							userValueGroup.push(Math.round(uvWeekCount / weekCount));
							mediaValueGroup.push(Math.round(mvWeekCount / weekCount));
							
							weekDataGroup.push(d);
							
							uvWeekCount = 0;
							mvWeekCount = 0;
							weekCount = 0;
						}
						j++;
					}
					
					dgs.push(weekDataGroup);
					uvgs.push(userValueGroup);
					mvgs.push(mediaValueGroup);
					i++;
				}
				_dateGroups = dgs;
				_dates = _dateGroups[0];
				_userValueGroups = uvgs;
				_mediaValueGroups = mvgs;
			}
		}
		
		private function showUnitTip(param1:uint) : void
        {
            if (_unitTip == null)
            {
                _unitTip = new UnitTip();
                addChild(_unitTip);
            }
            _unitTip.x = (_width - _unitTip.width) / 2;
            _unitTip.y = 22;
            _unitTip.gotoAndStop(param1);
            _unitTip.visible = true;
            clearTimeout(_hideUnitTimeoutId);
            _hideUnitTimeoutId = setTimeout(hideUnitTip, 3000);
        }
        
        private function hideUnitTip() : void
        {
            _unitTip.visible = false;
        }
        
        private function getMinMaxValueBySingle(param1:Array):Object
        {
        	var minVal:Number = Infinity;
			var maxVal:Number = -Infinity;
			
			for each(var val:Number in param1)
			{
				if(!isNaN(val))
				{
					minVal = Math.min(minVal, val);
					maxVal = Math.max(maxVal, val);
				}
			}
			
			return {max: maxVal, min: minVal};
        }
		
		private function getMinMaxValue(param1:Array) : Object
		{
			var minVal:Number = Infinity;
			var maxVal:Number = -Infinity;
			for each(var array:Array in param1)
			{
				for each(var val:Number in array)
				{
					if(!isNaN(val))
					{
						minVal = Math.min(minVal, val);
						maxVal = Math.max(maxVal, val);
					}
				}
			}
			
			return {max: maxVal, min: minVal};
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_categoryGrid.width = _width;
			_userValueGrid.width = _width;
			_mediaValueGrid.width = _width;
			
			if(_unitTip)
				_unitTip.x = (_width - _unitTip.width) / 2;
			
			if(_categoryGrid.data)
				refreshPointElements();
			
			for each(var lg:LineGraph in _userGraphs)
			{
				lg.width = _width;
			}
			
			for each(var ag:AreaGraph in _mediaGraphs)
			{
				ag.width = _width;
			}
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			var _loc_2:* = _height - HEIGHT_CATEGORY_BAR - HEIGHT_HEADER;
            var _loc_3:* = _loc_2 * (1 - HEIGHT_PERCENT_MEDIA);//用户关注度的高度
            var _loc_4:* = _loc_2 * HEIGHT_PERCENT_MEDIA;//媒体关注度的高度
            _categoryGrid.gapHeight = HEIGHT_CATEGORY_BAR;
            _categoryGrid.extraHeight = _loc_4;
			_categoryGrid.height = _loc_3;
			
            _userValueGrid.height = _loc_3;
            
            _mediaValueGrid.height = _loc_4;
            _mediaValueGrid.y = _height - _loc_4;
            
//            _mediaLabel.y = _height - _loc_4 + 2;
            
            
			for each(var lg:LineGraph in _userGraphs)
			{
				lg.height = _loc_3;
			}
			
			for each(var ag:AreaGraph in _mediaGraphs)
			{
				ag.height = _loc_4;
				ag.y = _height - _loc_4 - HEIGHT_HEADER;
			}
		}
		
		override protected function applyChanges():void
		{
			if (isInvalid(INVALID_TYPE_SIZE))
			{
				drawMouseLayer();
			}
		}
	}
}