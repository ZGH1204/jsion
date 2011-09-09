package jcomponent.org.basic.layouts
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.IGroundDecorator;
	import jcomponent.org.coms.containers.AbstractBox;

	public class HBoxLayout extends EmptyLayout
	{
		public function HBoxLayout()
		{
			super();
		}
		
		override public function layoutContainer(target:Container):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(target.getSize());
			
			var box:AbstractBox = AbstractBox(target);
			
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
			
			var tmpRect:IntRectangle = new IntRectangle();
			
			for(; i < count; i++)
			{
				var dis:DisplayObject = target.getChildAt(i);
				
				if(dis == target.mask) continue;
				
				if(preDis)
				{
					dis.x = preDis.x + preDis.width;
					dis.x += box.gap;
				}
				else
				{
					dis.x = 0;
				}
				
				tmpRect.setRectXYWH(0, 0, dis.width, dis.height);
				
				JUtil.layoutPosition(viewRect, box.hAlign, box.vAlign, 0, 0, tmpRect);
				
				dis.y = tmpRect.y;
				
				maxH = Math.max(dis.height, maxH);
				
				preDis = dis;
			}
		}
	}
}