package road.v.grids
{
	import flash.display.*;
	import flash.text.*;
	
	import road.v.core.*;

	/**
	 * 
	 * _data数据类型为日期数据类型的数组
	 * @author 7Road
	 * 
	 */	
	public class CategoryGrid extends Grid
	{
        protected var _padding:Number = 0;
        public static const INVALID_TYPE_PADDIG:String = "padding";
        

		public function CategoryGrid()
		{
            _placement = GridPlacement.BOTTOM;
            _showSplitLine = false;
		}
		
		override protected function drawSplitLine():void
		{
			if(_splitLineLayer == null)
			{
				_splitLineLayer = new Shape();
				addChildAt(_splitLineLayer, 0);
			}
			
			var curSplitXPos:Number;
			var curSplitYPos:Number;
			
			var g:Graphics = _splitLineLayer.graphics;
			g.clear();
			
			var ls:LineStyle = _styles[SPLIT_LINE_STYLE] as LineStyle;
			g.lineStyle(ls.thickness,ls.color,ls.alpha);
			
			var startIndex:int = _padding == 0 ? 1 : 0;
			var dataCount:int = _padding == 0 ? _data.length - 1 : _data.length;
			var paddingLeft:Number = _padding <= 1 ? _padding * _unitSize : _padding;
			
			if(_placement == GridPlacement.BOTTOM || _placement == GridPlacement.TOP)
			{
				while(startIndex < dataCount)
				{
					curSplitXPos = paddingLeft + startIndex * _unitSize;
					g.moveTo(curSplitXPos, 0);
					g.lineTo(curSplitXPos, _height);
					startIndex++;
				}
			}
			else
			{
				while(startIndex < dataCount)
				{
					curSplitYPos = paddingLeft + startIndex * _unitSize;
					g.moveTo(0, curSplitYPos);
					g.lineTo(_width, curSplitYPos);
					startIndex++;
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
			
			for each(var key:String in _data)
			{
				textField = new TextField();
				textField.defaultTextFormat = _styles[AXIS_LABEL_TEXT_FORMAT] as TextFormat;
				textField.autoSize = TextFieldAutoSize.LEFT;
				
				if(_styles[AXIS_LABEL_MULTILINE])
				{
					textField.multiline = true;
					textField.wordWrap = true;
				}
				else
				{
					textField.multiline = false;
					textField.wordWrap = false;
				}
				textField.htmlText = key;
				addChild(textField);
				_axisLabels.push(textField);
			}
		}
		
		override protected function locateAxisLabels():void
		{
			var curLabelIndex:int = 0;
			var curLabelXPos:Number;
			var curLabelYPos:Number;
			var textField:TextField;
			var lablesCount:int = _axisLabels.length;
			var intactPadding:Number = _padding <= 1 ? (_padding * _unitSize) : _padding;
			var labelPadding:Number = _styles[AXIS_LABEL_PADDING] as Number;
			
			switch(_placement)
			{
				case GridPlacement.BOTTOM:
				{
					while(curLabelIndex < lablesCount)
					{
						curLabelXPos = intactPadding + curLabelIndex * _unitSize;
						textField = _axisLabels[curLabelIndex] as TextField;
						textField.width = _unitSize;
						textField.x = curLabelXPos - textField.width / 2;
						textField.y = _height + labelPadding;
						curLabelIndex++;
					}
					break;
				}
				case GridPlacement.TOP:
				{
					while(curLabelIndex < lablesCount)
					{
						curLabelXPos = intactPadding + curLabelIndex * _unitSize;
						textField = _axisLabels[curLabelIndex] as TextField;
						textField.width = _unitSize;
						textField.x = curLabelXPos - textField.width / 2;
						textField.y = -labelPadding - textField.height;
						curLabelIndex++;
					}
					break;
				}
				case GridPlacement.LEFT:
				{
					while(curLabelIndex < lablesCount)
					{
						curLabelYPos = intactPadding + curLabelIndex * _unitSize;
						textField = _axisLabels[curLabelIndex] as TextField;
						textField.x = -labelPadding - textField.width;
						textField.y = curLabelYPos - textField.textHeight / 2;
						curLabelIndex++;
					}
					break;
				}
				case GridPlacement.RIGHT:
				{
					while(curLabelIndex < lablesCount)
					{
						curLabelYPos = intactPadding + curLabelIndex * _unitSize;
						textField = _axisLabels[curLabelIndex] as TextField;
						textField.x = _width + labelPadding;
						textField.y = curLabelYPos - textField.textHeight / 2;
						curLabelIndex++;
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override protected function calculateUnitSize():void
		{
			var calcValue:Number;
			
			if(_data)
			{
				if(_placement == GridPlacement.TOP || _placement == GridPlacement.BOTTOM)
				{
					calcValue = _width;
				}
				else
				{
					calcValue = _height;
				}
				
				if(_padding <= 1)
				{
					_unitSize = calcValue / (_data.length - 1 + 2 * _padding);
				}
				else
				{
					_unitSize = (calcValue - 2 * _padding) / (_data.length - 1);
				}
			}
		}
		
		override protected function applyChanges():void
		{
			var textField:TextField;
			if(_data == null)
			{
				if(_showAxisLine)
				{
					drawAxisLine();
				}
				return;
			}
			
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
				drawLines();
			
			if(isInvalidOnly(INVALID_TYPE_SIZE) || isInvalidOnly(INVALID_TYPE_PADDIG))
			{
				if(_showAxisLabel && _axisLabels)
				{
					locateAxisLabels();
				}
			}
			else
			{
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
						
						for each(textField in _axisLabels)
						{
							textField.visible = true;
						}
					}
				}
				else if(_axisLabels)
				{
                    for each (textField in _axisLabels)
                    {
                        textField.visible = false;
                    }
				}
			}
		}
		
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(isNaN(value) || _padding == value || value < 0) return;
			
			_padding = value;
			invalidate(INVALID_TYPE_PADDIG);
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		//X轴相关
		public function getIndexByPosition(pos:Number):uint
		{
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
			
			var paddingLeft:Number = _padding <= 1 ? _padding * _unitSize : _padding;
			var index:Number = Math.round((pos - paddingLeft) / _unitSize);
			index = Math.max(index, 0);
			index = Math.min(index, _data.length - 1);
			return index;
		}
		
		public function getPositionByIndex(inded:uint):Number
		{
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
			}
			
			var paddingLeft:Number = _padding <= 1 ? _padding * _unitSize : _padding;
			return paddingLeft + _unitSize * inded;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}