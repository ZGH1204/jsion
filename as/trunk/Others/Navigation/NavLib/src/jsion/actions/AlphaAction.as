package jsion.actions
{
	import com.StageReference;
	
	import flash.display.DisplayObject;

	public class AlphaAction extends BaseAction
	{
		public static const TIME_SPAN:Number = 0.5;//秒
		
		private var _display:DisplayObject, _targetAlpha:Number;
		
		private var _speedAlpha:Number;
		
		private var _targetAlphaMore:Boolean;
		
		private var _finishCallback:Function;
		
		public function AlphaAction(display:DisplayObject, targetAlpha:Number, finishCallback:Function)
		{
			_display = display;
			_targetAlpha = targetAlpha;
			_finishCallback = finishCallback;
			
			_speedAlpha = (_targetAlpha - _display.alpha) / (StageReference.stage.frameRate * TIME_SPAN);
			
			if(_display.alpha > _targetAlpha) _targetAlphaMore = false;
			else _targetAlphaMore = true;
		}
		
		override public function execute():void
		{
			if(_display.alpha != _targetAlpha) _display.alpha += _speedAlpha;
			
			if(_targetAlphaMore)
			{
				if(_display.alpha >= _targetAlpha)
				{
					_display.alpha = _targetAlpha;
					finish();
				}
			}
			else
			{
				if(_display.alpha <= _targetAlpha)
				{
					_display.alpha = _targetAlpha;
					finish();
				}
			}
		}
		
		private function finish():void
		{
			_isFinished = true;
			_display = null;
			if(_finishCallback != null) _finishCallback();
			_finishCallback = null;
		}
	}
}