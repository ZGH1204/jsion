package jcomponent.org.basic.layouts
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.IGroundDecorator;

	public class VBoxLayout extends EmptyLayout
	{
		private var m_gap:int;
		
		public function VBoxLayout(gap:int = 0)
		{
			super();
			
			m_gap = gap;
		}
		
		public function get gap():int
		{
			return m_gap;
		}
		
		override public function layoutContainer(target:Container):void
		{
			var count:int = target.numChildren;
			
			if(count <= 0) return;
			
			var fore:Boolean, back:Boolean;
			var ground:IGroundDecorator = target.backgroundDecorator;
			if(ground && ground.getDisplay(target)) back = true;
			ground = target.foregroundDecorator;
			if(ground && ground.getDisplay(target)) fore = true;
			
			var i:int = 0;
			if(back) i = 1;
			if(fore) count -= 1;
			
			var preDis:DisplayObject;
			var maxW:int;
			
			for(; i < count; i++)
			{
				var dis:DisplayObject = target.getChildAt(i);
				
				if(dis == target.mask) continue;
				
				if(preDis)
				{
					dis.y = preDis.y + preDis.height;
					dis.y += m_gap;
				}
				else
				{
					dis.y = 0;
				}
				
				maxW = Math.max(dis.width, maxW);
				
				preDis = dis;
			}
		}
	}
}