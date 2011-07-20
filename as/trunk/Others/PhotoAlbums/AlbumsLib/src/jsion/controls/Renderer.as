package jsion.controls
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Renderer extends Bitmap implements IDispose
	{
		public static const ZERO_POINT:Point = new Point();
		
		private var _sprite:Sprite;
		private var _curFrame:int;
		private var _frameInterval:int;
		private var _sourceBmd:BitmapData;
		
		private var _camreRect:Rectangle;
		
		public function Renderer(w:int, h:int, frameInterval:int, autoRender:Boolean = false)
		{
			super(new BitmapData(w, h));
			_frameInterval = frameInterval;
			_camreRect = new Rectangle(0, 0, w, h);
			
			if(autoRender)
			{
				_sprite = new Sprite();
				_sprite.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			render();
		}

		public function get sourceBmd():BitmapData
		{
			return _sourceBmd;
		}

		public function set sourceBmd(value:BitmapData):void
		{
			_sourceBmd = value;
			_curFrame = 0;
			_camreRect.x = _camreRect.y = 0;
		}
		
		public function render():void
		{
			if(_sourceBmd == null || _camreRect == null) return;
			
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect, 0x0);
			bitmapData.copyPixels(_sourceBmd, _camreRect, ZERO_POINT);
			bitmapData.unlock();
			
			_curFrame++;
			
			updateCamreRect();
		}
		
		private function updateCamreRect():void
		{
			if(_curFrame <= _frameInterval || _sourceBmd == null || _camreRect == null) return;
			
			_camreRect.x = _camreRect.x + _camreRect.width;
			
			if(_camreRect.x > _sourceBmd.width)
			{
				_camreRect.x = 0;
				
				_camreRect.y = _camreRect.y + _camreRect.height;
				
				if(_camreRect.y > _sourceBmd.height) _camreRect.y = 0;
			}
		}
		
		public function dispose():void
		{
			if(_sprite) _sprite.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			DisposeHelper.dispose(_sprite);
			_sprite = null;
			
			DisposeHelper.dispose(bitmapData);
			bitmapData = new BitmapData(1,1);
			
			_camreRect = null;
			_sourceBmd = null;
			if(parent) parent.removeChild(this);
		}
	}
}