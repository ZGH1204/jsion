package jsion.ui.components.containers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.*;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.UIConstants;
	import jsion.ui.components.buttons.AbstractButton;
	
	import jsion.utils.DisposeUtil;

	public class Window extends RootPanel
	{
		private var m_title:String;
		
		private var m_titleWidth:int;
		private var m_titleHeight:int;
		
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
		
		public function Window(title:String = null, prefix:String = null, id:String=null)
		{
			m_title = title;
			
			if(m_title == null) m_title = "";
			
			m_hTitleAlign = UIConstants.CENTER;
			m_vTitleAlign = UIConstants.TOP;
			
			m_hCloseAlign = UIConstants.RIGHT;
			m_vCloseAlign = UIConstants.TOP;
			
			super(prefix, id);
			
			DisposeUtil.free(mask);
			mask = null;
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
			if(m_title != value)
			{
				m_title = value;
				
				invalidate();
			}
		}
		
		public function get titleWidth():int
		{
			return m_titleWidth;
		}
		
		public function set titleWidth(value:int):void
		{
			if(m_titleWidth != value)
			{
				m_titleWidth = value;
				
				invalidate();
			}
		}
		
		public function get titleHeight():int
		{
			return m_titleHeight;
		}
		
		public function set titleHeight(value:int):void
		{
			if(m_titleHeight != value)
			{
				m_titleHeight = value;
				
				invalidate();
			}
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
				if(value != UIConstants.LEFT && 
					value != UIConstants.CENTER && 
					value != UIConstants.RIGHT) return;
				
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
				if(value != UIConstants.TOP && 
					value != UIConstants.MIDDLE && 
					value != UIConstants.BOTTOM) return;
				
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
				if(m_closeBtn) m_closeBtn.removeEventListener(MouseEvent.CLICK, __closeHandler);
				
				DisposeUtil.free(m_closeBtn);
				
				m_closeBtn = value;
				
				if(m_closeBtn)
				{
					addChild(m_closeBtn);
					m_closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
				}
				
				invalidate();
			}
		}
		
		
		private function __closeHandler(e:MouseEvent):void
		{
			close();
		}

		public function get hCloseAlign():int
		{
			return m_hCloseAlign;
		}

		public function set hCloseAlign(value:int):void
		{
			if(m_hCloseAlign != value)
			{
				if(value != UIConstants.TOP && 
					value != UIConstants.MIDDLE && 
					value != UIConstants.BOTTOM) return;
				
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
				if(value != UIConstants.TOP && 
					value != UIConstants.MIDDLE && 
					value != UIConstants.BOTTOM) return;
				
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
		
		public function show(disContainer:DisplayObjectContainer = null):void
		{
			if(disContainer == null) StageRef.addChild(this);
			else disContainer.addChild(this);
		}
		
		public function reShow():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function close():void
		{
			DisposeUtil.free(this);
		}

		override public function dispose():void
		{
			if(m_closeBtn) m_closeBtn.removeEventListener(MouseEvent.CLICK, __closeHandler);
			
			DisposeUtil.free(m_closeBtn);
			m_closeBtn = null;
			
			DisposeUtil.free(m_titleBar);
			m_titleBar = null;
			
			super.dispose();
		}
	}
}