package road.index
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import gs.Tween;
	import gs.easing.Quad;
	import gs.events.TweenEvent;
	
	import road.v.core.DVBase;
	import road.v.core.Grid;
	import road.v.core.LineStyle;
	import road.v.graphs.AreaGraph;
	import road.v.graphs.GridBasedGraph;
	import road.v.grids.ValueGrid;

	public class Slider extends DVBase
	{
        public static const EVENT_RANGE_CHANGE:String = "rangeChange";
        public static const EVENT_RANGE_STABLE:String = "rangeStable";
        public static const EVENT_RANGE_SELECTING:String = "rangeSelecting";
        
        private const HEIGHT_BAR:Number = 0;
        private const HEIGHT_TOP_GAP:Number = 8;
        private const COLOR_OUTLINE:uint = 0xA2BDF1;
        
		private var _categoryGrid:SliderCategoryGrid;
		private var _valueGrid:ValueGrid;
		private var _greyGraph:AreaGraph;
		private var _graph:AreaGraph;
		
        private var _graphMask:Shape;
        private var _outlineLayer:Shape;
        
        private var _dates:Array;
        private var _values:Array;
        
        private var _currentRange:Point;
        
        
        private var _chartHeight:Number;
        private var _mouseStartX:Number;
        private var _mouseStartLeftX:Number;
        private var _mouseStartRightX:Number;
        private var _mouseStartBarPos:Point;
        private var _mouseStartRange:Point;
        private var _isStickDragging:Boolean;
        
        private var _rangeXTween:Tween;
        private var _rangeYTween:Tween;
        
        private var _minSliderBarWidth:Number = 10;
        
        private var _bar:SliderBar;
        private var _leftStick:SliderBtnLeft;
        private var _rightStick:SliderBtnRight;
		
		public function Slider()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
//			init(null);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
            _categoryGrid = new SliderCategoryGrid();
            addChild(_categoryGrid);
            _categoryGrid.showAxisLine = false;
            _categoryGrid.showSplitLine = true;
            _categoryGrid.showAxisLabel = true;
            
            var tf:TextFormat = new TextFormat();
            tf.font = "微软雅黑";
            tf.size = 12;
            tf.color = 0x666666;
            _categoryGrid.setStyle(Grid.AXIS_LABEL_TEXT_FORMAT, tf);
            
            _valueGrid = new ValueGrid();
            addChild(_valueGrid);
            _valueGrid.splitNumber = 1;
            _valueGrid.showAxisLabel = false;
            _valueGrid.showLastSplitLine = true;
            _valueGrid.showSplitLine = true;
            _valueGrid.showAxisLine = false;
            
            _greyGraph = new AreaGraph();
            addChild(_greyGraph);
            _greyGraph.categoryGrid = _categoryGrid;
            _greyGraph.valueGrid = _valueGrid;
            _greyGraph.setStyle(GridBasedGraph.GRAPH_LINE_STYLE, new LineStyle(0xAAAAAA, 1, 1));
            _greyGraph.setStyle(AreaGraph.GRAPH_AREA_COLOR, 0xDDDDDD);
            _greyGraph.setStyle(AreaGraph.GRAPH_AREA_ALPHA, 0.3);
            
            _graph = new AreaGraph();
            addChild(_graph);
            _graph.categoryGrid = _categoryGrid;
            _graph.valueGrid = _valueGrid;
            _graph.setStyle(GridBasedGraph.GRAPH_LINE_STYLE, new LineStyle(0xFFA333, 1, 1));
            _graph.setStyle(AreaGraph.GRAPH_AREA_COLOR, 0xFFA333);
            _graph.setStyle(AreaGraph.GRAPH_AREA_ALPHA, 0.3);
            _graphMask = new Shape();
            addChild(_graphMask);
            _graph.mask = _graphMask;
            
            _outlineLayer = new Shape();
            addChild(_outlineLayer);
            
            _bar = new SliderBar();
            _bar.buttonMode = true;
            _bar.addEventListener(MouseEvent.MOUSE_DOWN, __BarMouseDown);
            _bar.visible = false;
            this.addChild(_bar);
            
            _leftStick = new SliderBtnLeft();
            _leftStick.addEventListener(MouseEvent.MOUSE_DOWN, __LeftStickMouseDown);
            _leftStick.addEventListener(MouseEvent.ROLL_OVER, __StickMouseOver);
            _leftStick.addEventListener(MouseEvent.ROLL_OUT, __StickMouseOut);
            _leftStick.visible = false;
            this.addChild(_leftStick);
            
            _rightStick = new SliderBtnRight();
            _rightStick.addEventListener(MouseEvent.MOUSE_DOWN, __RightStickMouseDown);
            _rightStick.addEventListener(MouseEvent.ROLL_OVER, __StickMouseOver);
            _rightStick.addEventListener(MouseEvent.ROLL_OUT, __StickMouseOut);
            _rightStick.visible = false;
            this.addChild(_rightStick);
		}
		
		private function __BarMouseDown(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, __BarMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __BarMouseUp);
			_mouseStartX = stage.mouseX;
			_mouseStartBarPos = new Point(_bar.x, _bar.y);
		}
		
		private function __BarMouseMove(e:Event):void
		{
			var distance:Number = stage.mouseX - _mouseStartX;
			var targetX:Number = _mouseStartBarPos.x + distance;
			
			if(targetX < 0)
			{
				targetX = 0;
			}
			
			if(targetX > (_width - _bar.width + 1.5))
			{
				targetX = _width - _bar.width + 1.5
			}
			moveBar(targetX - _bar.x);
			refreshRangeByBar();
			dispatchEvent(new Event(EVENT_RANGE_CHANGE));
		}
		
		private function __BarMouseUp(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, __BarMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, __BarMouseUp);
            hideCursor();
            dispatchEvent(new Event(EVENT_RANGE_STABLE));
		}
		
		private function __LeftStickMouseDown(e:MouseEvent):void
		{
			_isStickDragging = true;
			this.addEventListener(Event.ENTER_FRAME, __LeftStickMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __LeftStickMouseUp);
			_mouseStartX = stage.mouseX;
			_mouseStartRange = _currentRange.clone();
			_mouseStartLeftX = _leftStick.x;
			showCursor();
		}
		
		private function __LeftStickMouseMove(e:Event):void
		{
			var distance:Number = stage.mouseX - _mouseStartX;
			var targetX:Number = _mouseStartLeftX + distance;
			
			targetX = Math.min(targetX, _rightStick.x - _minSliderBarWidth);
			targetX = Math.max(targetX, 0);
			_leftStick.x = targetX;
			refreshRangeByBar();
			drawTemplineOfBtnLeft();
			this.dispatchEvent(new Event(EVENT_RANGE_SELECTING));
		}
		
		private function __LeftStickMouseUp(e:MouseEvent):void
		{
			_isStickDragging = false;
            doAnimation(_mouseStartRange, _currentRange);
            
            this.removeEventListener(Event.ENTER_FRAME, __LeftStickMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, __LeftStickMouseUp);
            if (!_leftStick.hitTestPoint(stage.mouseX, stage.mouseY) && !_rightStick.hitTestPoint(stage.mouseX, stage.mouseY))
            {
                hideCursor();
            }
		}
		
		private function __RightStickMouseDown(e:MouseEvent):void
		{
			_isStickDragging = true;
			this.addEventListener(Event.ENTER_FRAME, __RightStickMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, __RightStickMouseUp);
            _mouseStartX = stage.mouseX;
            _mouseStartRange = _currentRange.clone();
            _mouseStartRightX = _rightStick.x;
            showCursor();
		}
		
		private function __RightStickMouseMove(e:Event):void
		{
			var distance:Number = stage.mouseX - _mouseStartX;
            var targetX:Number = _mouseStartRightX + distance;
            targetX = Math.min(targetX, _width);
            targetX = Math.max(targetX, _leftStick.x + _minSliderBarWidth);
            _rightStick.x = targetX;
            refreshRangeByBar();
            drawTemplineOfBtnRight();
            this.dispatchEvent(new Event(EVENT_RANGE_SELECTING));
		}
		
		private function __RightStickMouseUp(e:MouseEvent):void
		{
			_isStickDragging = false;
			doAnimation(_mouseStartRange, _currentRange);
            this.removeEventListener(Event.ENTER_FRAME, __RightStickMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, __RightStickMouseUp);
            hideCursor();
		}
		
		private function __StickMouseOver(e:MouseEvent):void
		{
			if(e.buttonDown) return;
			
			showCursor();
		}
		
		private function __StickMouseOut(e:MouseEvent):void
		{
			if(e.buttonDown) return;
			
			if(!_isStickDragging) hideCursor();
		}
		
		
		
		
		
		private function doAnimation(startRange:Point, endRange:Point) : void
        {
            if (_rangeXTween != null)
            {
	        	_rangeXTween.removeEventListener(TweenEvent.MOTION_CHANGE, refreshRange);
	            _rangeXTween.removeEventListener(TweenEvent.MOTION_FINISH, motionFinish);
                _rangeXTween.stop();
                _rangeXTween.dispose();
            }
            if (_rangeYTween != null)
            {
                _rangeYTween.stop();
                _rangeYTween.dispose();
            }
            _rangeXTween = new Tween(_currentRange, "x", Quad.easeOut, startRange.x, endRange.x, 0.5);
            _rangeYTween = new Tween(_currentRange, "y", Quad.easeOut, startRange.y, endRange.y, 0.5);
            _rangeXTween.addEventListener(TweenEvent.MOTION_CHANGE, refreshRange);
            _rangeXTween.addEventListener(TweenEvent.MOTION_FINISH, motionFinish);
            _rangeXTween.start();
            _rangeYTween.start();
//			refreshRange();
//			motionFinish(null);
        }
        
        private function refreshRange(param1:Event = null) : void
        {
            _currentRange.x = Math.ceil(_currentRange.x);
            _currentRange.y = Math.floor(_currentRange.y);
            refreshBar();
            drawGraphMask();
            this.dispatchEvent(new Event(EVENT_RANGE_CHANGE));
            return;
        }
        
        private function motionFinish(e:Event):void
        {
//        	_rangeYTween.removeEventListener(TweenEvent.MOTION_CHANGE, refreshRange);
//            _rangeYTween.removeEventListener(TweenEvent.MOTION_FINISH, motionFinish);
        	refreshRange();
            dispatchEvent(new Event(EVENT_RANGE_STABLE));
        }
		
		
		
		
		
		private function moveBar(xDistance:Number):void
		{
			_bar.x = _bar.x + xDistance;
			_leftStick.x = _leftStick.x + xDistance;
			_rightStick.x = _rightStick.x + xDistance;
		}
		
		private function refreshRangeByBar():void
		{
			_currentRange.x = _categoryGrid.getIndexByPosition(_leftStick.x);
            _currentRange.y = _categoryGrid.getIndexByPosition(_rightStick.x);
            
            if(_currentRange.x < 0)
            {
            	_currentRange.x = 0;
            }
            if(_currentRange.y > _dates.length - 1)
            {
            	_currentRange.y = _dates.length - 1;
            }
            drawGraphMask();
		}
		
		private function drawTemplineOfBtnLeft() : void
        {
            var distance:Number = _bar.x - _leftStick.x;
            var g:Graphics = _leftStick.graphics;
            g.clear();
            if (distance > 0)
            {
                g.lineStyle(1, COLOR_OUTLINE, 1);
            }
            else
            {
                g.lineStyle(1, 0xDDDDDD, 1);
            }
            g.moveTo(0, _chartHeight);
            g.lineTo(distance, _chartHeight);
            if (distance < 0)
            {
                g.lineStyle(1, COLOR_OUTLINE, 1);
            }
            else
            {
                g.lineStyle(1, 0xDDDDDD, 1);
            }
            g.moveTo(0, -HEIGHT_TOP_GAP);
            g.lineTo(distance, -HEIGHT_TOP_GAP);
        }
        
        private function drawTemplineOfBtnRight() : void
        {
        	var distance:Number = _bar.x + _bar.width - _rightStick.x;
            var g:Graphics = _rightStick.graphics;
            g.clear();
            if ((-_rightStick.x + _bar.x + _bar.width)-1 < 0)
            {
                g.lineStyle(1, COLOR_OUTLINE, 1);
            }
            else
            {
                g.lineStyle(1, 0xDDDDDD, 1);
            }
            g.moveTo(distance, _chartHeight);
            g.lineTo(0, _chartHeight);
            if (distance > 0)
            {
                g.lineStyle(1, COLOR_OUTLINE, 1);
            }
            else
            {
                g.lineStyle(1, 0xDDDDDD, 1);
            }
            g.moveTo(distance, -HEIGHT_TOP_GAP);
            g.lineTo(0, -HEIGHT_TOP_GAP);
        }
		
		private function drawGraphMask() : void
        {
            var g:Graphics = _graphMask.graphics;
            g.clear();
            g.beginFill(0, 0);
            g.drawRect(_leftStick.x, 0, _rightStick.x - _leftStick.x, _chartHeight);
            g.endFill();
        }
        
        private function refreshBar() : void
        {
            _leftStick.graphics.clear();
            _rightStick.graphics.clear();
            _bar.x = _categoryGrid.getPositionByIndex(_currentRange.x);
            var w:Number = _categoryGrid.getPositionByIndex(_currentRange.y) - _bar.x;
            var g:Graphics = _bar.graphics;
            g.clear();
            g.beginFill(0xFF0000, 0);
            g.drawRect(0, -_chartHeight, w, _chartHeight);
            g.endFill();
            g.lineStyle(1, COLOR_OUTLINE, 1);
            g.moveTo(0, 0);
            g.lineTo(w + 0.5, 0);
            g.lineStyle(1, 0xDDDDDD, 1);
            g.moveTo(0.5, -_chartHeight - HEIGHT_TOP_GAP);
            g.lineTo(w, -_chartHeight - HEIGHT_TOP_GAP);
            _leftStick.x = _bar.x;
            _rightStick.x = _bar.x + w;
            return;
        }
		
		
		
		private function showCursor() : void
        {
            CursorManager.getInstance().showCursor(ArrowCursor);
        }
        
        private function hideCursor() : void
        {
            CursorManager.getInstance().hideCursor(ArrowCursor);
        }
		
		private function getMinMaxValue(param1:Array) : Object
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
		
		private function getMaxValue():Number
		{
			var max:Number = 0;
			for each (var val:Number in _values)
			{
				if (isNaN(val))
                {
                    continue;
                }
                max = Math.max(max, val);
			}
			
			return max;
		}
		
		private function adjustUnit() : void
		{
			var _isUnitWeek:Boolean;
			if (_dates[_dates.length - 1].valueOf() - _dates[0].valueOf() > ConfigManager.YEAR_TIME_VALUE)
			{
				_isUnitWeek = true;
			}
			else
			{
				_isUnitWeek = false;
			}
			
			if(_isUnitWeek)
			{
				var i:int = 0;
				var icount:int = _dates.length;
				
				var valueWeekCount:Number = 0;
				var weekCount:int = 0;
				
				var valueAry:Array = [];
				
				while(i < icount)
				{
					var d:Date = _dates[i];
					valueWeekCount += _values[i];
					weekCount++;
					if(d.day == 0 || i == (icount - 1))
					{
						valueAry.push(Math.round(valueWeekCount / weekCount));
						valueWeekCount = 0;
						weekCount = 0;
					}
					else
					{
						valueAry.push(NaN);
					}
					i++;
				}
				
				_values = valueAry;
			}
		}
		
		
		
		
		
		
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			_categoryGrid.width = _width;
            _minSliderBarWidth = _categoryGrid.unitSize * ConfigManager.minShowDistance;
            _valueGrid.width = _width;
            _graph.width = _width;
            _greyGraph.width = _width;
