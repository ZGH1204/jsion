package jsion.gpu2d
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jsion.IDispose;
	
	public class GPUObj2D implements IDispose
	{
		public var parent:GPUObj2D;
		public var children:Array;
		
		public var vMatrix:Matrix3D = new Matrix3D();
		public var wMatrix:Matrix3D = new Matrix3D();
		public var selfMatrix:Matrix3D = new Matrix3D();
		
		protected var m_view:GPUView2D;
		protected var m_texture:UVTexture;
		protected var m_program:Program3D;
		protected var m_change:Boolean = true;
		
		private var m_width:Number;
		private var m_height:Number;
		private var m_offsetX:Number;
		private var m_offsetY:Number;
		private var m_x:Number = 0;
		private var m_y:Number = 0;
		private var m_scaleX:Number = 1;
		private var m_scaleY:Number = 1;
		private var m_rotation:Number = 0;
		private var m_colorTransform:ColorTransform;
		private var m_colorMulData:Vector.<Number>;
		private var m_colorAddData:Vector.<Number>;
		
		private var m_bitmapData:BitmapData;
		
		public function GPUObj2D(w:Number, h:Number, bmd:BitmapData, view:GPUView2D, offsetX:Number = NaN, offsetY:Number = NaN)
		{
			m_width = w;
			m_height = h;
			m_view = view;
			
			setBitmapData(bmd, offsetX, offsetY);
			m_program = view.getOrCreateProgram(m_colorTransform);
		}
		
		public function get change():Boolean
		{
			return m_change;
		}
		
		public function set change(value:Boolean):void
		{
			m_change = value;
		}

		public function get width():Number
		{
			return m_width;
		}

		public function set width(value:Number):void
		{
			m_width = value;
		}

		public function get height():Number
		{
			return m_height;
		}

		public function set height(value:Number):void
		{
			m_height = value;
		}

		public function get offsetX():Number
		{
			return -m_offsetX;
		}

		public function set offsetX(value:Number):void
		{
			m_offsetX = -value;
			
			updateSelfMatrix();
		}

		public function get offsetY():Number
		{
			return -m_offsetY;
		}

		public function set offsetY(value:Number):void
		{
			m_offsetY = -value;
			
			updateSelfMatrix();
		}

		public function get x():Number
		{
			return m_x;
		}

		public function set x(value:Number):void
		{
			m_x = value;
			change = true;
		}

		public function get y():Number
		{
			return m_y;
		}

		public function set y(value:Number):void
		{
			m_y = value;
			change = true;
		}

		public function get scaleX():Number
		{
			return m_scaleX;
		}

		public function set scaleX(value:Number):void
		{
			m_scaleX = value;
			change = true;
		}

		public function get scaleY():Number
		{
			return m_scaleY;
		}

		public function set scaleY(value:Number):void
		{
			m_scaleY = value;
			change = true;
		}

		public function get rotation():Number
		{
			return m_rotation;
		}

		public function set rotation(value:Number):void
		{
			m_rotation = value;
			change = true;
		}

		public function get colorTransform():ColorTransform 
		{
			return m_colorTransform;
		}
		
		public function set colorTransform(value:ColorTransform):void 
		{
			m_colorTransform = value;
			
			if(m_colorTransform)
			{
				m_colorMulData = Vector.<Number>([value.redMultiplier, value.greenMultiplier, value.blueMultiplier, value.alphaMultiplier]);
				m_colorAddData = Vector.<Number>([value.redOffset, value.greenOffset, value.blueOffset, value.alphaOffset]);
			}
			
			m_program = m_view.getOrCreateProgram(m_colorTransform);
		}
		
		public function get bitmapData():BitmapData 
		{
			return m_bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void 
		{
			m_bitmapData = value;
		}
		
		public function get texture():UVTexture 
		{
			return m_texture;
		}
		
		public function set texture(value:UVTexture):void 
		{
			m_texture = value;
		}
		
		public function setBitmapData(bmd:BitmapData, offsetX:Number = NaN, offsetY:Number = NaN):void
		{
			bitmapData = bmd;
			
			if(bmd) texture = m_view.getTexture(bmd);
			
			if(isNaN(offsetX))
			{
				m_offsetX = 0;
			}
			else
			{
				m_offsetX = offsetX;
			}
			
			if(isNaN(offsetY))
			{
				m_offsetY = 0;
			}
			else
			{
				m_offsetY = offsetY;
			}
			
			updateSelfMatrix();
		}
		
		private function updateSelfMatrix():void
		{
			selfMatrix.identity();
			selfMatrix.appendTranslation(m_offsetX / m_width, -m_offsetY / m_height, 0);
			selfMatrix.appendScale(m_width, m_height, 1);
		}
		
		public function add(obj:GPUObj2D):GPUObj2D
		{
			if(children == null) children = [];
			
			if(obj.parent) obj.parent.remove(obj);
			
			children.push(obj);
			obj.parent = this;
			
			return obj;
		}
		
		public function remove(ob2d:GPUObj2D):GPUObj2D
		{
			if (children == null) return null;
			
			for (var i:int = 0; i < children.length;i++)
			{
				var o:GPUObj2D = children[i];
				
				if (o == ob2d)
				{
					children.splice(i, 1);
					ob2d.parent = null;
					return ob2d;
				}
			}
			
			return null;
		}
		
		public function recompose():void
		{
			change = false;
			vMatrix.identity();
			vMatrix.appendScale(m_scaleX, m_scaleY, 1);
			vMatrix.appendRotation( -m_rotation, Vector3D.Z_AXIS);
			vMatrix.appendTranslation(m_x, -m_y, 0);
		}
		
		public function update():void
		{
			if (m_colorTransform)
			{
				m_view.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, m_colorMulData, 1);
				m_view.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, m_colorAddData, 1);
			}
			
			m_view.context3D.setProgram(m_program);
		}
		
		public function sortByY():void 
		{
			if(children) children.sortOn("y", Array.NUMERIC);
		}
		
		public function dispose():void
		{
		}
	}
}