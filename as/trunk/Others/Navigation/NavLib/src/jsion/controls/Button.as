package jsion.controls
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	public class Button extends Sprite implements IDispose
	{
		private var _container:MovieClip;
		
		private var _up:DisplayObject;
		private var _over:DisplayObject;
		
		private var _txt:TextField;
		
		private var lightingFilter:ColorMatrixFilter;
		
		private var _selected:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected) light();
			else normal();
		}

		
		public function Button(up:DisplayObject, over:DisplayObject)
		{
			_up = up;
			_over = over;
			buttonMode = true;
			init();
			initEvent();
		}
		
		private function init():void
		{
			if(_over) _over.visible = false;
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			lightingFilter = new ColorMatrixFilter(matrix);
			
			_container = new MovieClip();
			_container.buttonMode = true;
			addChild(_container);
			
			if(_up) _container.addChild(_up);
			if(_over) _container.addChild(_over);
		}
		
		private function uninit():void
		{
			DisposeHelper.dispose(_up);
			_up = null;
			
			DisposeHelper.dispose(_over);
			_over = null;
			
			if(_container) _container.filters = [];
			DisposeHelper.dispose(_container);
			_container = null;
			
			DisposeHelper.dispose(_txt);
			_txt = null;
			
			lightingFilter = null;
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, __overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, __outHandler);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, __overHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __outHandler);
		}
		
		private function __overHandler(e:MouseEvent):void
		{
			if(_selected) return;
			light();
		}
		
		private function light():void
		{
			if(_over) _over.visible = true;
			else _container.filters = [lightingFilter];
		}
		
		private function __outHandler(e:MouseEvent):void
		{
			if(_selected) return;
			normal();
		}
		
		private function normal():void
		{
			if(_over) _over.visible = false;
			else _container.filters = null;
		}

		public function get txt():TextField
		{
			return _txt;
		}

		public function set txt(value:TextField):void
		{
			if(_txt == value) return;
			DisposeHelper.dispose(_txt);
			_txt = value;
			
			if(_txt != null && _up == null && _over == null)
			{
				_container.graphics.beginFill(0xFFFFFF, 0);
				_container.graphics.drawRect(0, 0, _txt.width, _txt.height);
				_container.graphics.endFill();
			}
			
//			refreshTextPos();
			
			if(_txt)
			{
				_txt.selectable = false;
				_txt.mouseEnabled = false;
				addChild(_txt);
			}
		}
		
		public function refreshTextPos():void
		{
			if(_txt)
			{
				if(_container)
				{
					_txt.x = (_container.width - _txt.width) / 2;
					_txt.y = (_container.height - _txt.height) / 2;
				}
			}
		}
		
		public function get isExists():Boolean
		{
			if(_up == null && _over == null && _txt == null) return false;
			if(_up == null && _over == null && _txt != null && StringHelper.isNullOrEmpty(_txt.text)) return false;
			return true;
		}
		
		public function dispose():void
		{
			removeEvent();
			uninit();
			if(parent) parent.removeChild(this);
		}

	}
}