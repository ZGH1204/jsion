package road.index
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class CursorManager
	{
        private var container:DisplayObjectContainer = null;
        private var tigger2Cursor:Dictionary;
        private var _root:DisplayObjectContainer = null;
        private var currentCursor:DisplayObject = null;
        
		public function CursorManager()
		{
            tigger2Cursor = new Dictionary(true);
            container = new Sprite();
            container.mouseEnabled = false;
            container.tabEnabled = false;
            container.mouseChildren = false;
		}
		
		public function get root():DisplayObjectContainer
		{
			return _root;
		}
		public function set root($root:DisplayObjectContainer) : void
        {
            if (_root == null)
            {
                _root = $root;
                _root.addChild(container);
            }
            else
            {
                trace("Error:root given not valid");
            }
        }
        
        public function hideCursor(param1:*) : void
        {
            param1 = InstanceManager.createSingletonInstance(param1);
            if (param1 != currentCursor)
            {
                return;
            }
            hideCurrentCursor();
            return;
        }
        
        public function hideCurrentCursor() : void
        {
            if (container != null)
            {
                if (currentCursor != null)
                {
                    container.removeChild(currentCursor);
                }
            }
            currentCursor = null;
            Mouse.show();
            if (root != null)
            {
                root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
            }
            return;
        }
        
        private function handleMove(param1:MouseEvent) : void
        {
            container.x = container.parent.mouseX;
            container.y = container.parent.mouseY;
            DepthManager.bringToTop(container);
            if (param1 != null)
            {
                param1.updateAfterEvent();
            }
            return;
        }
        
        public function showCursor(param1:*, param2:Boolean = true) : void
        {
            param1 = InstanceManager.createSingletonInstance(param1);
            if (param2)
            {
                Mouse.hide();
            }
            else
            {
                Mouse.show();
            }
            if (param1 == currentCursor)
            {
                return;
            }
            if (container != null)
            {
                if (currentCursor != param1)
                {
                    if (currentCursor != null)
                    {
                        container.removeChild(currentCursor);
                    }
                    currentCursor = param1;
                    container.addChild(currentCursor);
                }
                DepthManager.bringToTop(container);
                root.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMove, false);
                handleMove(null);
            }
            return;
        }
		
		public static function getInstance() : CursorManager
		{
			return InstanceManager.createSingletonInstance(CursorManager) as CursorManager;
		}
	}
}