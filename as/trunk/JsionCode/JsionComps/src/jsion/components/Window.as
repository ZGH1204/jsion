package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.IntRectangle;
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class Window extends FocusRoot
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const LEFT:String = CompGlobal.LEFT;
		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		public static const CENTER:String = CompGlobal.CENTER;
		
		
		public static const VGAP:String = CompGlobal.VGAP;
		
		public static const TOP:String = CompGlobal.TOP;
		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		
		private var m_background:DisplayObject;
		
		
		private var m_dragger:TitleDragger;
		
		
		private var m_titleBar:TitleBar;
		private var m_closeBtn:JButton;
		
		
		private var m_title:String;
		
		private var m_showTitle:Boolean;
		private var m_titleHAlign:String;
		private var m_titleOffsetX:Number;
		private var m_titleVAlign:String;
		private var m_titleOffsetY:Number;
		
		
		private var m_showCloseBtn:Boolean;
		private var m_closeOffsetX:Number;
		private var m_closeOffsetY:Number;
		
		private var m_fullTitleDragger:Boolean;
		
		public function Window(title:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_title = title;
			
			m_titleVAlign = TOP;
			m_titleHAlign = CENTER;
			
			m_titleOffsetY = 0;
			m_titleOffsetX = 0;
			m_showTitle = true;
			
			m_closeOffsetX = 0;
			m_closeOffsetY = 0;
			m_showCloseBtn = true;
			
			m_fullTitleDragger = false;
			
			super(container, xPos, yPos);
		}
		
		public function get fullTitleDragger():Boolean
		{
			return m_fullTitleDragger;
		}
		
		public function set fullTitleDragger(value:Boolean):void
		{
			if(m_fullTitleDragger != value)
			{
				m_fullTitleDragger = value;
				
				invalidate();
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
		
		public function get showTitle():Boolean
		{
			return m_showTitle;
		}

		public function set showTitle(value:Boolean):void
		{
			if(m_showTitle != value)
			{
				m_showTitle = value;
				
				invalidate();
			}
		}
		
		public function get titleHAlign():String
		{
			return m_titleHAlign;
		}
		
		public function set titleHAlign(value:String):void
		{
			if(m_titleHAlign != value)
			{
				m_titleHAlign = value;
				
				invalidate();
			}
		}
		
		public function get titleOffsetX():Number
		{
			return m_titleOffsetX;
		}
		
		public function set titleOffsetX(value:Number):void
		{
			if(m_titleOffsetX != value)
			{
				m_titleOffsetX = value;
				
				invalidate();
			}
		}

//		public function get titleVAlign():String
//		{
//			return m_titleVAlign;
//		}
//
//		public function set titleVAlign(value:String):void
//		{
//			if(m_titleVAlign != value)
//			{
//				m_titleVAlign = value;
//				
//				invalidate();
//			}
//		}

		public function get titleOffsetY():Number
		{
			return m_titleOffsetY;
		}

		public function set titleOffsetY(value:Number):void
		{
			if(m_titleOffsetY != value)
			{
				m_titleOffsetY = value;
				
				invalidate();
			}
		}

		public function get titleBar():TitleBar
		{
			return m_titleBar;
		}
		
		public function get titleWidth():Number
		{
			return m_titleBar.realWidth;
		}
		
		public function set titleWidth(value:Number):void
		{
			if(m_titleBar.realWidth != value)
			{
				m_titleBar.width = value;
				
				invalidate();
			}
		}
		
		public function get titleHeight():Number
		{
			return m_titleBar.realHeight;
		}
		
		public function set titleHeight(value:Number):void
		{
			if(m_titleBar.realHeight != value)
			{
				m_titleBar.height = value;
				
				invalidate();
			}
		}
		
		public function get showCloseBtn():Boolean
		{
			return m_showCloseBtn;
		}
		
		public function set showCloseBtn(value:Boolean):void
		{
			if(m_showCloseBtn != value)
			{
				m_showCloseBtn = value;
				
				invalidate();
			}
		}
		
		public function get closeOffsetX():Number
		{
			return m_closeOffsetX;
		}
		
		public function set closeOffsetX(value:Number):void
		{
			if(m_closeOffsetX != value)
			{
				m_closeOffsetX = value;
				
				invalidate();
			}
		}
		
		public function get closeOffsetY():Number
		{
			return m_closeOffsetY;
		}
		
		public function set closeOffsetY(value:Number):void
		{
			if(m_closeOffsetY != value)
			{
				m_closeOffsetY = value;
				
				invalidate();
			}
		}
		
		public function setTitleBarStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_titleBar.setStyle(key, value, freeBMD);
		}
		
		public function setTitleLabelStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_titleBar.setLabelStyle(key, value, freeBMD);
		}
		
		public function setCloseStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_closeBtn.setStyle(key, value, freeBMD);
		}
		
		override protected function initEvents():void
		{
			m_closeBtn.addEventListener(MouseEvent.CLICK, __closeClickHandler);
		}
		
		private function __closeClickHandler(e:MouseEvent):void
		{
			onClose();
		}
		
		protected function onClose():void
		{
			DisposeUtil.free(this);
		}
		
		override protected function addChildren():void
		{
			m_titleBar = new TitleBar(this);
			addChild(m_titleBar);
			
			m_dragger = new TitleDragger(this);
			addChild(m_dragger);
			
			m_closeBtn = new JButton();
			addChild(m_closeBtn);
		}
		
		override public function draw():void
		{
			if(m_background == null)
			{
				m_background = getDisplayObject(BACKGROUND);
				addChild(m_background);
				DepthUtil.bringToBottom(m_background);
				
				if(m_background)
				{
					if(m_width <= 0) m_width = m_background.width;
					if(m_height <= 0) m_height = m_background.height;
				}
			}
			
			updateTitleBar();
			
			updateCloseButton();
			
			if(m_fullTitleDragger)
			{
				m_dragger.drawTrigger(0, m_titleBar.y, realWidth, m_titleBar.realHeight);
			}
			else
			{
				m_dragger.drawTrigger(m_titleBar.x, m_titleBar.y, m_titleBar.realWidth, m_titleBar.realHeight);
			}
			
			if(m_background)
			{
				m_background.width = realWidth;
				m_background.height = realHeight;
			}
			
			super.draw();
		}
		
		private function updateTitleBar():void
		{
			if(m_titleBar == null) return;
			
			m_titleBar.visible = m_showTitle;
			
			if(m_showTitle == false) return;
			
			m_titleBar.title = m_title;
			
			m_titleBar.drawAtOnce();
			
			var rect:IntRectangle = new IntRectangle();
			
			rect.width = m_titleBar.realWidth;
			rect.height = m_titleBar.realHeight;
			
			CompUtil.layoutPosition(realWidth, realHeight, m_titleHAlign, m_titleOffsetX, m_titleVAlign, m_titleOffsetY, rect);
			
			m_titleBar.move(rect.x, rect.y);
		}
		
		private function updateCloseButton():void
		{
			if(m_closeBtn == null) return;
			
			m_closeBtn.drawAtOnce();
			
			m_closeBtn.visible = m_showCloseBtn;
			
			if(m_showCloseBtn)
			{
				m_closeBtn.x = realWidth - m_closeBtn.realWidth - m_closeOffsetX;
				m_closeBtn.y = m_closeOffsetY;
			}
		}
		
		override public function dispose():void
		{
			if(m_closeBtn) m_closeBtn.removeEventListener(MouseEvent.CLICK, __closeClickHandler);
			
			DisposeUtil.free(m_dragger);
			m_dragger = null;
			
			DisposeUtil.free(m_titleBar);
			m_titleBar = null;
			
			DisposeUtil.free(m_closeBtn);
			m_closeBtn = null;
			
			m_background = null;
			
			super.dispose();
		}
	}
}
import flash.display.DisplayObject;
import flash.display.Sprite;

