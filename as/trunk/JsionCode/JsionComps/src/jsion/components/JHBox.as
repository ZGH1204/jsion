package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	[Event(name="resize", type="jsion.comps.events.UIEvent")]
	public class JHBox extends Component
	{
		public static const TOP:String = CompGlobal.TOP;
		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		private var m_spacing:Number;
		
		private var m_align:String;
		
		private var m_list:Array;
		
		public function JHBox(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_spacing = 0;
			m_align = TOP;
			m_list = [];
			super(container, xPos, yPos);
		}
		
		public function get spacing():Number
		{
			return m_spacing;
		}
		
		public function set spacing(value:Number):void
		{
			if(m_spacing != value)
			{
				m_spacing = value;
				
				invalidate();
			}
		}
		
		public function get align():String
		{
			return m_align;
		}
		
		public function set align(value:String):void
		{
			if(m_align != value)
			{
				m_align = value;
				
				invalidate();
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.addEventListener(UIEvent.RESIZE, __resizeHandler);
				
				if(m_list)
				{
					ArrayUtil.remove(m_list, child);
					ArrayUtil.push(m_list, child);
				}
			}
			
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.addEventListener(UIEvent.RESIZE, __resizeHandler);
				
				if(m_list) ArrayUtil.insert(m_list, child, index);
			}
			
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			invalidate();
			
			if(child)
			{
				child.removeEventListener(UIEvent.RESIZE, __resizeHandler);
				
				if(m_list) ArrayUtil.remove(m_list, child);
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
				
				if(m_list) ArrayUtil.remove(m_list, child);
			}
			
			return child;
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			if(child)
			{
				if(m_list) ArrayUtil.remove(m_list, child);
				
				if(m_list) ArrayUtil.insert(m_list, child, index);
			}
			
			super.setChildIndex(child, index);
		}
		
		private function __resizeHandler(e:UIEvent):void
		{
			invalidate();
		}
		
		override public function draw():void
		{
			var xPos:int = 0;
			
			var maxHeight:Number = 0;
			
			var child:DisplayObject;
			
			for(var i:int = 0; i < m_list.length; i++)
			{
				child = m_list[i];
				
				safeDrawAtOnceByDisplay(child);
				
				child.x = xPos + m_spacing * i;
				
				xPos += child.width;
				
				maxHeight = Math.max(child.height, maxHeight);
			}
			
			for(var j:int = 0; j < m_list.length; j++)
			{
				child = m_list[i];
				
				if(m_align == BOTTOM)
				{
					child.y = maxHeight - child.height;
				}
				else if(m_align == MIDDLE)
				{
					child.y = (maxHeight - child.height) / 2;
				}
				else
				{
					child.y = 0;
				}
			}
			
			m_width = originalWidth;
			m_height = maxHeight;
			dispatchEvent(new UIEvent(UIEvent.RESIZE));
			
			super.draw();
		}
		
		override public function dispose():void
		{
			DisposeUtil.freeChildren(this);

			m_list = null;
			
			super.dispose();
		}
	}
}