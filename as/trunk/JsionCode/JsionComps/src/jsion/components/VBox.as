package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	
	[Event(name="change", type="jsion.comps.events.UIEvent")]
	public class VBox extends Component
	{
		private var m_spacing:int;
		
		public function VBox(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
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
			var yPos:int = 0;
			var maxWidth:Number;
			
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				child.y = yPos + m_spacing * i;
				
				yPos += child.height;
				
				maxWidth = Math.max(child.width, maxWidth);
			}
			
			m_width = maxWidth;
			m_height = originalHeight;
			dispatchEvent(new UIEvent(UIEvent.RESIZE));
			
			super.draw();
		}
	}
}