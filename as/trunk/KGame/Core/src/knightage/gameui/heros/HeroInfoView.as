package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	import jsion.IDispose;
	import jsion.display.Image;
	import jsion.display.ProgressBar;
	
	import knightage.StaticRes;
	import knightage.display.KhakiButton;
	import knightage.homeui.LevelView;
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
		
		
		
		
		
		private var m_propBackground:DisplayObject;
		
		
		
		private var m_tabEquipButton:KhakiButton;
		
		
		
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
			
			m_tabEquipButton.x = 8;
			m_tabEquipButton.y = m_propBackground.y + m_propBackground.height + 6;
		}
		
		public function dispose():void
		{
		}
	}
}