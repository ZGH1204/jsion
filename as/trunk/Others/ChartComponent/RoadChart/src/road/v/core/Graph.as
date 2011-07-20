package road.v.core
{
	import flash.events.Event;
	
	public class Graph extends DVBase
	{
		protected var _items:Array;
        protected var _itemStylesCache:Object;
        protected var _itemRenderer:Class;
        public static const INVALID_TYPE_ITEM_RENDERER:String = "itemRenderer";
        
		public function Graph()
		{
			_itemStylesCache = {};
		}
		
		override protected function validateAll(e:Event=null):void
		{
			super.validateAll(e);
			
			for each (var graphItem:GraphItem in _items)
            {
                
                graphItem.validateNow();
            }
		}
		
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}
		
		public function set itemRenderer(cls:Class) : void
        {
            if (cls == _itemRenderer)
            {
                return;
            }
            _itemRenderer = cls;
            invalidate(INVALID_TYPE_ITEM_RENDERER);
            return;
        }
        
        public function get numItems():uint
        {
        	validateAll();
            return _items ? _items.length : 0;
        }
		
		public function normalizeAllItems():void
		{
			validateAll();
            for each (var gi:GraphItem in _items)
            {
                gi.normalize();
            }
		}
		
		public function emphasizeAllItems():void
		{
			validateAll();
            for each (var gi:GraphItem in _items)
            {
                gi.emphasize();
            }
		}
		
		public function normalizeItem(index:uint):void
		{
			validateAll();
			
			if(_items)
			{
				var gi:GraphItem = _items[index] as GraphItem;
				if(gi)
					gi.normalize();
			}
		}
		
		public function emphasizeItem(index:uint):void
		{
			validateAll();
			
			if(_items)
			{
				var gi:GraphItem = _items[index]
				if(gi)
					gi.emphasize();
			}
		}
		
		public function hideAllItems():void
		{
			for each(var gi:GraphItem in _items)
			{
				gi.visible = false;
			}
		}
		
		public function showAllItems():void
		{
			for each(var gi:GraphItem in _items)
			{
				gi.visible = true;
			}
		}
		
		public function getItem(index:uint):GraphItem
		{
			validateAll();
			return _items[index];
		}
		
		public function hideItem(index:uint):void
		{
			validateAll();
			if (_items)
            {
                var gi:GraphItem = _items[index];
                if (gi)
                    gi.visible = false;
            }
		}
		
		public function showItem(index:uint):void
		{
			validateAll();
			if (_items)
            {
                var gi:GraphItem = _items[index];
                if (gi)
                    gi.visible = true;
            }
		}
		
		public function setItemStyles(styles:Object):void
		{
			if(styles == null)
			{
				_itemStylesCache = {};
			}
			else
			{
				for (var key:String in styles)
                {
                    
                    _itemStylesCache[key] = styles[key];
                }
			}
			
			for each(var gi:GraphItem in _items)
			{
				gi.setStyles(_itemStylesCache);
			}
		}
		
		
	}
}