package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import jsion.comps.Component;
	
	public class JFocusRoot extends Component
	{
		public function JFocusRoot(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(container, xPos, yPos);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			setFocusIn();
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, __clickHandler);
			addEventListener(FocusEvent.FOCUS_IN, __focusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT, __focusOutHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			setFocusIn();
		}
		
		private function __focusInHandler(e:FocusEvent):void
		{
			bring2Top();
			onFocusIn();
		}
		
		private function __focusOutHandler(e:FocusEvent):void
		{
			onFocusOut();
		}
		
		protected function onFocusIn():void
		{
		}
		
		protected function onFocusOut():void
		{
		}
		
		public function setFocusIn():void
		{
			JFocusMgr.Instance.setFocusIn(this);
		}
		
		public function setFocusOut():void
		{
			JFocusMgr.Instance.setFocusOut(this);
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(FocusEvent.FOCUS_IN, __focusInHandler);
			removeEventListener(FocusEvent.FOCUS_OUT, __focusOutHandler);
			
			setFocusOut();
			
			super.dispose();
		}
	}
}