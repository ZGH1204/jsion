package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	
	[Event(name="resize", type="jsion.comps.events.UIEvent")]
	public class HBox extends Component
	{
		private var m_spacing:int;
		
		public function HBox(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_spacing = 5;
			super(container, xPos, yPos);
		}
		
		public function get spacing():int
		{
			return m_spacing;
		}
		
		public function set spacing(value:int):void
		{
			if(m_spacing != value)
			{
				m_spacing = value;
				
				invalidate();
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.addEventListener(UIEvent.RESIZE, __resizeHandler);
			}
			
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.addEventListener(UIEvent.RESIZE, __resizeHandler);
			}
			
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.removeEventListener(UIEvent.RESIZE, __resizeHandler);
			}
			
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			invalidate();
			
			var child:DisplayObject = super.removeChildAt(index);
			
			if(child)
			{
				child.removeEventListener(UIEvent.RESIZE, __resizeHandler);
			}
			
			return child;
		}
		
		private function __resizeHandler(e:UIEvent):void
		{
			invalidate();
		}
		
		override public function draw():void
		{
			var xPos:int = 0;
			
			var maxHeight:Number = 0;
			
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				child.x = xPos + m_spacing * i;
				
				xPos += child.width;
				
				maxHeight = Math.max(child.height, maxHeight);
			}
			
			m_width = originalWidth;
			m_height = maxHeight;
			dispatchEvent(new UIEvent(UIEvent.RESIZE));
			
			super.draw();
		}
	}
}