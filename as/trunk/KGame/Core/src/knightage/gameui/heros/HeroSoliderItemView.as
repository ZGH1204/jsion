package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.debug.DEBUG;
	import jsion.display.Label;
	import jsion.loaders.DisplayLoader;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.BlueButton;
	import knightage.mgrs.MsgTipMgr;
	import knightage.templates.SoilderTemplate;
	
	public class HeroSoliderItemView extends Sprite implements IDispose
	{
		private var m_background:DisplayObject;
		
		private var m_currentSoilderTypeBmp:DisplayObject;
		
		private var m_transferButton:BlueButton;
		
		private var m_lvLabel:Label;
		
		private var m_nameLabel:Label;
		
		
		private var m_solider:SoilderTemplate;
		
		
		private var m_iconFile:String;
		private var m_loader:DisplayLoader;
		
		private var m_currentTID:int;
		
		public function HeroSoliderItemView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			m_background = new Bitmap(StaticRes.HeroSoliderBackgroundBMD);
			addChild(m_background);
			
			m_transferButton = new BlueButton();
			m_transferButton.beginChanges();
			m_transferButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_transferButton.width = 74;
			m_transferButton.height = 36;
			m_transferButton.embedFonts = true;
			m_transferButton.label = "转 职";
			m_transferButton.textFormat = StaticRes.HaiBaoEmbedTextFormat15;
			m_transferButton.labelUpFilters = StaticRes.TextFilters4;
			m_transferButton.labelOverFilters = StaticRes.TextFilters4;
			m_transferButton.labelDownFilters = StaticRes.TextFilters4;
			m_transferButton.enabled = false;
			m_transferButton.commitChanges();
			addChild(m_transferButton);
			
			
			m_currentSoilderTypeBmp = new Bitmap(StaticRes.HeroCurrentSoilderTypeBMD);
			m_currentSoilderTypeBmp.visible = false;
			addChild(m_currentSoilderTypeBmp);
			
			
			m_lvLabel = new Label();
			m_lvLabel.beginChanges();
			m_lvLabel.width = 60;
			m_lvLabel.hAlign = Label.CENTER;
			m_lvLabel.embedFonts = true;
			m_lvLabel.textColor = StaticRes.WhiteColor;
			m_lvLabel.filters = StaticRes.TextFilters4;
			m_lvLabel.textFormat = StaticRes.WaWaEmbedTextFormat16;
			//m_lvLabel.text = "Lv2";
			m_lvLabel.text = " ";
			m_lvLabel.commitChanges();
			addChild(m_lvLabel);
			
			
			m_nameLabel = new Label();
			m_nameLabel.beginChanges();
			m_nameLabel.width = 60;
			m_nameLabel.hAlign = Label.CENTER;
			//m_nameLabel.embedFonts = true;
			//m_nameLabel.textColor = StaticRes.WhiteColor;
			//m_nameLabel.filters = StaticRes.TextFilters4;
			m_nameLabel.textFormat = StaticRes.TextFormat14;
			//m_nameLabel.text = "钉棒兵";
			m_nameLabel.text = " ";
			m_nameLabel.commitChanges();
			addChild(m_nameLabel);
			
			
			
			
			
			
			
			m_lvLabel.x = (width - m_lvLabel.width) / 2;
			
			m_background.x = 0;
			m_background.y = 20;
			
			m_nameLabel.x = m_background.x + (m_background.width - m_nameLabel.width) / 2;
			m_nameLabel.y = m_background.y + m_background.height - m_nameLabel.height - 3;
			
			m_transferButton.x = m_background.x + (m_background.width - m_transferButton.width) / 2;
			m_transferButton.y = m_background.y + m_background.height;
			
			m_currentSoilderTypeBmp.x = m_transferButton.x + (m_transferButton.width - m_currentSoilderTypeBmp.width) / 2;
			m_currentSoilderTypeBmp.y = m_transferButton.y + (m_transferButton.height - m_currentSoilderTypeBmp.height) / 2;
			
			
			
			
			
			
			m_transferButton.addEventListener(MouseEvent.CLICK, __transferClickHandler);
		}
		
		private function __transferClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("转职功能开发中...");
		}
		
		public function setData(solider:SoilderTemplate):void
		{
			if(m_solider != solider)
			{
				m_solider = solider;
				
				refreshView(m_solider);
			}
		}
		
		public function setCurrentSoilderTID(tid:int):void
		{
			m_currentTID = tid;
			
			if(m_solider && m_solider.TemplateID == m_currentTID)
			{
				m_currentSoilderTypeBmp.visible = true;
				m_transferButton.visible = false;
			}
			else
			{
				m_currentSoilderTypeBmp.visible = false;
				m_transferButton.visible = true;
			}
		}
		
		public function clear():void
		{
			refreshView(null);
		}
		
		private function refreshView(solider:SoilderTemplate):void
		{
			if(solider)
			{
				m_lvLabel.text = "Lv" + solider.NextLv;
				m_nameLabel.text = solider.TemplateName;
				m_transferButton.enabled = true;
				
				if(m_iconFile != solider.Icon)
				{
					m_iconFile = solider.Icon;
					DisposeUtil.free(m_loader);
					m_loader = new DisplayLoader(m_iconFile, Config.ResRoot);
					addChild(m_loader);
					m_loader.loadAsync(loadCallback);
				}
			}
			else
			{
				m_lvLabel.text = " ";
				m_nameLabel.text = " ";
				m_transferButton.enabled = false;
				
				m_iconFile = null;
				
				DisposeUtil.free(m_loader);
				m_loader = null;
				
				m_solider = null;
			}
		}
		
		private function loadCallback(loader:DisplayLoader, success:Boolean):void
		{
			if(success)
			{
				loader.x = m_background.x + int((m_background.width - loader.width) / 2);
				loader.y = m_background.y + m_background.height - loader.height - 22;
			}
			else
			{
				DEBUG.error("兵种头像加载失败!Path：" + m_iconFile);
			}
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_background, false);
			m_background = null;
			
			DisposeUtil.free(m_currentSoilderTypeBmp, false);
			m_currentSoilderTypeBmp = null;
			
			DisposeUtil.free(m_transferButton);
			m_transferButton = null;
			
			DisposeUtil.free(m_lvLabel);
			m_lvLabel = null;
			
			DisposeUtil.free(m_nameLabel);
			m_nameLabel = null;
			
			DisposeUtil.free(m_loader);
			m_loader = null;
			
			m_solider = null;
			m_iconFile = null;
		}
	}
}