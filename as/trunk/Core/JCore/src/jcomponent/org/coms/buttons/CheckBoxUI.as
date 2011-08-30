package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IGroundDecorator;

	public class CheckBoxUI extends ImageButtonUI
	{
		private var boxRect:IntRectangle = new IntRectangle();
		
		public function CheckBoxUI()
		{
			super();
		}
		
		override protected function paintText(component:Component, bounds:IntRectangle):void
		{
			var btn:CheckBox = CheckBox(component);
			
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			viewRect.setRect(bounds);
			
			boxRect.setRectXYWH(0,0,0,0);
			textRect.setRectXYWH(0,0,0,0);
			
			var s:IntDimension;
			
			if(backgroundDecorator) s = backgroundDecorator.getSize();
			else s = new IntDimension();
			
			var text:String = JUtil.layoutTextAndBox(btn.text, btn.font, 
													btn.horizontalTextAlginment, 
													btn.verticalTextAlginment, 
													textRect, s.width, s.height, 
													btn.textHGap, btn.textVGap, btn.boxHGap, 
													btn.boxVGap, btn.boxDir, boxRect, viewRect);
			
			
			if(backgroundDecorator) backgroundDecorator.setLocation(boxRect.x, boxRect.y);
			
			textField.x = textRect.x;
			textField.y = textRect.y;
			textField.text = text;
			btn.font.apply(textField);
			textField.textColor = btn.forecolor.getRGB();
			
			textField.filters = btn.textFilters;
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.CHECK_BOX_PRE;
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var cb:CheckBox = CheckBox(component);
			
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension;
			
			if(backgroundDecorator) backSize = backgroundDecorator.getPreferredSize(component);
			else backSize = new IntDimension();
			
			return calcSize(cb, textSize, backSize);
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var cb:CheckBox = CheckBox(component);
			
			var backgroundDecorator:IGroundDecorator = component.backgroundDecorator;
			
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension;
			
			if(backgroundDecorator) backSize = backgroundDecorator.getMinimumSize(component);
			else backSize = new IntDimension();
			
			return calcSize(cb, textSize, backSize);
		}
		
		override public function getMaximumSize(component:Component):IntDimension
		{
			return IntDimension.createBigDimension();
		}
		
		private function calcSize(cb:CheckBox, textSize:IntDimension, backSize:IntDimension):IntDimension
		{
			var w:int;
			var h:int;
			
			if(cb.boxDir == CheckBox.CENTER || cb.boxDir == CheckBox.MIDDLE)
			{
				w = Math.max(textSize.width, backSize.width);
				h = Math.max(textSize.height, backSize.height);
			}
			else if(cb.boxDir == CheckBox.TOP || cb.boxDir == CheckBox.BOTTOM)
			{
				w = Math.max(textSize.width, backSize.width);
				
				h = textSize.height + backSize.height;
				h += cb.textVGap;
				h += cb.boxVGap;
			}
			else
			{
				w = textSize.width + backSize.width;
				w += cb.textHGap;
				w += cb.boxHGap;
				
				h = Math.max(textSize.height, backSize.height);
			}
			
			
			return new IntDimension(w, h);
		}
	}
}