package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.MatrixHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import jsion.contants.LayerType;
	
	public class Background extends Sprite implements IDispose
	{
		private var _display:DisplayObject;
		private var _layerOut:String = LayerType.TILE;
		
		private var _width:Number = 1, _height:Number = 1;
		
		public function Background(w:Number = 1, h:Number = 1)
		{
			width = w;
			height = h;
		}
		
		public function get display():DisplayObject
		{
			return _display;
		}
		
		public function set display(value:DisplayObject):void
		{
			DisposeHelper.dispose(_display);
			_display = value;
			addChild(_display);
		}
		
		public function get layerOut():String
		{
			return _layerOut;
		}
		
		public function set layerOut(value:String):void
		{
			if(value != LayerType.TILE && 
			   value != LayerType.STRETCH && 
			   value != LayerType.CENTER && 
			   value != LayerType.DEFAULT) return;
			_layerOut = value;
		}
		
		public function refresh():void
		{
			switch(_layerOut)
			{
				case LayerType.TILE:
				{
					tileDisplay();
					break;
				}
				case LayerType.STRETCH:
				{
					stretchDisplay();
					break;
				}
				case LayerType.CENTER:
				{
					centerDisplay();
					break;
				}
			}
		}
		
		private function tileDisplay():void
		{
			if(_display)
			{
				if(_display.width < _width || _display.height < _height)
				{
					var dBmd:BitmapData = new BitmapData(_display.width, _display.height);
					dBmd.draw(_display);
					
					var oldBmd:BitmapData = new BitmapData(_width, _display.height);
					var matrix:Matrix = new Matrix();
					var curWidth:Number = _display.x;
					matrix.translate(curWidth, 0);
					
					while(curWidth < oldBmd.width)
					{
						oldBmd.draw(dBmd, matrix);
						matrix.translate(dBmd.width, 0);
						curWidth += dBmd.width;
					}
					
					MatrixHelper.resetMatrix(matrix);
					curWidth = _display.x - dBmd.width;
					matrix.translate(curWidth, 0);
					
					while(curWidth > (dBmd.width * -1))
					{
						oldBmd.draw(dBmd, matrix);
						matrix.translate(dBmd.width, 0);
						curWidth -= dBmd.width;
					}
					
					
					var bmp:Bitmap = new Bitmap(new BitmapData(_width, _height));
					MatrixHelper.resetMatrix(matrix);
					var curHeight:Number = _display.y;
					matrix.translate(0, curHeight);
					
					while(curHeight < bmp.height)
					{
						bmp.bitmapData.draw(oldBmd, matrix);
						matrix.translate(0, oldBmd.height);
						curHeight += oldBmd.height;
					}
					
					MatrixHelper.resetMatrix(matrix);
					curHeight = _display.y - dBmd.height;
					matrix.translate(0, curHeight);
					
					while(curHeight > (oldBmd.height * -1))
					{
						bmp.bitmapData.draw(oldBmd, matrix);
						matrix.translate(0, oldBmd.height);
						curHeight -= oldBmd.height;
					}
					
					bmp.x = _display.x;
					bmp.y = _display.y;
					
					DisposeHelper.dispose(_display);
					
					_display = bmp;
					addChild(_display);
				}
			}
		}
		
		private function stretchDisplay():void
		{
			if(_display)
			{
				_display.width = _width;
				_display.height = _height;
			}
		}
		
		private function centerDisplay():void
		{
			if(_display)
			{
				_display.x = (_width - _display.width) / 2;
				_display.y = (_height - _display.height) / 2;
			}
		}
		
		
		
		
		
		
		
		
		
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if(value <= 0) return;
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if(value <= 0) return;
			_height = value;
		}
		
		public function dispose():void
		{
			DisposeHelper.dispose(_display);
			_display = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}