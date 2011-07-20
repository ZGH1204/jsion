package jsion.actions
{
	import com.StageReference;
	
	import flash.display.Shape;
	import flash.geom.Point;

	public class MaskCloseAction extends BaseAction
	{
		public static const TIME_SPAN:Number = 0.5;//秒
		
		private var _mask:Shape, _callback:Function;
		
		private var _speedWidth:Number, _speedHeight:Number;
		
		private var _curX:Number = 0, _curY:Number = 0;
		private var _curWidth:Number = 0, _curHeight:Number = 0;
		
		private var _allWidth:Number = StageReference.stage.stageWidth;
		private var _allHeight:Number = StageReference.stage.stageHeight;
		
		private var _minX:Number = 0, _minY:Number = 0;
		
		public function MaskCloseAction(mask:Shape, callback:Function)
		{
			_mask = mask;
			_callback = callback;
			
			_curX = _minX;
			_curY = _minY;
			
			_curWidth = _allWidth / 2;
			_curHeight = _allHeight / 2;
			
			_speedWidth = _curWidth / (StageReference.stage.frameRate * TIME_SPAN);
			_speedHeight = _curHeight / (StageReference.stage.frameRate * TIME_SPAN);
		}
		
		override public function execute():void
		{
			_curX += _speedWidth;
			_curY += _speedHeight;
			_curWidth -= _speedWidth;
			_curHeight -= _speedHeight;
			
			if(_curWidth <= 0)
			{
				_curWidth = 0;
			}
			
			if(_curHeight <= 0)
			{
				_curHeight = 0;
			}
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x0);
			_mask.graphics.drawRect(_curX, _curY, _curWidth * 2, _curHeight * 2);
			_mask.graphics.endFill();
			
			if(_curWidth == 0 || _curHeight == 0) finish();
		}
		
		private function finish():void
		{
			_isFinished = true;
			_mask = null;
			if(_callback != null) _callback();
			_callback = null;
		}
	}
}