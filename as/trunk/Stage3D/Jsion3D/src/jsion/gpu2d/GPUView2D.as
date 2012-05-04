package jsion.gpu2d
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	
	import jsion.IDispose;
	
	public class GPUView2D extends Sprite implements IDispose
	{
		public var textures:Array = [];
		public var obj2ds:Array = [];
		
		protected var m_nowTextureId:int = 0;
		
		protected var m_cameraX:Number = 0;
		protected var m_cameraY:Number = 0;
		protected var m_viewWidth:Number;
		protected var m_viewHeight:Number;
		
		protected var m_stage3D:Stage3D;
		protected var m_context3D:Context3D;
		protected var m_cameraMatrix:Matrix3D;
		
		protected var m_vertexData:Vector.<Number>;
		protected var m_indexData:Vector.<uint>;
		
		protected var m_vertexBuffer:VertexBuffer3D;
		protected var m_indexBuffer:IndexBuffer3D;
		
		protected var m_vertexCode:String;
		protected var m_vertexAGAL:AGALMiniAssembler;
		
		protected var m_textureList:Dictionary;
		protected var m_programList:Array;
		
		public function GPUView2D(vwidth:Number, vheight:Number)
		{
			super();
			
			m_viewWidth = vwidth;
			m_viewHeight = vheight;
			
			if(stage)
			{
				initialize();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			}
		}
		
		private function __addToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			initialize();
		}
		
		protected function initialize():void
		{
			m_programList = [];
			m_textureList = new Dictionary();
			
			m_cameraMatrix = new Matrix3D;
			
			m_vertexData = Vector.<Number>([
				0, 0,  0,
				1, 0,  0,
				0, -1, 0,
				1, -1, 0
			]);
			
			m_indexData = Vector.<uint>([
				0, 1, 3,
				3, 2, 0
			]);
			
			//顶点矩阵转换
			m_vertexCode = "";
			m_vertexCode += "m44 vt0,va0,vc0\n";
			m_vertexCode += "m44 vt0,vt0,vc4\n";
			m_vertexCode += "m44 op,vt0,vc8\n";
			m_vertexCode += "mov v0,va1";
			m_vertexAGAL = new AGALMiniAssembler(false);
			m_vertexAGAL.assemble(Context3DProgramType.VERTEX, m_vertexCode);
			
			
			m_stage3D = stage.stage3Ds[0];
			m_stage3D.addEventListener(Event.CONTEXT3D_CREATE, __context3DCreateHandler);
			m_stage3D.requestContext3D();
		}
		
		private function __context3DCreateHandler(e:Event):void
		{
			m_stage3D.x = x;
			m_stage3D.y = y;
			
			m_context3D = m_stage3D.context3D;
			m_context3D.enableErrorChecking = true;
			m_context3D.configureBackBuffer(m_viewWidth, m_viewHeight, 0, false);
			m_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			m_vertexBuffer = m_context3D.createVertexBuffer(m_vertexData.length / 3, 3);
			m_vertexBuffer.uploadFromVector(m_vertexData, 0, m_vertexData.length / 3);
			
			m_indexBuffer = m_context3D.createIndexBuffer(m_indexData.length);
			m_indexBuffer.uploadFromVector(m_indexData, 0, m_indexData.length);
			
			
			//将顶点定义放在va0
			m_context3D.setVertexBufferAt(0, m_vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			updateCameraMatrix();
			
			//将摄像机矩阵放在vc8
			//m_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, m_cameraMatrix, true);
			
			trace("当前渲染模式:", m_context3D.driverInfo);
			
			start();
			
			dispatchEvent(e.clone());
		}
		
		public function add(obj:GPUObj2D):void
		{
			obj2ds.push(obj);
		}
		
		public function getOrCreateProgram(colorTransform:ColorTransform):Program3D
		{
			var id:int = 0;
			var isColorMul:Boolean = false;
			var isColorAdd:Boolean = false;
			
			if(colorTransform)
			{
				isColorMul = colorTransform.alphaMultiplier != 1 || colorTransform.redMultiplier != 1 || colorTransform.greenMultiplier != 1 || colorTransform.blueMultiplier != 1;
				isColorAdd = colorTransform.alphaOffset != 0 || colorTransform.redOffset != 0 || colorTransform.greenOffset != 0 || colorTransform.blueOffset != 0;
				
				if (isColorMul) id |= 1;
				
				if (isColorAdd) id |= 2;
			}
			
			var program:Program3D = m_programList[id];
			
			if(program == null)
			{
				var code:String = "";
				
				code += "tex ft0, v0, fs0 <2d,linear,nomip>\n";
				if(isColorMul) code += "mul ft0,ft0,fc0\n";
				if(isColorAdd) code += "add ft0,ft0,fc1\n";
				code += "mov oc,ft0";
				
				var fsa:AGALMiniAssembler = new AGALMiniAssembler(false);
				fsa.assemble(Context3DProgramType.FRAGMENT, code);
				
				program = m_context3D.createProgram();
				program.upload(m_vertexAGAL.agalcode, fsa.agalcode);
				m_programList[id] = program;
			}
			
			return program;
		}
		
		public function getTexture(bmd:BitmapData):UVTexture
		{
			if(m_textureList[bmd] == null)
			{
				var i:int = 0;
				var w:int = 2048;
				var h:int = 2048;
				
				for (i = 0; i < 12; i++ )
				{
					var pow:int = Math.pow(2, i);
					
					if (pow >= bmd.width)
					{
						w = pow;
						break;
					}
				}
				
				for (i = 0; i < 12; i++ )
				{
					pow = Math.pow(2, i);
					
					if (pow >= bmd.height)
					{
						h = pow;
						break;
					}
				}
				
				var temp:BitmapData = new BitmapData(w, h, true, 0);
				temp.draw(bmd, new Matrix(w / bmd.width, 0, 0, h / bmd.height), null, null, null, true);
				
				var texture:Texture = m_context3D.createTexture(w, h, Context3DTextureFormat.BGRA, false);
				texture.uploadFromBitmapData(temp);
				textures[m_nowTextureId] = texture;
				temp.dispose();
				
				var uvtexture:UVTexture = new UVTexture;
				uvtexture.textureIndex = m_nowTextureId;
				uvtexture.uvBuffer = m_context3D.createVertexBuffer(4, 2);
				uvtexture.uvBuffer.uploadFromVector(Vector.<Number>([0, 0,  1, 0,  0, 1,  1,1]), 0, 4);
				m_nowTextureId++;
				
				m_textureList[bmd] = uvtexture;
			}
			
			return m_textureList[bmd];
		}
		
		public function setCameraXY(cX:Number, cY:Number):void
		{
			m_cameraX = cX;
			m_cameraY = cY;
			
			updateCameraMatrix();
		}
		
		public function setCameraWH(w:Number, h:Number):void
		{
			m_viewWidth = w;
			m_viewHeight = h;
			
			m_context3D.configureBackBuffer(m_viewWidth, m_viewHeight, 0, false);
			
			updateCameraMatrix();
		}
		
		private function updateCameraMatrix():void
		{
			var tmpX:Number, tmpY:Number;
			tmpX = -1 - 2 / m_viewWidth * m_cameraX;
			tmpY = 1 + 2 / m_viewHeight * m_cameraY;
			
			m_cameraMatrix.identity();
			m_cameraMatrix.appendScale(2 / m_viewWidth, 2 / m_viewHeight, 1);
			m_cameraMatrix.appendTranslation(tmpX, tmpY, 0);
			
			//将摄像机矩阵放在vc8
			m_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, m_cameraMatrix, true);
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, __enterFrameRenderHandler);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameRenderHandler);
		}
		
		private function __enterFrameRenderHandler(e:Event):void
		{
			render();
		}
		
		public function render():void
		{
			m_context3D.clear(1, 1, 1, 0);
			
			for each(var obj2d:GPUObj2D in obj2ds)
			{
				renderObj2D(obj2d);
			}
			
			m_context3D.present();
		}
		
		protected function renderObj2D(obj2d:GPUObj2D):void
		{
			if(obj2d.change) obj2d.recompose();
			
			obj2d.wMatrix.rawData = obj2d.vMatrix.rawData;
			
			if(obj2d.parent) obj2d.wMatrix.append(obj2d.parent.wMatrix);
			
			obj2d.update();
			
			if(obj2d.texture)
			{
				m_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, obj2d.selfMatrix, true);
				m_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, obj2d.wMatrix, true);
				
				m_context3D.setTextureAt(0, textures[obj2d.texture.textureIndex]);
				m_context3D.setVertexBufferAt(1, obj2d.texture.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				m_context3D.drawTriangles(m_indexBuffer);
			}
			
			for each(var ob:GPUObj2D in obj2d.children)
			{
				renderObj2D(ob);
			}
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			
			if(m_stage3D) m_stage3D.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			
			if(m_stage3D) m_stage3D.y = value;
		}
		
		public function get cameraX():Number
		{
			return m_cameraX;
		}
		
		public function get cameraY():Number
		{
			return m_cameraY;
		}
		
		public function get context3D():Context3D
		{
			return m_context3D;
		}
		
		public function set context3D(value:Context3D):void
		{
			m_context3D = value;
		}
		
		public function sortByY():void 
		{
			if(obj2ds) obj2ds.sortOn("y", Array.NUMERIC);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			removeEventListener(Event.ENTER_FRAME, __enterFrameRenderHandler);
			
			if(m_stage3D) m_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, __context3DCreateHandler);
			
			if(m_context3D) m_context3D.dispose();
			
			
			m_context3D = null;
			m_stage3D = null;
		}
	}
}