package knightage.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.comps.UIMgr;
	import jsion.display.Label;
	import jsion.display.TitleWindow;
	import jsion.utils.StringUtil;
	
	public class Alert extends TitleWindow
	{
		private static const TitleBackgroundBMD:BitmapData = new BitmapData(1, 1, true, 0x00000000);
		private static const AlertBackgroundBMD:AlertBackgroundAsset = new AlertBackgroundAsset(0, 0);
		private static const AlertCloseUpBMD:AlertCloseUpAsset = new AlertCloseUpAsset(0, 0);
		
		private static const ContentWidth:int = 358;
		private static const ContentHeight:int = 124;
		
		public static const DefaultStyle:StyleSheet = new StyleSheet();
		public static const DefaultTextFormat:TextFormat = new TextFormat(null, 17);
		
		public static const OK:int = 2;
		
		public static const Cancel:int = 4;
		
		public static const Yes:int = 8;
		
		public static const No:int = 16;
		
		private var m_msg:String;
		private var m_msgLabel:Label;
		
		private var m_okBtn:YellowButton;
		
		private var m_cancelBtn:YellowButton;
		
		private var m_okLabel:String;
		
		private var m_cancelLabel:String;
		
		private var m_callback:Function;
		
		private var m_closabe:Boolean;
		
		private var m_buttons:int;
		
		private var m_html:Boolean;
		
		public function Alert(msg:String = "提示消息", html:Boolean = false, callback:Function = null, buttons:int = OK, okLabel:String = null, cancelLabel:String = null, closabe:Boolean = true, modal:Boolean = true)
		{
			m_msg = msg;
			m_html = html;
			m_callback = callback;
			m_closabe = closabe;
			m_buttons = buttons;
			
			if(StringUtil.isNullOrEmpty(okLabel))
			{
				if((m_buttons & Yes) == Yes)
				{
					m_okLabel = "是";
				}
				else
				{
					m_okLabel = "确 定";
				}
			}
			else
			{
				m_okLabel = okLabel;
			}
			
			if(StringUtil.isNullOrEmpty(cancelLabel))
			{
				if((m_buttons & No) == No)
				{
					m_cancelLabel = "否";
				}
				else
				{
					m_cancelLabel = "取 消";
				}
			}
			else
			{
				m_cancelLabel = cancelLabel;
			}
			
			super(modal);
		}
		
		override protected function configUI():void
		{
			freeBMD = false;
			
			beginChanges();
			
			titleVOffset = -2;
			
			background = new Bitmap(AlertBackgroundBMD);
			var bmp:Bitmap = new Bitmap(TitleBackgroundBMD);
			bmp.width = 100;
			bmp.height = 50;
			titleBackground = bmp;
			closeUpImage = new Bitmap(AlertCloseUpBMD);
			contentOffsetX = 35;
			contentOffsetY = 55;
			
			commitChanges();
			
			configLabel();
			
			configButton();
		}
		
		private function configLabel():void
		{
			m_msgLabel = new Label();
			
			m_msgLabel.beginChanges();
			
			m_msgLabel.html = m_html;
			m_msgLabel.text = m_msg;
			m_msgLabel.textColor = 0xFFFFFF;
			m_msgLabel.styleSheet = DefaultStyle;
			m_msgLabel.textFormat = DefaultTextFormat;
			
			m_msgLabel.commitChanges();
			
			addToContent(m_msgLabel);
			
			m_msgLabel.x = (ContentWidth - m_msgLabel.width) / 2;
			m_msgLabel.y = (ContentHeight - m_msgLabel.height) / 2;
		}
		
		private function configButton():void
		{
			var okBtn:Boolean = false, cancelBtn:Boolean = false;
			
			if((m_buttons & OK) == OK || (m_buttons & Yes) == Yes)
			{
				okBtn = true;
				m_okBtn = new YellowButton(m_okLabel);
				m_okBtn.addEventListener(MouseEvent.CLICK, __okClickHandler);
				addToContent(m_okBtn);
			}
			
			if((m_buttons & Cancel) == Cancel || (m_buttons & No) == No)
			{
				cancelBtn = true;
				m_cancelBtn = new YellowButton(m_cancelLabel);
				m_cancelBtn.addEventListener(MouseEvent.CLICK, __cancelClickHandler);
				addToContent(m_cancelBtn);
			}
			
			if(okBtn && cancelBtn)
			{
				m_okBtn.x = 85;
				m_okBtn.y = ContentHeight + 10;
				
				m_cancelBtn.x = m_okBtn.x + m_okBtn.width + 36;
				m_cancelBtn.y = m_okBtn.y;
			}
			else
			{
				if(okBtn)
				{
					m_okBtn.x = (ContentWidth - m_okBtn.width) / 2;
					m_okBtn.y = ContentHeight + 10;
				}
				else if(cancelBtn)
				{
					m_cancelBtn.x = (ContentWidth - m_cancelBtn.width) / 2;
					m_cancelBtn.y = ContentHeight + 10;
				}
			}
		}
		
		private function __okClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			if(m_callback != null) m_callback(true);
			
			super.close();
		}
		
		private function __cancelClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			if(m_callback != null) m_callback(false);
			
			super.close();
		}
		
		override public function close():void
		{
			if(m_closabe)
			{
				if(m_callback != null) m_callback(false);
				
				super.close();
			}
			else
			{
				if(m_callback != null) m_callback(false);
			}
		}
		
		override public function dispose():void
		{
			m_okBtn = null;
			m_cancelBtn = null;
			m_msgLabel = null;
			m_callback = null;
			
			super.dispose();
		}
		
		public static function show(msg:String = "提示消息", html:Boolean = false, callback:Function = null, buttons:int = OK, okLabel:String = null, cancelLabel:String = null, closabe:Boolean = true, modal:Boolean = true):void
		{
			var alert:Alert = new Alert(msg, html, callback, buttons, okLabel, cancelLabel, closabe, modal);
			
			UIMgr.addAlert(alert);
		}
	}
}