package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.coms.buttons.AbstractButton;
	
	import jutils.org.util.DisposeUtil;

	public class Window extends RootPanel
	{
		private var m_title:String;
		
		protected var m_titleBar:ITitleBar;
		
		protected var m_hTitleAlign:int;
		protected var m_vTitleAlign:int;
		protected var m_hTitleGap:int;
		protected var m_vTitleGap:int;
		
		protected var m_closeBtn:AbstractButton;
		
		protected var m_hCloseAlign:int;
		protected var m_vCloseAlign:int;
		protected var m_hCloseGap:int;
		protected var m_vCloseGap:int;
		
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
		
		public function invalidateCloseButton():void
		{
			if(m_readyToInvalidate)
			{
				if(m_closeBtn) m_closeBtn.invalidate();
			}
		}
		
		public function get title():String
		{
			return m_title;
		}
		
		public function set title(value:String):void
		{
			m_title = value;
		}

		public function get titleBar():ITitleBar
		{
			return m_titleBar;
		}

		public function set titleBar(value:ITitleBar):void
		{
			if(m_titleBar != value)
			{
				DisposeUtil.free(m_titleBar);
				
				m_titleBar = value;
				
				if(m_titleBar)
				{
					m_titleBar.setup(this);
					
					if(m_titleBar.getDisplay(this))
					{
						addChild(m_titleBar.getDisplay(this));
					}
				}
			}
		}

		public function get hTitleAlign():int
		{
			return m_hTitleAlign;
		}

		public function set hTitleAlign(value:int):void
		{
			if(m_hTitleAlign != value)
			{
				m_hTitleAlign = value;
				
				invalidate();
			}
		}

		public function get vTitleAlign():int
		{
			return m_vTitleAlign;
		}

		public function set vTitleAlign(value:int):void
		{
			if(m_vTitleAlign != value)
			{
				m_vTitleAlign = value;
				
				invalidate();
			}
		}

		public function get closeBtn():AbstractButton
		{
			return m_closeBtn;
		}

		public function set closeBtn(value:AbstractButton):void
		{
			if(m_closeBtn != value)
			{
				DisposeUtil.free(m_closeBtn);
				
				m_closeBtn = value;
				
				invalidate();
			}
		}

		public function get hCloseAlign():int
		{
			return m_hCloseAlign;
		}

		public function set hCloseAlign(value:int):void
		{
			if(m_hCloseAlign != value)
			{
				m_hCloseAlign = value;
				
				invalidate();
			}
		}

		public function get vCloseAlign():int
		{
			return m_vCloseAlign;
		}

		public function set vCloseAlign(value:int):void
		{
			if(m_vCloseAlign != value)
			{
				m_vCloseAlign = value;
				
				invalidate();
			}
		}

		public function get hTitleGap():int
		{
			return m_hTitleGap;
		}

		public function set hTitleGap(value:int):void
		{
			if(m_hTitleGap != value)
			{
				m_hTitleGap = value;
				
				invalidate();
			}
		}

		public function get vTitleGap():int
		{
			return m_vTitleGap;
		}

		public function set vTitleGap(value:int):void
		{
			if(m_vTitleGap != value)
			{
				m_vTitleGap = value;
				
				invalidate();
			}
		}

		public function get hCloseGap():int
		{
			return m_hCloseGap;
		}

		public function set hCloseGap(value:int):void
		{
			if(m_hCloseGap != value)
			{
				m_hCloseGap = value;
				
				invalidate();
			}
		}

		public function get vCloseGap():int
		{
			return m_vCloseGap;
		}

		public function set vCloseGap(value:int):void
		{
			if(m_vCloseGap != value)
			{
				m_vCloseGap = value;
				
				invalidate();
			}
		}

		override public function dispose():void
		{
			DisposeUtil.free(m_closeBtn);
			m_closeBtn = null;
			
			DisposeUtil.free(m_titleBar);
			m_titleBar = null;
			
			super.dispose();
		}
	}
}