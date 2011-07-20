package road.v.grids
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	
	import road.index.ConfigManager;
	import road.v.core.GridPlacement;
	import road.v.core.LineStyle;
	
	public class DateCategoryGrid extends CategoryGrid
	{
        protected var _splitPositionsAry:Array;
        protected var _splitLabelTextsAry:Array;
        protected var _splitLabelCenterPosAry:Array;
        
        protected var splitPos:Number;
        protected var splitLabelText:String;
        protected var splitLabelCenterPos:Number;
        
        protected var _maskLayer:Shape;
        
        protected var date:Date;
        protected var year:int;
        protected var month:int;
        protected var day:int;
        protected var hour:int;
        protected var minute:int;
        protected var week:int;
        
		
		
		public function DateCategoryGrid()
		{
			super();
		}
		
		protected function calculateDateSplit():void
		{
			if(_data == null) return;
			
			_splitPositionsAry = [];
			_splitLabelCenterPosAry = [];
			_splitLabelTextsAry = [];
			
			//时间跨度(毫秒)
			var timeSpan:Number = _data[_data.length-1].valueOf() - _data[0].valueOf();
			//偏移
			var realPadding:Number = _padding <= 1 ? (_padding * _unitSize) : _padding;
			//开始的索引
			var startIndex:Number;
			//数据个数
			var dataCount:int = _data.length;
			
			if(timeSpan > ConfigManager.YEAR_TIME_VALUE * 1.7)//大于1.7年为年度分隔，按年显示
			{
				date = _data[0] as Date;
				
				year = date.fullYear;
				
				_splitPositionsAry.push(realPadding);
				_splitLabelTextsAry.push(date.fullYear + "年");
				
				startIndex = 1;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					if(date.fullYear != year)
					{
						splitPos = realPadding + startIndex * _unitSize;
						splitLabelText = date.fullYear + "年";
						
						_splitPositionsAry.push(splitPos);
						_splitLabelTextsAry.push(splitLabelText);
						
						year = date.fullYear;
					}
					startIndex++;
				}
				genLabelCenterPositionsBySplit();
			}
			else if(timeSpan > ConfigManager.QUARTER_TIME_VALUE * 3.5)//小于1.7年大于3.5个季度，按季度显示
			{
				date = _data[0] as Date;
				
				year = date.fullYear;
				
				month = Math.floor(date.month / 3);
				
				if(month == 0)
				{
					splitLabelText = year + "年" + (month * 3 + 1) + "-" + (month * 3 + 3) + "月";
				}
				else
				{
					splitLabelText = (month * 3 + 1) + "-" + (month * 3 + 3) + "月";
				}
				
				_splitPositionsAry.push(realPadding);
				_splitLabelTextsAry.push(splitLabelText);
				
				startIndex = 1;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					var monthTmp:int = Math.floor(date.month / 3);
					if(monthTmp != month)
					{
						splitPos = realPadding + startIndex * _unitSize;
						year = date.fullYear;
						
						if(monthTmp == 0)
						{
							splitLabelText = year + "年" + (monthTmp * 3 + 1) + "-" + (monthTmp * 3 + 3) + "月";
						}
						else
						{
							splitLabelText = (monthTmp * 3 + 1) + "-" + (monthTmp * 3 + 3) + "月";
						}
						_splitPositionsAry.push(splitPos);
						_splitLabelTextsAry.push(splitLabelText);
						month = monthTmp;
					}
					startIndex++;
				}
				
				genLabelCenterPositionsBySplit();
			}
			else if(timeSpan > ConfigManager.MONTH_TIME_VALUE * 2.3)//小于3.5个季度大于2.3个月，按月显示
			{
				date = _data[0] as Date;
				month = date.month;
				year = date.fullYear;
				
				_splitPositionsAry.push(realPadding);
				_splitLabelTextsAry.push(date.month + 1 + "月");
				
				startIndex = 1;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					if(date.month != month)
					{
						splitPos = realPadding + startIndex * _unitSize;
						
						if(date.fullYear != year)
						{
							splitLabelText = date.fullYear + "年" + (date.month + 1) + "月";
							year = date.fullYear;
						}
						else
						{
							splitLabelText = (date.month + 1) + "月";
						}
						_splitPositionsAry.push(splitPos);
						_splitLabelTextsAry.push(splitLabelText);
						month = date.month;
					}
					startIndex++;
				}
				genLabelCenterPositionsBySplit();
			}
			else if(timeSpan > ConfigManager.WEEK_TIME_VALUE * 4)//小于2.3个月大于4周，按周显示
			{
				startIndex = 0;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					if(date.day == 1)
					{
						splitPos = realPadding + startIndex * _unitSize;
						splitLabelCenterPos = realPadding + startIndex * _unitSize;
						
						if(date.month != month)
						{
							splitLabelText = date.month + 1 + "月" + date.date + "日";
							month = date.month;
						}
						else
						{
							splitLabelText = date.date + "日";
						}
						_splitPositionsAry.push(splitPos);
						_splitLabelTextsAry.push(splitLabelText);
						_splitLabelCenterPosAry.push(splitLabelCenterPos);
					}
					
					startIndex++;
				}
			}
			else if(timeSpan > ConfigManager.DAY_TIME_VALUE * 1)//小于4周大于1天，按天显示
			{
				startIndex = 0;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					splitPos = realPadding + startIndex * _unitSize;
					splitLabelCenterPos = realPadding + startIndex * _unitSize;
					
					if(date.month != month)
					{
						splitLabelText = date.month + 1 + "月" + date.date + "日";
						month = date.month;
					}
					else
					{
						splitLabelText = date.date + "日";
					}
					
					_splitPositionsAry.push(splitPos);
					_splitLabelCenterPosAry.push(splitLabelCenterPos);
					_splitLabelTextsAry.push(splitLabelText);
					
					startIndex++;
				}
			}
			else if(timeSpan > ConfigManager.HOUR_TIME_VALUE)//小于等于1天，大于1小时,按小时显示
			{
				startIndex = 0;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					splitPos = realPadding + startIndex * _unitSize;
					splitLabelCenterPos = realPadding + startIndex * _unitSize;
					if(ConfigManager.minShowUnit == "5分钟")
					{
						if(date.hours != hour)
						{
							
							if((_unitSize * 12) < 30)
							{
								if((date.hours % 2) == 0)
								{
									splitLabelText = date.hours + "时";// + date.minutes + "分";
								}
								else
								{
									splitLabelText = "";
								}
							}
							else
							{
								splitLabelText = date.hours + "时";// + date.minutes + "分";
							}
							hour = date.hours;
						}
						else
						{
							splitLabelText = "";//date.minutes + "分";
						}
					}
					else
					{
						if(date.date != day)
						{
							splitLabelText = date.date + 1 + "日" + date.hours + "时";
							day = date.date;
						}
						else
						{
							splitLabelText = date.hours + "时";
						}
					}
					
					_splitPositionsAry.push(splitPos);
					_splitLabelCenterPosAry.push(splitLabelCenterPos);
					_splitLabelTextsAry.push(splitLabelText);
					
					startIndex++;
				}
			}
			else if(timeSpan > ConfigManager.MINUTE_TIME_VALUE)//小于1小时,大于1分钟，按分钟显示
			{
				startIndex = 0;
				
				while(startIndex < dataCount)
				{
					date = _data[startIndex] as Date;
					
					splitPos = realPadding + startIndex * _unitSize;
					splitLabelCenterPos = realPadding + startIndex * _unitSize;
					
					if(date.hours != hour)
					{
						splitLabelText = date.hours + "时" + date.minutes + "分";
						hour = date.hours;
					}
					else
					{
						splitLabelText = date.minutes + "分";
					}
					
					_splitPositionsAry.push(splitPos);
					_splitLabelCenterPosAry.push(splitLabelCenterPos);
					_splitLabelTextsAry.push(splitLabelText);
					
					startIndex++;
				}
			}
		}
		
		protected function drawMask() : void
		{
			if(_maskLayer == null)
			{
				_maskLayer = new Shape();
				addChild(_maskLayer);
				this.mask = _maskLayer;
			}
			
			var g:Graphics = _maskLayer.graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			g.drawRect(0, -100, _width, _height + 200);
			g.endFill();
		}
		
		protected function genLabelCenterPositionsBySplit():void
		{
			var splitLength:int = _splitPositionsAry.length;
			
			if(splitLength > 1)
			{
				var tmp1:Number = _splitPositionsAry[_splitPositionsAry.length - 1];
				var tmp2:Number = _splitPositionsAry[_splitPositionsAry.length - 2];
				var tmp:Number = tmp1 + (tmp1 - tmp2);
				_splitPositionsAry.push(tmp);
			}
			
			var i:int = 0;
			while(i < splitLength)
			{
				var tmp3:Number = (_splitPositionsAry[i] + _splitPositionsAry[i + 1]) / 2;
				_splitLabelCenterPosAry.push(tmp3);
				i++;
			}
		}
		
		override protected function locateAxisLabels():void
		{
			var count:int = _axisLabels.length;
			var labelPadding:Number = _styles[AXIS_LABEL_PADDING];
			
			var i:int = 0;
			
			var curPos:Number;
			
			var tf:TextField;
			
			switch(_placement)
			{
				case GridPlacement.BOTTOM:
				{
					i = 0;
					while(i < count)
					{
						curPos = _splitLabelCenterPosAry[i];
						tf = _axisLabels[i];
						tf.width = _unitSize;
						tf.x = curPos - tf.width / 2;
						if(ConfigManager.showIntactLabel)
						{
							if(i == 0)
							{
								tf.x = curPos;
							}
							else if(i == (count - 1))
							{
								tf.x = curPos - tf.width;
							}
						}
						tf.y = _height + labelPadding;
						i++;
					}
					break;
				}
				case GridPlacement.TOP:
				{
					i = 0;
					while(i < count)
					{
						curPos = _splitLabelCenterPosAry[i];
						tf = _axisLabels[i];
						tf.width = _unitSize;
						tf.x = curPos - tf.width / 2;
						tf.y = -labelPadding - tf.height;
						i++;
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override protected function genAxisLabels():void
		{
			var textField:TextField;
			if(_axisLabels)
			{
				for each(textField in _axisLabels)
				{
					if(this.contains(textField))
					{
						this.removeChild(textField);
					}
				}
			}
			_axisLabels = [];
			
			for each(var str:String in _splitLabelTextsAry)
			{
				textField = new TextField();
				textField.defaultTextFormat = _styles[AXIS_LABEL_TEXT_FORMAT];
				textField.autoSize = "left";
				if(_styles[AXIS_LABEL_MULTILINE])
				{
					textField.multiline = true;
					textField.wordWrap = true;
				}
				textField.htmlText = str;
				addChild(textField);
				_axisLabels.push(textField);
			}
		}
		
		override protected function drawSplitLine():void
		{
			if (_splitLineLayer == null)
            {
                _splitLineLayer = new Shape();
                addChildAt(_splitLineLayer, 0);
            }
            
            var g:Graphics = _splitLineLayer.graphics;
            g.clear();
            
            var ls:LineStyle = _styles[SPLIT_LINE_STYLE] as LineStyle;
            g.lineStyle(ls.thickness,ls.color,ls.alpha);
            
            for each(var pos:Number in _splitPositionsAry)
            {
            	g.moveTo(pos, 0);
            	g.lineTo(pos, _height);
            }
		}
		
		override protected function applyChanges():void
		{
			if(isInvalid(INVALID_TYPE_SIZE))
			{
				drawMask();
			}
			
			if(_data == null)
			{
				if(_showAxisLine)
				{
					drawAxisLine();
				}
				return;
			}
			
			if(isInvalidOnly(INVALID_TYPE_SIZE) || isInvalidOnly(INVALID_TYPE_PADDIG))
			{
				if(isInvalid(INVALID_TYPE_UNIT_SIZE))
				{
					calculateUnitSize();
				}
				if(_showSplitLine || _showAxisLabel || _showTick)
				{
					calculateDateSplit();
				}
				drawLines();
				if(_showAxisLabel && _axisLabels)
				{
					locateAxisLabels();
				}
			}
			else
			{
				if(isInvalid(INVALID_TYPE_UNIT_SIZE))
				{
					calculateUnitSize();
				}
				if(_showSplitLine || _showAxisLabel || _showTick)
				{
					calculateDateSplit();
				}
				drawLines();
				if(_showTick)
				{
					_ticksLayer.visible = true;
				}
				else if(_ticksLayer)
				{
					_ticksLayer.visible = false;
				}
				
				if(_showAxisLine)
				{
					_axisLineLayer.visible = true;
				}
				else if(_axisLineLayer)
				{
					_axisLineLayer.visible = false;
				}
				
				if(_showSplitLine)
				{
					_splitLineLayer.visible = true;
				}
				else if(_splitLineLayer)
				{
					_splitLineLayer.visible = false;
				}
				
				if(_showAxisLabel)
				{
					if(_data)
					{
						genAxisLabels();
						locateAxisLabels();
						for each(var tf:TextField in _axisLabels)
						{
							tf.visible = true;
						}
					}
				}
				else if(_axisLabels)
				{
					for each(var textField:TextField in _axisLabels)
					{
						textField.visible = false;
					}
				}
			}
		}
		
		override public function set placement(type:String):void
		{
			if(_placement == type) return;
			
			if(type != GridPlacement.TOP && type != GridPlacement.BOTTOM && 
			type != GridPlacement.LEFT && type != GridPlacement.RIGHT)
			{
				throw new Error("The placement given is not valid");
			}
			_placement = type;
			invalidate(INVALID_TYPE_PLACEMENT);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
	}
}