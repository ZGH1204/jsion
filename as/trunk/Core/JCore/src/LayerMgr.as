package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DepthUtil;

	public class LayerMgr
	{
		public static var backgroundLayer:Sprite;
		
		public static var gameviewLayer:Sprite;
		
		public static var uiviewLayer:Sprite;
		
		public static var foregroundLayer:Sprite;
		
		public static var viewStack:Array;
		
		public static function setup():void
		{
			if(backgroundLayer) return;
			
			backgroundLayer = new Sprite();
			gameviewLayer = new Sprite();
			uiviewLayer = new Sprite();
			foregroundLayer = new Sprite();
			
			StageRef.addChild(backgroundLayer);
			StageRef.addChild(gameviewLayer);
			StageRef.addChild(uiviewLayer);
			StageRef.addChild(foregroundLayer);
			
			viewStack = [];
		}
		
		public static function addView(display:DisplayObject):void
		{
			if(ArrayUtil.containsValue(viewStack, display))
			{
				ArrayUtil.remove(viewStack, display);
				viewStack.push(display);
				DepthUtil.bringToTop(display);
			}
			else
			{
				viewStack.push(display);
				gameviewLayer.addChild(display);
				display.addEventListener(Event.REMOVED_FROM_STAGE, __removeStageHandler);
			}
		}
		
		private static function __removeStageHandler(e:Event):void
		{
			var display:DisplayObject = e.currentTarget as DisplayObject;
			
			display.removeEventListener(Event.REMOVED_FROM_STAGE, __removeStageHandler);
			
			ArrayUtil.remove(viewStack, display);
		}
		
		public static function removeView(display:DisplayObject):void
		{
			if(display && gameviewLayer.contains(display))
			{
				ArrayUtil.remove(viewStack, display);
				
				gameviewLayer.removeChild(display);
				
				display.removeEventListener(Event.REMOVED_FROM_STAGE, __removeStageHandler);
			}
		}
		
		
		
		
		
		
		public static function addUI(display:DisplayObject):void
		{
			uiviewLayer.addChild(display);
		}
		
		public static function removeUI(display:DisplayObject):void
		{
			if(uiviewLayer.contains(display))
			{
				uiviewLayer.removeChild(display);
			}
		}
		
		
		
		
		public static function addBackground(display:DisplayObject):void
		{
			backgroundLayer.addChild(display);
		}
		
		public static function removeBackground(display:DisplayObject):void
		{
			if(backgroundLayer.contains(display))
			{
				backgroundLayer.removeChild(display);
			}
		}
		
		
		
		
		
		public static function addForeground(display:DisplayObject):void
		{
			foregroundLayer.addChild(display);
		}
		
		public static function removeForeground(display:DisplayObject):void
		{
			if(foregroundLayer.contains(display))
			{
				foregroundLayer.removeChild(display);
			}
		}
	}
}