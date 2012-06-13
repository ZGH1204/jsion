package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	public class JPanel extends Component
	{
		private var m_mask:Sprite;
		
		public function JPanel(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(container, xPos, yPos);
		}
		
		override protected function addChildren():void
		{
			m_mask = new Sprite();
			m_mask.mouseEnabled = false;
			m_mask.mouseChildren = false;
			mask = m_mask;
			addChild(m_mask);
		}
		
		override public function draw():void
		{
			graphics.clear();
			graphics.beginFill(0x0, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			m_mask.graphics.clear();
			m_mask.graphics.beginFill(0x0, 0);
			m_mask.graphics.drawRect(0, 0, width, height);
			m_mask.graphics.endFill();
			
			super.draw();
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_mask);
			m_mask = null;
			
			super.dispose();
		}
	}
}