import jsion.IDispose;
import jsion.components.Window;
import jsion.core.ddrop.DDropMgr;
import jsion.core.ddrop.IDragDrop;

class TitleDragger extends Sprite implements IDragDrop, IDispose
{
	private var m_window:Window;
	
	public function TitleDragger(window:Window)
	{
		m_window = window;
		
		DDropMgr.registeDrag(this);
	}
	
	public function get isClickDrag():Boolean
	{
		return false;
	}
	
	public function get lockCenter():Boolean
	{
		return false;
	}
	
	public function set lockCenter(value:Boolean):void
	{
	}
	
	public function get transData():*
	{
		return null;
	}
	
	public function get reviseInStage():Boolean
	{
		return true;
	}
	
	public function get freeDragingIcon():Boolean
	{
		return false;
	}
	
	public function get dragingIcon():DisplayObject
	{
		return m_window;
	}
	
	public function startDragCallback():void
	{
	}
	
	public function dragingCallback():void
	{
	}
	
	public function dropCallback():void
	{
	}
	
	public function dropHitCallback(dragger:IDragDrop, data:*):void
	{
	}
	
	public function drawTrigger(xPos:Number, yPos:Number, w:Number, h:Number):void
	{
		graphics.clear();
		graphics.beginFill(0x0, 0);
		graphics.drawRect(xPos, yPos, w, h);
		graphics.endFill();
	}
	
	public function dispose():void
	{
		DDropMgr.unregisteDrag(this);
		
		m_window = null;
	}
}