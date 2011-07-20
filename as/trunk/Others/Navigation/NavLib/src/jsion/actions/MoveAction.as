package jsion.actions
{
	import com.StageReference;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class MoveAction extends BaseAction
	{
		public static const TIME_SPAN:Number = 0.5;//秒
		
		private var _target:Point;
		private var _display:DisplayObject;
		
		private var _targetAtLeft:Boolean;
		private var _targetAtUp:Boolean;
		
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		
		public function MoveAction(display:DisplayObject, target:Point)
		{
			_display = display;
			_target = target;
			
			_speedX = (_target.x - _display.x) / (StageReference.stage.frameRate * TIME_SPAN);
			_speedY = (_target.y - _display.y) / (StageReference.stage.frameRate * TIME_SPAN);
			
			if(_display.x > _target.x) _targetAtLeft = true;
			else _targetAtLeft = false;
			
			if(_display.y > _target.y) _targetAtUp = true;
			else _targetAtUp = false;
		}
		
		override public function execute():void
		{
			if(_display.x != _target.x) _display.x += _speedX;
			if(_display.y != _target.y) _display.y += _speedY;
			
			if(_targetAtLeft)
			{
				if(_display.x <= _target.x) _display.x = _target.x;
			}
			else
			{
				if(_display.x >= _target.x) _display.x = _target.x;
			}
			
			if(_targetAtUp)
			{
				if(_display.y <= _target.y) _display.y = _target.y;
			}
			else
			{
				if(_display.y >= _target.y) _display.y = _target.y;
			}
			
			if(_display.x == _target.x && _display.y == _target.y) finish();
		}
		
		private function finish():void
		{
			_isFinished = true;
			_display = null;
			_target = null;
		}
	}
}