//            _rangeSelector.x = _width - _rangeSelector.width + 2;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
            _chartHeight = _height - HEIGHT_BAR;
            _categoryGrid.height = _chartHeight;
            _valueGrid.height = _chartHeight;
            _graph.height = _chartHeight;
            _greyGraph.height = _chartHeight;
            _bar.y = _chartHeight;
            var _loc_2:* = (_chartHeight - 32) / 2;
            _leftStick.getChildByName("btn").y = _loc_2;
            _rightStick.getChildByName("btn").y = _loc_2;
            _leftStick.getChildByName("line").height = _chartHeight + 1 + HEIGHT_TOP_GAP;
            _rightStick.getChildByName("line").height = _chartHeight + 1 + HEIGHT_TOP_GAP;
//            _rangeSelector.y = _height + 4;
		}
		
		override public function set data(o:*):void
		{
			_dates = o.dates;
			_values = o.values;
			
			adjustUnit();
			
			_categoryGrid.data = _dates;
			
			_valueGrid.dataValueMin = 0;
            _valueGrid.dataValueMax = getMaxValue();
            _valueGrid.gapOfMax = 0.1;
            var maxAndMinObj:Object = getMinMaxValue(_values);
            var valueSpan:Number = maxAndMinObj.max - maxAndMinObj.min;
            var averageBit:int = Math.max(Math.round(valueSpan / _valueGrid.splitNumber).toString().length - 1,0);
            _valueGrid.averageBit = averageBit;
            
            _graph.data = _values;
            _greyGraph.data = _values;
            
            invalidate(INVALID_TYPE_DATA);
            
            _bar.visible = true;
            _leftStick.visible = true;
            _rightStick.visible = true;
            
            if (_currentRange == null)
            {
            	var startIndex:int;
            	var endIndex:int
            	var endDateSpan:Number = _dates[_dates.length - 1].valueOf();
//            	if (root.loaderInfo.parameters["periods"])
            	if (true)
            	{
            		if(ConfigManager.initShowDistance < ConfigManager.minShowDistance)
            			ConfigManager.initShowDistance = ConfigManager.minShowDistance;
            		
            		var dateCount:int = _dates.length - 1;
//            		var array:Array = root.loaderInfo.parameters["periods"].split("|");
            		
            		var endDate:Date = ConfigManager.showEndDate;
            		var startDate:Date = new Date(endDate.valueOf() - (ConfigManager.getCalcValueByUnit() * ConfigManager.initShowDistance));
            		
            		
            		startIndex = dateCount - ConfigManager.initShowDistance;
            		endIndex = dateCount;
            		
            		if(endDate.valueOf() < endDateSpan)
            		{
            			endIndex = dateCount - (endDateSpan - endDate.valueOf()) / ConfigManager.getCalcValueByUnit();
            		}
            		startIndex = dateCount - (endDateSpan - startDate.valueOf()) / ConfigManager.getCalcValueByUnit();
            		if(startIndex >= endIndex)
            		{
            			startIndex = endIndex - ConfigManager.initShowDistance;
            		}
            	}
            	startIndex = Math.max(startIndex, 0);
            	_currentRange = new Point(startIndex, endIndex);
                this.dispatchEvent(new Event(EVENT_RANGE_CHANGE));
            }
            
            _minSliderBarWidth = _categoryGrid.unitSize * ConfigManager.minShowDistance;
            
            this.dispatchEvent(new Event(EVENT_RANGE_STABLE));
            invalidate(INVALID_TYPE_DATA);
            refreshRange();
		}
		
		public function get currentRange():Point
		{
			return _currentRange;
		}
		
		public function refreshBarPos():void
		{
			if(_categoryGrid.data)
			{
				refreshBar()
				
				drawGraphMask();
			}
		}
		
		public function moveRange(start:Point, distance:int):void
		{
			var dateCount:int = _dates.length;
			var startPoint:Point = start.clone();
			if(distance > 0)
			{
				startPoint.y = start.y + distance;
				if(startPoint.y > (dateCount - 1))
				{
					startPoint.y = dateCount - 1;
				}
				startPoint.x = startPoint.y - (start.y - start.x);
			}
			else
			{
				startPoint.x = start.x + distance;
                if (startPoint.x < 0)
                {
                    startPoint.x = 0;
                }
                startPoint.y = startPoint.x + (start.y - start.x);
			}
			
			_currentRange = startPoint;
			dispatchEvent(new Event(EVENT_RANGE_CHANGE));
			if(_categoryGrid.data)
			{
				refreshBar();
	            drawGraphMask();
   			}
		}
	}
}