package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jcomponent.org.basic.DefaultConfigKeys;
	
	import jutils.org.util.DisposeUtil;

	public class Frame extends Window
	{
		protected var m_container:Sprite;
		
		private var m_contentX:int;
		
		private var m_contentY:int;
		
		public function Frame(title:String=null, prefix:String=null, id:String=null)
		{
			m_container = new Sprite();
			
			super(title, prefix, id);
			
			addChild(m_container);
		}

		public function get contentX():int
		{
			return m_contentX;
		}

		public function set contentX(value:int):void
		{
			if(m_contentX != value)
			{
				m_contentX = value;
				
				m_container.x = m_contentX;
			}
		}
		
		public function get content():Sprite
		{
			return m_container;
		}

		public function get contentY():int
		{
			return m_contentY;
		}

		public function set contentY(value:int):void
		{
			if(m_contentY != value)
			{
				m_contentY = value;
				
				m_container.y = m_contentY;
			}
		}
		
		public function addToContent(display:DisplayObject):void
		{
			m_container.addChild(display);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicFrameUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.FRAME_UI;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_container);
			m_container = null;
			
			super.dispose();
		}
	}
}