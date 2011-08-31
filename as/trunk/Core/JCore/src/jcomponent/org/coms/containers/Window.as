package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.DefaultConfigKeys;
	
	import jutils.org.util.DisposeUtil;

	public class Window extends RootPanel
	{
		protected var m_title:ITitleBar;
		
		public function Window(id:String=null)
		{
			super(id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicWindowUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.WINDOW_UI;
		}

		public function get title():ITitleBar
		{
			return m_title;
		}

		public function set title(value:ITitleBar):void
		{
			if(m_title != value)
			{
				DisposeUtil.free(m_title);
				
				m_title = value;
				
				if(m_title)
				{
					m_title.setup(this, UI);
					
					if(m_title.getDisplay(this))
					{
						addChild(m_title.getDisplay(this));
					}
				}
			}
		}

	}
}