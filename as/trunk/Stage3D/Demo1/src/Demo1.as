package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.gpu2d.GPUObj2D;
	import jsion.gpu2d.GPUView2D;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class Demo1 extends Sprite
	{
		private var m_view2d:GPUView2D;
		
		[Embed(source = "g_lea2.png")]
		private var c:Class;
		
		public function Demo1()
		{
			//stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			m_view2d = new GPUView2D(stage.stageWidth, stage.stageHeight);
			
			m_view2d.addEventListener(Event.CONTEXT3D_CREATE, __contextCreateHandler);
			
			addChild(m_view2d);
			
			stage.addEventListener(MouseEvent.CLICK, __clickHandler);
		}
		
		protected function __clickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			//m_view2d.setCameraWH(stage.stageWidth, stage.stageHeight);
			
			if(hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			else
			{
				addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		protected function __enterFrameHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			
			var count:int = 5;
			
			while(count-- >= 0)
			{
				var index:int = m_view2d.obj2ds.length * Math.random();
				
				m_view2d.obj2ds[index].rotation += 30 * Math.random();
			}
			
//			for each(var obj2d:GPUObj2D in m_view2d.obj2ds)
//			{
//				obj2d.rotation++;
//			}
			
			//m_view2d.setCameraXY(m_view2d.cameraX + 1, m_view2d.cameraY);
		}
		
		private function __contextCreateHandler(e:Event):void
		{
			var bmd:BitmapData = (new c as Bitmap).bitmapData;
			
			var objWidth:int = 100;
			var objHeight:int = 100;
			
			var xCount:int = Math.ceil(stage.stageWidth / objWidth);
			var yCount:int = Math.ceil(stage.stageHeight / objHeight);
			
			for(var j:int = 0; j < yCount; j++)
			{
				for(var i:int = 0; i < xCount; i++)
				{
					var obj2d:GPUObj2D = new GPUObj2D(objWidth, objHeight, bmd, m_view2d);
					
					obj2d.x = i * obj2d.width;
					obj2d.y = j * obj2d.height;
					
					obj2d.offsetX = objWidth / 2;
					obj2d.offsetY = objHeight / 2;
					
					m_view2d.add(obj2d);
				}
			}
			
			m_view2d.sortByY();
		}
	}
}