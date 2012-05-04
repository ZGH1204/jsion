package
{
	import flash.display.Sprite;
	
	import jsion.gpu2d.GPUView2D;
	
	[SWF(width="1250", height="650", frameRate="60")]
	public class Demo1 extends Sprite
	{
		private var m_view2d:GPUView2D;
		
		public function Demo1()
		{
			m_view2d = new GPUView2D(stage.stageWidth, stage.stageHeight);
			
			addChild(m_view2d);
		}
	}
}