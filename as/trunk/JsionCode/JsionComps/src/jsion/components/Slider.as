package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	
	public class Slider extends Component
	{
		public static const HORIZONTAL:String = CompGlobal.HORIZONTAL;
		public static const VERTICAL:String = CompGlobal.VERTICAL;
		
		private var m_orientation:String;
		
		private var m_background:DisplayObject;
		
		public function Slider(orientation:String = HORIZONTAL,container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_orientation = orientation;
			
			super(container, xPos, yPos);
		}
	}
}