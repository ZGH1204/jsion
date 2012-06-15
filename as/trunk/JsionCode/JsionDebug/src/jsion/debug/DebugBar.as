package jsion.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * @private
	 * @author Jsion
	 * 
	 */	
	internal class DebugBar extends Sprite
	{
		private var m_width:int;
		
		private var m_height:int;
		
		private var m_background:Bitmap;
		
		private var m_children:Array;
		
		private var m_container:Stage;
		
		public function DebugBar(w:int, h:int, stage:Stage)
		{
			super();
			
			m_container = stage;
			
			m_background = new Bitmap(new BitmapData(1, 1, true, 0xFF000000));
			addChild(m_background);
			
			width = w;
			height = h;
			
			m_children = [];
		}
		
		public function add(view:DebugView):DebugView
		{
			if(view != null && m_children.indexOf(view) == -1)
			{
				view.addTo(m_container);
				m_children.push(view);
			}
			
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			return view;
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler)
			
			var spacing:int = 10;
			var pos:int = 20;
			var j:int = 0
			
			for(var i:int; i < m_children.length; i++)
			{
				var view:DebugView = m_children[i];
				var list:Array = view.btnList;
				
				for each(var child:DisplayObject in list)
				{
					child.x = pos + j * spacing;
					
					pos += child.width;
					
					child.y = (height - child.height) / 2;
					
					j++;
					
					addChild(child);
				}
			}
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set width(value:Number):void
		{
			m_width = value;
			m_background.width = m_width;
		}
		
		override public function get height():Number
		{
			return m_height
		}
		
		override public function set height(value:Number):void
		{
			m_height = value;
			m_background.height = m_height;
		}
	}
}