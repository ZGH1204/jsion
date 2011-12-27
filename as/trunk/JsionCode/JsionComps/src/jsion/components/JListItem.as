package jsion.components
{
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	
	public class JListItem extends JToggleButton
	{
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		public static const LABEL_UP_FILTERS:String = CompGlobal.LABEL_UP_FILTERS;
		public static const LABEL_OVER_FILTERS:String = CompGlobal.LABEL_OVER_FILTERS;
		public static const LABEL_DOWN_FILTERS:String = CompGlobal.LABEL_DOWN_FILTERS;
		public static const LABEL_DISABLED_FILTERS:String = CompGlobal.LABEL_DISABLED_FILTERS;
		
		public static const HALIGN:String = CompGlobal.HALIGN;
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const VALIGN:String = CompGlobal.VALIGN;
		public static const VGAP:String = CompGlobal.VGAP;
		
		
		public function JListItem(label:String = "", selectedLabel:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(label, selectedLabel, container, xPos, yPos);
		}
		
		override public function draw():void
		{
			super.draw();
			
			m_width = originalWidth;
			m_height = originalHeight;
			dispatchEvent(new UIEvent(UIEvent.RESIZE));
		}
	}
}