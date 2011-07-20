package road.v.core
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	public class Grid extends DVBase
	{
		public static const INVALID_TYPE_PLACEMENT:String = "placement";
		protected var _placement:String = GridPlacement.BOTTOM;
		
		public static const INVALID_TYPE_UNIT_SIZE:String = "unitSize";
		protected var _unitSize:Number = 0;
		
		public static const INVALID_TYPE_SHOW_TICK:String = "showTick";
		protected var _showTick:Boolean = false;
		
		public static const INVALID_TYPE_SHOW_AXIS_LINE:String = "showAxisLine";
		protected var _showAxisLine:Boolean = false;
		
		public static const INVALID_TYPE_SHOW_AXIS_LABEL:String = "showAxisLabel";
		protected var _showAxisLabel:Boolean = false;
		
		public static const INVALID_TYPE_SHOW_SPLIT_LINE:String = "showSplitLine";
		protected var _showSplitLine:Boolean = false;
		
		//刻度，轴，分隔线图形对象
		protected var _ticksLayer:Shape;//刻度层
		protected var _axisLineLayer:Shape;//轴层
		protected var _splitLineLayer:Shape;//分隔线层
		
		//轴标签数组
		protected var _axisLabels:Array;
		
		
		//样式Key关键字
		public static const AXIS_LINE_STYLE:String = "axisLineStyle";
		public static const SPLIT_LINE_STYLE:String = "splitLineStyle";
		public static const TICK_STYLE:String = "tickStyle";
		public static const TICK_LENGTH:String = "tickLength";
		public static const AXIS_LABEL_TEXT_FORMAT:String = "axisLabelTextFormat";
		public static const AXIS_LABEL_PADDING:String = "axisLabelPadding";
		public static const AXIS_LABEL_MULTILINE:String = "axisLabelMultiLine";
		
		
		//==========================属性==========================
		public function get showTick():Boolean
		{
			return _showTick;
		}
		public function set showTick(value:Boolean):void
		{
			if(_showTick == value) return;
			
			_showTick = value;
			invalidate(INVALID_TYPE_SHOW_TICK);
		}
		
		public function get showAxisLine():Boolean
		{
			return _showAxisLine;
		}
		public function set showAxisLine(value:Boolean):void
		{
			if(_showAxisLine == value) return;
			
			_showAxisLine = value;
			invalidate(INVALID_TYPE_SHOW_AXIS_LINE);
		}
		
		public function get showAxisLabel():Boolean
		{
			return _showAxisLabel;
		}
		public function set showAxisLabel(value:Boolean):void
		{
			if(_showAxisLabel == value) return;
			
			_showAxisLabel = value;
			invalidate(INVALID_TYPE_SHOW_AXIS_LABEL);
		}
		
		public function get showSplitLine():Boolean
		{
			return _showSplitLine;
		}
		public function set showSplitLine(value:Boolean):void
		{
			if(_showSplitLine == value) return;
			
			_showSplitLine = value;
			invalidate(INVALID_TYPE_SHOW_SPLIT_LINE);
		}
		
		public function get placement():String
		{
			return _placement;
		}
		public function set placement(value:String):void
		{
			if(_placement == value) return;
			if(_placement != GridPlacement.TOP &&
			_placement != GridPlacement.BOTTOM &&
			_placement != GridPlacement.LEFT &&
			_placement != GridPlacement.RIGHT)
				throw new Error("The placement given is not valid");
			
			_placement = value;
			invalidate(INVALID_TYPE_PLACEMENT);
		}
		
		public function get unitSize():Number
		{
			if(isInvalid(INVALID_TYPE_UNIT_SIZE))
			{
				calculateUnitSize();
				_invalidHash[INVALID_TYPE_UNIT_SIZE] = false;
				if(isInvalidOnly(INVALID_TYPE_UNIT_SIZE))
				{
					_invalid = false;
				}
			}
			return _unitSize;
		}
		
		//===========================覆盖===========================
		override protected function initStyle():void
		{
			_styles[AXIS_LINE_STYLE] = new LineStyle(0x888888, 1, 1);
			_styles[AXIS_LABEL_MULTILINE] = false;
			_styles[AXIS_LABEL_PADDING] = 2;
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			_styles[AXIS_LABEL_TEXT_FORMAT] = tf;
			
			_styles[SPLIT_LINE_STYLE] = new LineStyle(0xDDDDDD, 1, 1);
			_styles[TICK_STYLE] = new LineStyle(0x999999, 1, 1);
			_styles[TICK_LENGTH] = 4;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		override public function set data(o:*):void
		{
			super.data = o;
            invalidate(INVALID_TYPE_UNIT_SIZE);
		}
		
		//===========================Grid方法===========================
		protected function calculateUnitSize():void
		{
			
		}
		
		protected function locateAxisLabels():void
		{
			
		}
		
		protected function drawAxisLine():void
		{
			if(_axisLineLayer == null)
			{
				_axisLineLayer = new Shape();
				addChildAt(_axisLineLayer,0);
			}
			
			var g:Graphics = _axisLineLayer.graphics;
			g.clear();
			
			var ls:LineStyle = _styles[AXIS_LINE_STYLE] as LineStyle;
			g.lineStyle(ls.thickness,ls.color,ls.alpha);
			
			switch(_placement)
			{
				case GridPlacement.TOP:
				{
					g.moveTo(0, 0);
					g.lineTo(_width, 0);
					break;
				}
				case GridPlacement.BOTTOM:
				{
					g.moveTo(0, _height);
					g.lineTo(_width, _height);
					break;
				}
				case GridPlacement.LEFT:
				{
					g.moveTo(0, 0)
					g.lineTo(0, _height);
					break;
				}
				case GridPlacement.RIGHT:
				{
					g.moveTo(_width, 0);
					g.lineTo(_width, _height);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function drawSplitLine():void
		{
			
		}
		
		protected function drawTicks():void
		{
			
		}
		
		protected function genAxisLabels():void
		{
			
		}
		
		protected function drawLines():void
		{
			if(_showAxisLine)
			{
				drawAxisLine();
			}
			if(_showSplitLine)
			{
				drawSplitLine();
			}
			if(_showTick)
			{
				drawTicks();
			}
		}
	}
}