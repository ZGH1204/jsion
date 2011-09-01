package jcomponent.org.basic.layouts
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.IGroundDecorator;

	public class HBoxLayout extends EmptyLayout
	{
		private var m_gap:int;
		
		public function HBoxLayout(gap:int = 0)
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
			var maxH:int;
			
			for(; i < count; i++)
			{
				var dis:DisplayObject = target.getChildAt(i);
				
				if(preDis)
				{
					dis.x = preDis.x + preDis.width;
					dis.x += m_gap;
				}
				else
				{
					dis.x = 0;
				}
				
				maxH = Math.max(dis.height, maxH);
				
				preDis = dis;
			}
		}
	}
}