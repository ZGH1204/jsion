package jsion.actions
{
	import com.StageReference;
	
	import flash.display.DisplayObject;

	public class ScaleAction extends BaseAction
	{
		public static const TIME_SPAN:Number = 0.5;//秒
		
		private var _display:DisplayObject, _targetScaleX:Number, _targetScaleY:Number;
		
		private var _speedX:Number;
		private var _speedY:Number;
		
		private var _targetXMore:Boolean;
		private var _targetYMore:Boolean;
		
		public function ScaleAction(display:DisplayObject, targetScaleX:Number, targetScaleY:Number)
		{
			_display = display;
			_targetScaleX = targetScaleX;
			_targetScaleY = targetScaleY;
			
			_speedX = (_targetScaleX - _display.scaleX) / (StageReference.stage.frameRate * TIME_SPAN);
			_speedY = (_targetScaleY - _display.scaleY) / (StageReference.stage.frameRate * TIME_SPAN);
			
			if(_display.scaleX > _targetScaleX) _targetXMore = false;
			else _targetXMore = true;
			
			if(_display.scaleY > _targetScaleY) _targetYMore = false;
			else _targetYMore = true;
		}
		
		override public function execute():void
		{
			if(_display.scaleX != _targetScaleX) _display.scaleX += _speedX;
			if(_display.scaleY != _targetScaleY) _display.scaleY += _speedY;
			
			if(_targetXMore)
			{
				if(_display.scaleX >= _targetScaleX) _display.scaleX = _targetScaleX;
			}
			else
			{
				if(_display.scaleX <= _targetScaleX) _display.scaleX = _targetScaleX;
			}
			
			if(_targetYMore)
			{
				if(_display.scaleY >= _targetScaleY) _display.scaleY = _targetScaleY;
			}
			else
			{
				if(_display.scaleY <= _targetScaleY) _display.scaleY = _targetScaleY;
			}
			
			if(_display.scaleX == _targetScaleX && _display.scaleY == _targetScaleY) finish();
		}
		
		private function finish():void
		{
			_isFinished = true;
			_display = null;
		}
	}
}