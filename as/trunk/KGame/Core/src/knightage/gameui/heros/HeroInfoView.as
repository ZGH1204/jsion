package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	
	import jsion.IDispose;
	import jsion.display.Image;
	import jsion.display.Label;
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.BlueButton;
	import knightage.display.KhakiButton;
	import knightage.display.RedButton;
	import knightage.homeui.LevelView;
	import knightage.mgrs.MsgTipMgr;
	import knightage.player.goods.EquipType;
	
	public class HeroInfoView extends Sprite implements IDispose
	{
		private var m_background:Image;
		
		private var m_topBar:DisplayObject;
		
		
		
		private var m_weaponItem:EquipItem;
		
		private var m_armorItem:EquipItem;
		
		
		private var m_cloakItem:EquipItem;
		
		private var m_mountItem:EquipItem;
		
		
		
		
		private var m_levelView:LevelView;
		private var m_progressBar:ProgressBar;
		
		
		
		
		private var m_attackLabel:Label;
		
		private var m_defenseLabel:Label;
		
		private var m_critLabel:Label;
		
		private var m_soilderLabel:Label;
		
		private var m_propBackground:DisplayObject;
		
		
		
		private var m_tabEquipButton:KhakiButton;
		
		private var m_cultivateButton:BlueButton;
		
		private var m_fireButton:RedButton;
		
		public function HeroInfoView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_background = new Image();
			m_background.beginChanges();
			m_background.freeSource = false;
			m_background.source = StaticRes.HeroBackgroundBMD;
			m_background.scale9Insets = StaticRes.HeroBackgroundInsets;
			m_background.width = 200;
			m_background.height = 210;
			m_background.commitChanges();
			addChild(m_background);
			
			m_topBar = new Bitmap(new HeroJinDaiAsset(0, 0));
			addChild(m_topBar);
			
			
			
			m_weaponItem = new EquipItem(EquipType.Weapon);
			addChild(m_weaponItem);
			
			
			m_armorItem = new EquipItem(EquipType.Armor);
			addChild(m_armorItem);
			
			m_cloakItem = new EquipItem(EquipType.Cloak);
			addChild(m_cloakItem);
			
			m_mountItem = new EquipItem(EquipType.Mount);
			addChild(m_mountItem);
			
			
			
			m_progressBar = new ProgressBar(ProgressBar.HORIZONTAL, ProgressBar.MASK);
			m_progressBar.beginChanges();
			m_progressBar.freeBMD = true;
			m_progressBar.background = new Bitmap(new ExpProgressBackgroundAsset(0, 0));
			m_progressBar.progressBar = new Bitmap(new ExpProgressBarAsset(0, 0));
			m_progressBar.value = 100;
			m_progressBar.barOffsetX = 1;
			m_progressBar.barOffsetY = 4;
			m_progressBar.commitChanges();
			addChild(m_progressBar);
			
			
			
			m_levelView = new LevelView(0, LevelView.HERO);
			addChild(m_levelView);
			
			
			
			
			
			
			m_propBackground = new Bitmap(new HeroPropAsset(0, 0));
			addChild(m_propBackground);
			
			m_attackLabel = new Label();
			m_attackLabel.beginChanges();
			m_attackLabel.text = "200";
			m_attackLabel.width = 40;
			m_attackLabel.hAlign = Label.LEFT;
			m_attackLabel.textFormat = StaticRes.TextFormat14;
			m_attackLabel.commitChanges();
			addChild(m_attackLabel);
			
			m_defenseLabel = new Label();
			m_defenseLabel.beginChanges();
			m_defenseLabel.text = "200";
			m_defenseLabel.width = 40;
			m_defenseLabel.hAlign = Label.LEFT;
			m_defenseLabel.textFormat = StaticRes.TextFormat14;
			m_defenseLabel.commitChanges();
			addChild(m_defenseLabel);
			
			m_critLabel = new Label();
			m_critLabel.beginChanges();
			m_critLabel.text = "000";
			m_critLabel.width = 40;
			m_critLabel.hAlign = Label.LEFT;
			m_critLabel.textFormat = StaticRes.TextFormat14;
			m_critLabel.commitChanges();
			addChild(m_critLabel);
			
			m_soilderLabel = new Label();
			m_soilderLabel.beginChanges();
			m_soilderLabel.text = "000";
			m_soilderLabel.width = 40;
			m_soilderLabel.hAlign = Label.LEFT;
			m_soilderLabel.textFormat = StaticRes.TextFormat14;
			m_soilderLabel.commitChanges();
			addChild(m_soilderLabel);
			
			
			
			
			
			
			
			m_tabEquipButton = new KhakiButton("更换装备");
			m_tabEquipButton.beginChanges();
			m_tabEquipButton.embedFonts = true;
			m_tabEquipButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_tabEquipButton.labelUpFilters = StaticRes.TextFilters8;
			m_tabEquipButton.labelOverFilters = StaticRes.TextFilters8;
			m_tabEquipButton.labelDownFilters = StaticRes.TextFilters8;
			m_tabEquipButton.vOffset = -2;
			m_tabEquipButton.width = 120;
			m_tabEquipButton.height = 46;
			m_tabEquipButton.commitChanges();
			addChild(m_tabEquipButton);
			
			
			
			
			m_cultivateButton = new BlueButton("培养");
			m_cultivateButton.beginChanges();
			m_cultivateButton.embedFonts = true;
			m_cultivateButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_cultivateButton.labelUpFilters = StaticRes.TextFilters8;
			m_cultivateButton.labelOverFilters = StaticRes.TextFilters8;
			m_cultivateButton.labelDownFilters = StaticRes.TextFilters8;
			m_cultivateButton.vOffset = -2;
			m_cultivateButton.width = 85;
			m_cultivateButton.height = 46;
			m_cultivateButton.commitChanges();
			addChild(m_cultivateButton);
			
			
			
			m_fireButton = new RedButton("解雇");
			m_fireButton.beginChanges();
			m_fireButton.embedFonts = true;
			m_fireButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_fireButton.labelUpFilters = StaticRes.TextFilters8;
			m_fireButton.labelOverFilters = StaticRes.TextFilters8;
			m_fireButton.labelDownFilters = StaticRes.TextFilters8;
			m_fireButton.vOffset = -2;
			m_fireButton.width = 85;
			m_fireButton.height = 46;
			m_fireButton.commitChanges();
			addChild(m_fireButton);
			
			
			
			m_topBar.x = 35;
			
			m_background.x = m_topBar.x + (m_topBar.width - m_background.width) / 2;
			m_background.y = m_topBar.y + m_topBar.height - 16;
			
			
			m_weaponItem.x = 0;
			m_weaponItem.y = m_topBar.height - 10;
			
			m_armorItem.x = m_weaponItem.x;
			m_armorItem.y = m_weaponItem.y + m_weaponItem.height + 2;
			
			m_cloakItem.x = m_weaponItem.x + m_weaponItem.width + 144;
			m_cloakItem.y = m_weaponItem.y;
			
			m_mountItem.x = m_cloakItem.x;
			m_mountItem.y = m_armorItem.y;
			
			
			m_levelView.x = m_armorItem.x + m_armorItem.width - 2;
			m_levelView.y = m_armorItem.y + m_armorItem.height - m_levelView.height + 5;
			
			
			m_progressBar.x = m_levelView.x + m_levelView.width - 2;
			m_progressBar.y = m_levelView.y + (m_levelView.height - m_progressBar.height) / 2;
			
			
			m_propBackground.y = m_armorItem.y + m_armorItem.height + 3;
			
			m_attackLabel.x = 40;
			m_attackLabel.y = m_propBackground.y + (m_propBackground.height - m_attackLabel.height) / 2;
			m_defenseLabel.x = 108;
			m_defenseLabel.y = m_propBackground.y + (m_propBackground.height - m_defenseLabel.height) / 2;
			m_critLabel.x = 185;
			m_critLabel.y = m_propBackground.y + (m_propBackground.height - m_critLabel.height) / 2;
			m_soilderLabel.x = 255;
			m_soilderLabel.y = m_propBackground.y + (m_propBackground.height - m_soilderLabel.height) / 2;
			
			m_tabEquipButton.x = 2;
			m_tabEquipButton.y = m_propBackground.y + m_propBackground.height + 6;
			
			m_cultivateButton.x = m_tabEquipButton.x + m_tabEquipButton.width + 6;
			m_cultivateButton.y = m_tabEquipButton.y;
			
			m_fireButton.x = m_cultivateButton.x + m_cultivateButton.width + 6;
			m_fireButton.y = m_cultivateButton.y;
			
			
			
			
			m_tabEquipButton.addEventListener(MouseEvent.CLICK, __tabEquipClickHandler);
			m_cultivateButton.addEventListener(MouseEvent.CLICK, __cultivateClickHandler);
			m_fireButton.addEventListener(MouseEvent.CLICK, __fireClickHandler);
		}
		
		private function __tabEquipClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("更换装备功能开发中...");
		}
		
		private function __cultivateClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("培养功能开发中...");
		}
		
		private function __fireClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("解雇功能开发中...");
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_tabEquipButton);
			m_tabEquipButton = null;
			
			DisposeUtil.free(m_cultivateButton);
			m_cultivateButton = null;
			
			DisposeUtil.free(m_fireButton);
			m_fireButton = null;
			
			DisposeUtil.freeChildren(this);
		}
	}
}