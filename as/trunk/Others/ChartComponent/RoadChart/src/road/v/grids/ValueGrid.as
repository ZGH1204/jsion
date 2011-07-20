package road.v.grids
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.lib.utils.*;
	import road.v.core.*;
	
	public class ValueGrid extends Grid
	{
		//分隔线的分隔间距大小
        protected var _splitSize:Number;
        //显示中间的分隔线数量，不包含边界上的分隔线
        protected var _splitNumber:int = 5;
        
        //每条分隔线与上一条分隔的数据跨度值
        protected var _splitValue:Number;
        
        //是否显示最后一条分隔线
        protected var _showLastSplitLine:Boolean = false;
        protected var _showFirstAxisLabel:Boolean = true;
        
        //数据中的最大和最小值(数据)
        protected var _dataValueMax:Number;
        protected var _dataValueMin:Number;
        
        //外部指定最大和最小值(数据)
        protected var _assignMaxValue:Number;
        protected var _assignMinValue:Number;
        
        //内部计算最大和最小值时，用于修正最大和最小值
        protected var _gapOfMax:Number = 0;
        protected var _gapOfMin:Number = 0;
        
        //内部最终使用的最大和最小值，通常为计算或指定获得(数据)
        protected var _finalMaxValue:Number;
        protected var _finalMinValue:Number;
        
        //平均数的位数减1，例如：100  为 2位
        protected var _averageBit:Number;
        
        //分类格子的对齐方式，用于获取位置，值，设置分隔线数字显示组件的位置和画分隔线
        protected var _categoryGridPlacement:String = GridPlacement.BOTTOM;
        
        //轴，分隔线标签模板
        protected var _axisLabelTemplate:String;
        
        
        public static const INVALID_TYPE_SPLIT_NUMBER:String = "splitNumber";
        public static const INVALID_TYPE_GAP_OF_MAX:String = "gapOfMax";
        public static const INVALID_TYPE_GAP_OF_MIN:String = "gapOfMin";
        public static const INVALID_TYPE_DATA_VALUE_MAX:String = "dataValueMax";
        public static const INVALID_TYPE_DATA_VALUE_MIN:String = "dataValueMin";
        public static const INVALID_TYPE_ASSIGNED_MAX_VALUE:String = "assignedMaxValue";
        public static const INVALID_TYPE_ASSIGNED_MIN_VALUE:String = "assignedMinValue";
        public static const INVALID_TYPE_SHOW_FIRST_AXIS_LABEL:String = "showFirstAxisLabel";
        public static const INVALID_TYPE_CATEGORY_GRID_PLACEMENT:String = "categoryGridPlacement";
        public static const INVALID_TYPE_AXIS_LABEL_TEMPLATE:String = "axisLabelTemplate";
        public static const INVALID_TYPE_AXIS_LABEL_POWER:String = "axisLabelPower";
        
		
		public function ValueGrid()
		{
			_placement = GridPlacement.LEFT;
		}
		
		protected function calculateSplitSize():void
		{
			if(_placement == GridPlacement.TOP || 
			_placement == GridPlacement.BOTTOM)
			{
				_splitSize = _width / _splitNumber;
			}
			else
			{
				_splitSize = _height / _splitNumber;
			}
		}
		
		protected function refreshAxisLabelText():void
		{
			var curIndex:int = 0;
			var labelCount:int = _axisLabels.length;
			
			while(curIndex < labelCount)
			{
				var textField:TextField = _axisLabels[curIndex];
				
				var rlt:Number = _finalMinValue + curIndex * _splitValue;
				
				if(_axisLabelTemplate)
				{
					textField.text = NumberFormatter.format(rlt,_axisLabelTemplate);
				}
				else
				{
					textField.text = rlt.toString();
				}
				curIndex++;
			}
		}
		
		//计算每数据值1用多少像素表示,每条分隔线与上一条分隔的数据跨度值和内部最终使用的最大和最小值
		override protected function calculateUnitSize():void
		{
			if((isNaN(_dataValueMin) || isNaN(_dataValueMax)) && (isNaN(_assignMinValue) || isNaN(_assignMaxValue)))
			{
				return;
			}
			
			var revise:Number = Math.pow(10, _averageBit);
			
			if(isNaN(_assignMinValue))
			{
				_finalMinValue = _dataValueMin - _gapOfMin * (_dataValueMax - _dataValueMin);
				_finalMinValue = Math.ceil(_finalMinValue / revise) * revise;//修正取整
			}
			else
			{
				_finalMinValue = _assignMinValue;
			}
			
			if(isNaN(_assignMaxValue))
			{
				if(_dataValueMin != _dataValueMax)
				{
					_finalMaxValue = _dataValueMax + _gapOfMax * (_dataValueMax - _dataValueMin);
					_splitValue = (_finalMaxValue - _finalMinValue) / _splitNumber;
					_splitValue = Math.ceil(_splitValue / revise) * revise;//修正取整
				}
				else if(isNaN(_assignMinValue))
				{
					_splitValue = revise;
					var ceilDataValueMin:Number = Math.ceil(_dataValueMin / revise) * revise;
					var harfSplitNumber:int = Math.round(_splitNumber / 2);
					_finalMinValue = ceilDataValueMin - _splitValue * harfSplitNumber;
				}
				else if(_dataValueMin == _assignMinValue)
				{
					_splitValue = revise;
				}
				else
				{
					_splitValue = (_dataValueMin - _assignMinValue) * 2 / _splitNumber;
					_splitValue = Math.ceil(_splitValue / revise) * revise;
				}
				_finalMaxValue = _finalMinValue + _splitNumber * _splitValue;
			}
			else
			{
				_finalMaxValue = _assignMaxValue;
				
				if(isNaN(_assignMinValue))
				{
					if(_dataValueMin != _dataValueMax)
					{
						_splitValue = (_finalMaxValue - _finalMinValue) / _splitNumber;
					}
					else
					{
						_splitValue = (_assignMaxValue - _dataValueMax) * 2 / _splitNumber;
					}
					
					_splitValue = Math.ceil(_splitValue / revise) * revise;
					_finalMinValue = _finalMaxValue - _splitNumber * _splitValue;
				}
				else
				{
					_splitValue = (_finalMaxValue - _finalMinValue) / _splitNumber;
				}
			}
			
			var calcPixs:Number;
			if(_placement == GridPlacement.LEFT || _placement == GridPlacement.RIGHT)
			{
				calcPixs = _height;
			}
			else
			{
				calcPixs = _width;
			}
			
			_unitSize = calcPixs / (_finalMaxValue - _finalMinValue);
		}
		
		override protected function genAxisLabels():void
		{
			var textField:TextField;
			if(_axisLabels)
			{
				for each(textField in _axisLabels)
				{
					if(this.contains(textField))
						this.removeChild(textField);
				}
			}
			
			_axisLabels = [];
			
			var realSplitNumber:int = (_showLastSplitLine ? (_splitNumber + 1) : _splitNumber);
			
			var i:int = 0;
			
			while(i < realSplitNumber)
			{
				textField = new TextField();
				textField.defaultTextFormat = _styles[AXIS_LABEL_TEXT_FORMAT] as TextFormat;
				textField.autoSize = "left";
				if(_styles[AXIS_LABEL_MULTILINE])
				{
					textField.multiline = true;
					textField.wordWrap = true;
				}
				addChild(textField);
				_axisLabels.push(textField);
				i++;
			}
		}
		
		override protected function locateAxisLabels():void
		{
			var textField:TextField;
			var labelXPos:Number;
			var labelYPos:Number;
			
			var curAxisLabelIndex:int = 0;
			var labelsCount:int = _axisLabels.length;
			
			var padding:Number = _styles[AXIS_LABEL_PADDING];
			
			switch(_placement)
			{
				case GridPlacement.LEFT:
				{
					while(curAxisLabelIndex < labelsCount)
					{
						if(_categoryGridPlacement == GridPlacement.TOP)
						{
							labelYPos = curAxisLabelIndex * _splitSize;
						}
						else
						{
							labelYPos = _height - curAxisLabelIndex * _splitSize;
						}
						textField = _styles[curAxisLabelIndex];
						textField.x = -padding - textField.width;
						textField.y = labelYPos - textField.textHeight / 2;
						curAxisLabelIndex++;
					}
					break;
				}
				case GridPlacement.RIGHT:
				{
					while(curAxisLabelIndex < labelsCount)
					{
						if (_categoryGridPlacement == GridPlacement.TOP)
						{
							labelYPos = curAxisLabelIndex * _splitSize;
						}
						else
						{
							labelYPos = _height - curAxisLabelIndex * _splitSize;
						}
						textField = _styles[curAxisLabelIndex];
						textField.x = _width + padding;
						textField.y = labelYPos - textField.textHeight / 2;
						curAxisLabelIndex++;
					}
					break;
				}
				case GridPlacement.TOP:
				{
					while(curAxisLabelIndex < labelsCount)
					{
						if(_categoryGridPlacement == GridPlacement.RIGHT)
						{
							labelXPos = _width - curAxisLabelIndex * _splitSize;
						}
						else
						{
							labelXPos = curAxisLabelIndex * _splitSize;
						}
						
						textField = _styles[curAxisLabelIndex];
						textField.width = _splitSize;
						textField.x = labelXPos - textField.width / 2;
						textField.y = _height + padding;
						curAxisLabelIndex++;
					}
					break;
				}
				case GridPlacement.BOTTOM:
				{
					while(curAxisLabelIndex < labelsCount)
					{
						if (_categoryGridPlacement == GridPlacement.RIGHT)
						{
							labelXPos = _width - curAxisLabelIndex * _splitSize;
						}
						else
						{
							labelXPos = curAxisLabelIndex * _splitSize;
						}
						textField = _styles[curAxisLabelIndex];
						textField.width = _splitSize;
						textField.x = labelXPos - textField.width / 2;
						textField.y = _height + padding;
						curAxisLabelIndex++;
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override protected function drawSplitLine():void
		{
			if(_splitLineLayer == null)
			{
				_splitLineLayer = new Shape();
				addChildAt(_splitLineLayer, 0);
			}
			
            var curSplitNumber:int;
            var curSplitXPos:Number;
            var curSplitYPos:Number;
            
            var g:Graphics = _splitLineLayer.graphics;
            g.clear();
            
            var ls:LineStyle = _styles[SPLIT_LINE_STYLE] as LineStyle;
            g.lineStyle(ls.thickness,ls.color,ls.alpha);
            
            var realSplitNumber:int = _showLastSplitLine ? _splitNumber + 1 : _splitNumber;
            curSplitNumber = 0;//开始的分隔线序号
            
            //画垂直于对齐方式分隔线
            if(_placement == GridPlacement.BOTTOM || _placement == GridPlacement.TOP)
            {
            	//画分隔线的方向，right时从右向左一条一条画，否则反之
            	if(_categoryGridPlacement == GridPlacement.RIGHT)
            	{
            		//从右向左
            		while(curSplitNumber < realSplitNumber)
            		{
            			curSplitXPos = _width - curSplitNumber * _splitSize;
            			g.moveTo(curSplitXPos, 0);
            			g.lineTo(curSplitXPos, _height);
            			curSplitNumber++;
            		}
            	}
            	else
            	{
            		//从左向右
            		while(curSplitNumber < realSplitNumber)
            		{
            			curSplitXPos = curSplitNumber * _splitSize;
            			g.moveTo(curSplitXPos, 0);
            			g.lineTo(curSplitXPos, _height);
            			curSplitNumber++;
            		}
            	}
            }
            else if(_categoryGridPlacement == GridPlacement.TOP)//判断画分隔线的方向，从上到下或从下到上
            {
            	//从上到下
            	while(curSplitNumber < realSplitNumber)
            	{
            		curSplitYPos = curSplitNumber * _splitSize;
            		g.moveTo(0, curSplitYPos);
            		g.lineTo(_width, curSplitYPos);
            		curSplitNumber++;
            	}
            }
            else
            {
            	//从下到上
            	while(curSplitNumber < realSplitNumber)
            	{
            		curSplitYPos = _height - curSplitNumber * _splitSize;
            		g.moveTo(0, curSplitYPos);
            		g.lineTo(_width, curSplitYPos);
            		curSplitNumber++;
            	}
            }
		}
		
		override protected function applyChanges():void
		{
			var textField:TextField;
			
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
			calculateSplitSize();
			drawLines();
			
			if((isNaN(_dataValueMin) || isNaN(_dataValueMax))&&(isNaN(_assignMinValue) || isNaN(_assignMaxValue)))
				return;
			
			if(_showTick)
				_ticksLayer.visible = true;
			else if(_ticksLayer)
				_ticksLayer.visible = false;
			
			if(_showAxisLine)
				_axisLineLayer.visible = true;
			else if(_axisLineLayer)
				_axisLineLayer.visible = false;
			
			if(_showSplitLine)
				_splitLineLayer.visible = true;
			else if(_splitLineLayer)
				_splitLineLayer.visible = false;
			
			if(_showAxisLabel)
			{
				if(_axisLabels == null || isInvalid(INVALID_TYPE_SPLIT_NUMBER))
				{
					genAxisLabels();
				}
				refreshAxisLabelText();
				locateAxisLabels();
				for each(textField in _axisLabels)
				{
					textField.visible = true;
				}
				
				if(!_showFirstAxisLabel)
				{
					_axisLabels[0].visible = false;
				}
			}
			else if(_axisLabels)
			{
				for each(textField in _axisLabels)
				{
					textField.visible = false;
				}
			}
		}
		
		override protected function drawTicks():void
		{
			if(_ticksLayer)
			{
				_ticksLayer = new Shape();
				addChildAt(_ticksLayer,0);
			}
			
			var curSplitNumber:Number;
			var curSplitYPos:Number;
			var curSplitXPos:Number;
			
			var g:Graphics = _ticksLayer.graphics;
			g.clear();
			
			var ls:LineStyle = _styles[TICK_STYLE] as LineStyle;
			g.lineStyle(ls.thickness,ls.color,ls.alpha);
			
			var tLength:Number = _styles[TICK_LENGTH] as Number;
			
			curSplitNumber = 1;
					
			switch(_placement)
			{
				case GridPlacement.LEFT:
				{
					while(curSplitNumber < _splitNumber)
					{
						curSplitYPos = curSplitNumber * _splitSize;
						g.moveTo(0,curSplitYPos);
						g.lineTo(-tLength,curSplitYPos);
						curSplitNumber++;
					}
					break;
				}
				case GridPlacement.RIGHT:
				{
					while(curSplitNumber < _splitNumber)
					{
						curSplitYPos = curSplitNumber * _splitSize;
						g.moveTo(_width,curSplitYPos);
						g.lineTo(_width + tLength,curSplitYPos);
						curSplitNumber++;
					}
					break;
				}
				case GridPlacement.BOTTOM:
				{
					while(curSplitNumber < _splitNumber)
					{
						curSplitXPos = curSplitNumber * _splitSize;
						g.moveTo(curSplitXPos, _height);
						g.lineTo(curSplitXPos, _height + tLength);
						curSplitNumber++;
					}
					break;
				}
				case GridPlacement.TOP:
				{
					while(curSplitNumber < _splitNumber)
					{
						curSplitXPos = curSplitNumber * _splitSize;
						g.moveTo(curSplitXPos, 0);
						g.lineTo(curSplitXPos, -tLength);
						curSplitNumber++;
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		
		
		public function get splitNumber():int
		{
			return _splitNumber;
		}
		public function set splitNumber(value:int):void
		{
			if(isNaN(value) || _splitNumber == value) return;
			
			_splitNumber = value;
			invalidate(INVALID_TYPE_SPLIT_NUMBER);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function get gapOfMax():Number
		{
			return _gapOfMax;
		}
		public function set gapOfMax(value:Number):void
		{
			if(isNaN(value) || _gapOfMax == value) return;
			
			_gapOfMax = value;
			invalidate(INVALID_TYPE_GAP_OF_MAX);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function get gapOfMin():Number
		{
			return _gapOfMin;
		}
		public function set gapOfMin(value:Number):void
		{
			if(isNaN(value) || _gapOfMin == value) return;
			
			_gapOfMin = value;
			invalidate(INVALID_TYPE_GAP_OF_MIN);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function set dataValueMax(value:Number):void
		{
			if(isNaN(value) || _dataValueMax == value) return;
			
			_dataValueMax = value;
			invalidate(INVALID_TYPE_DATA_VALUE_MAX);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function set dataValueMin(value:Number):void
		{
			if(isNaN(value) || _dataValueMin == value) return;
			
			_dataValueMin = value;
			invalidate(INVALID_TYPE_DATA_VALUE_MIN);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function get assignMaxValue():Number
		{
			return _assignMaxValue;
		}
		public function set assignMaxValue(value:Number):void
		{
			if(_assignMaxValue == value) return;
			
			_assignMaxValue = value;
			invalidate(INVALID_TYPE_ASSIGNED_MAX_VALUE);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function get assignMinValue():Number
		{
			return _assignMinValue;
		}
		public function set assignMinValue(value:Number):void
		{
			if(_assignMinValue == value) return;
			
			_assignMinValue = value;
			invalidate(INVALID_TYPE_ASSIGNED_MIN_VALUE);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		public function get showLastSplitLine():Boolean
		{
			return _showLastSplitLine;
		}
		public function set showLastSplitLine(value:Boolean):void
		{
			if(_showLastSplitLine == value) return;
			
			_showLastSplitLine = value;
			invalidate(INVALID_TYPE_SHOW_SPLIT_LINE);
		}
		
		public function get showFirstAxisLabel():Boolean
		{
			return _showFirstAxisLabel;
		}
		public function set showFirstAxisLabel(value:Boolean):void
		{
			if(_showFirstAxisLabel == value) return;
			
			_showFirstAxisLabel = value;
			invalidate(INVALID_TYPE_SHOW_FIRST_AXIS_LABEL);
		}
		
		public function set categoryGridPlacement(value:String):void
		{
			if(_categoryGridPlacement == value) return;
			
			_categoryGridPlacement = value;
			invalidate(INVALID_TYPE_CATEGORY_GRID_PLACEMENT);
		}
		
		public function get maxValue():Number
		{
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
				resetInvalidHash(INVALID_TYPE_UNIT_SIZE);
			}
			return _finalMaxValue;
		}
		
		public function get minValue():Number
		{
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
				resetInvalidHash(INVALID_TYPE_UNIT_SIZE);
			}
			return _finalMinValue;
		}
		
		public function set axisLabelTemplate(value:String):void
		{
			if(_axisLabelTemplate == value) return;
			
			_axisLabelTemplate = value;
			invalidate(INVALID_TYPE_AXIS_LABEL_TEMPLATE);
		}
		
		public function set averageBit(value:int):void
		{
			if(isNaN(value) || _averageBit == value) return;
			
			_averageBit = value;
			invalidate(INVALID_TYPE_AXIS_LABEL_POWER);
		}
		
		override public function set data(o:*):void
		{
			
		}
		
		
		//获取Y轴的值
		public function getValueByPosition(pos:Number):Number
		{
			var result:Number;
			
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
			
			if(_placement == GridPlacement.LEFT || _placement == GridPlacement.RIGHT)
			{
				if(_categoryGridPlacement == GridPlacement.BOTTOM)
				{
					result = (_height - pos) / _unitSize + _finalMinValue;
				}
				else
				{
					result = pos / _unitSize;
				}
			}
			else if(_categoryGridPlacement == GridPlacement.LEFT)
			{
				result = pos / _unitSize;
			}
			else
			{
				result = (_width - pos) / _unitSize + _finalMinValue;
			}
			
			return result;
		}
		
		//获取Y轴的值
		public function getPositionByValue(value:Number):Number
		{
			var result:Number;
			
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
			
			if(_placement == GridPlacement.LEFT || _placement == GridPlacement.RIGHT)
			{
				if(_categoryGridPlacement == GridPlacement.BOTTOM)
				{
					result = _height - (value - _finalMinValue) * unitSize
				}
				else
				{
					result = value * _unitSize;
				}
			}
			else if(_categoryGridPlacement == GridPlacement.LEFT)
			{
				result = value * _unitSize;
			}
			else
			{
				result = _width - (value - _finalMinValue) * _unitSize;
			}
			return result;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}