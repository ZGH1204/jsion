package jsion.gpu2d
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	
	import jsion.IDispose;
	
	public class GPUView2D extends Sprite implements IDispose
	{
		protected var m_viewWidth:Number;
		protected var m_viewHeight:Number;
		
		protected var m_stage3d:Stage3D;
		protected var m_context3d:Context3D;
		protected var m_cameraMatrix:Matrix3D;
		
		protected var m_vertexData:Vector.<Number>;
		protected var m_indexData:Vector.<uint>;
		
		protected var m_vertexBuffer:VertexBuffer3D;
		protected var m_indexBuffer:IndexBuffer3D;
		
		protected var m_vertexCode:String;
		protected var m_vertexAGAL:AGALMiniAssembler;
		
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
			
			m_cameraMatrix = new Matrix3D;
			m_cameraMatrix.appendScale(2 / m_viewWidth, 2 / m_viewHeight, 1);
			m_cameraMatrix.appendTranslation( -1, 1, 0);
			
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
			
			
			m_stage3d = stage.stage3Ds[0];
			m_stage3d.addEventListener(Event.CONTEXT3D_CREATE, __context3DCreateHandler);
			m_stage3d.requestContext3D();
		}
		
		private function __context3DCreateHandler(e:Event):void
		{
			m_stage3d.x = x;
			m_stage3d.y = y;
			
			m_context3d = m_stage3d.context3D;
			m_context3d.configureBackBuffer(m_viewWidth, m_viewHeight, 0, false);
			m_context3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA);
			
			m_vertexBuffer = m_context3d.createVertexBuffer(m_vertexData.length / 3, 3);
			m_vertexBuffer.uploadFromVector(m_vertexData, 0, m_vertexData.length / 3);
			
			m_indexBuffer = m_context3d.createIndexBuffer(m_indexData.length);
			m_indexBuffer.uploadFromVector(m_indexData, 0, m_indexData.length);
			
			
			//将顶点定义放在va0
			m_context3d.setVertexBufferAt(0, m_vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			//将摄像机矩阵放在vc8
			m_context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, m_cameraMatrix, true);
			
			trace("当前渲染模式:", m_context3d.driverInfo);
			
			start();
			
			dispatchEvent(e.clone());
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
				
				program = m_context3d.createProgram();
				program.upload(m_vertexAGAL.agalcode, fsa.agalcode);
				m_programList[id] = program;
			}
			
			return program;
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
			m_context3d.clear(1, 1, 1, 0);
			
			m_context3d.present();
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			
			if(m_stage3d) m_stage3d.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			
			if(m_stage3d) m_stage3d.y = value;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			removeEventListener(Event.ENTER_FRAME, __enterFrameRenderHandler);
			
			if(m_stage3d) m_stage3d.removeEventListener(Event.CONTEXT3D_CREATE, __context3DCreateHandler);
			
			if(m_context3d) m_context3d.dispose();
			
			
			m_context3d = null;
			m_stage3d = null;
		}
	}
}