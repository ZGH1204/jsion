package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	import jsion.IDispose;
	import jsion.display.Image;
	import jsion.display.Label;
	import jsion.display.ProgressBar;
	import jsion.loaders.DisplayLoader;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.homeui.LevelView;
	import knightage.player.heros.PlayerHero;
	
	public class HeroBustView extends Sprite implements IDispose
	{
		private var m_background:Image;
		
		
		private var m_wangGuan:DisplayObject;
		
		private var m_heroNameLabel:Label;
		
		private var m_topBar:DisplayObject;
		
		
		
		private var m_levelView:LevelView;
		private var m_progressBar:ProgressBar;
		
		
		
		
		private var m_attackLabel:Label;
		
		private var m_defenseLabel:Label;
		
		private var m_critLabel:Label;
		
		private var m_soilderLabel:Label;
		
		private var m_propBackground:DisplayObject;
		
		private var m_bustFile:String;
		private var m_loader:DisplayLoader;
		
		
		
		private var m_hero:PlayerHero;
		
		
		public function HeroBustView()
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
			
			
			
			
			m_heroNameLabel = new Label();
			m_heroNameLabel.beginChanges();
			m_heroNameLabel.width = 100;
			m_heroNameLabel.hAlign = Label.CENTER;
			m_heroNameLabel.filters = StaticRes.TextFilters4;
			m_heroNameLabel.textColor = StaticRes.WhiteColor;
			m_heroNameLabel.textFormat = StaticRes.TextFormat18;
			m_heroNameLabel.antiAliasType = AntiAliasType.ADVANCED;
			m_heroNameLabel.thickness = 200;
			m_heroNameLabel.sharpness = 100;
			m_heroNameLabel.text = " ";
			//m_heroNameLabel.text = "卡福利卡";
			m_heroNameLabel.commitChanges();
			addChild(m_heroNameLabel);
			
			
			m_wangGuan = new Bitmap(new WangGuanAsset(0, 0));
			addChild(m_wangGuan);
			
			
			
			
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
			m_attackLabel.text = "0";
			m_attackLabel.width = 40;
			m_attackLabel.hAlign = Label.LEFT;
			m_attackLabel.textFormat = StaticRes.TextFormat14;
			m_attackLabel.commitChanges();
			addChild(m_attackLabel);
			
			m_defenseLabel = new Label();
			m_defenseLabel.beginChanges();
			m_defenseLabel.text = "0";
			m_defenseLabel.width = 40;
			m_defenseLabel.hAlign = Label.LEFT;
			m_defenseLabel.textFormat = StaticRes.TextFormat14;
			m_defenseLabel.commitChanges();
			addChild(m_defenseLabel);
			
			m_critLabel = new Label();
			m_critLabel.beginChanges();
			m_critLabel.text = "0";
			m_critLabel.width = 40;
			m_critLabel.hAlign = Label.LEFT;
			m_critLabel.textFormat = StaticRes.TextFormat14;
			m_critLabel.commitChanges();
			addChild(m_critLabel);
			
			m_soilderLabel = new Label();
			m_soilderLabel.beginChanges();
			m_soilderLabel.text = "0";
			m_soilderLabel.width = 40;
			m_soilderLabel.hAlign = Label.LEFT;
			m_soilderLabel.textFormat = StaticRes.TextFormat14;
			m_soilderLabel.commitChanges();
			addChild(m_soilderLabel);
			
			
			
			m_topBar.x = 35;
			
			
			m_heroNameLabel.x = m_topBar.x + (m_topBar.width - m_heroNameLabel.width) / 2;
			m_heroNameLabel.y = m_topBar.y + (m_topBar.height - m_heroNameLabel.height) / 2 - 5;
			
			m_wangGuan.x = m_heroNameLabel.x - m_wangGuan.width / 2;
			m_wangGuan.y = m_heroNameLabel.y + (m_heroNameLabel.height - m_wangGuan.height) / 2;
			
			m_background.x = m_topBar.x + (m_topBar.width - m_background.width) / 2;
			m_background.y = m_topBar.y + m_topBar.height - 16;
			
			var tempWidth:int = m_levelView.width + m_progressBar.width
			var tempHeight:int = m_levelView.height;
			
			m_levelView.x = m_background.x + (m_background.width - tempWidth) / 2 - 3;
			m_levelView.y = m_background.y + m_background.height - tempHeight - 15;
			
			m_progressBar.x = m_levelView.x + m_levelView.width - 3;
			m_progressBar.y = m_levelView.y + (m_levelView.height - m_progressBar.height) / 2 - 2;
			
			m_propBackground.y = m_background.y + m_background.height - 17;
			
			m_attackLabel.x = 40;
			m_attackLabel.y = m_propBackground.y + (m_propBackground.height - m_attackLabel.height) / 2;
			m_defenseLabel.x = 108;
			m_defenseLabel.y = m_propBackground.y + (m_propBackground.height - m_defenseLabel.height) / 2;
			m_critLabel.x = 185;
			m_critLabel.y = m_propBackground.y + (m_propBackground.height - m_critLabel.height) / 2;
			m_soilderLabel.x = 255;
			m_soilderLabel.y = m_propBackground.y + (m_propBackground.height - m_soilderLabel.height) / 2;
		}
		
		public function setData(hero:PlayerHero):void
		{
			if(m_hero != hero)
			{
				m_hero = hero;
				
				refreshView(m_hero);
			}
		}
		
		private function refreshView(hero:PlayerHero):void
		{
			if(hero)
			{
				if(m_bustFile != hero.BustImg)
				{
					m_bustFile = hero.BustImg;
					DisposeUtil.free(m_loader);
					m_loader = new DisplayLoader(hero.BustImg, Config.ResRoot);
					m_loader.loadAsync(loadCallback);
					addChild(m_loader);
				}
				
				m_heroNameLabel.text = hero.TemplateName;
				//m_progressBar.value = 0;//TODO: 经验未实现
				m_levelView.setLevel(hero.lv);
				m_attackLabel.text = hero.attack.toString();
				m_defenseLabel.text = hero.defense.toString();
				m_critLabel.text = hero.crit.toString();
				m_soilderLabel.text = hero.soliders.toString();
			}
			else
			{
				m_heroNameLabel.text = "";
				//m_progressBar.value = 0;//TODO: 经验未实现
				m_levelView.setLevel(0);
				m_attackLabel.text = "0";
				m_defenseLabel.text = "0";
				m_critLabel.text = "0";
				m_soilderLabel.text = "0";
				
				m_bustFile = null;
				
				DisposeUtil.free(m_loader);
				m_loader = null;
			}
		}
		
		private function loadCallback(loader:DisplayLoader, success:Boolean):void
		{
			loader.x = (width - loader.width) / 2;
			loader.y = m_progressBar.y + m_progressBar.height - loader.height;
			
			DepthUtil.bringToTop(m_levelView);
			m_progressBar.bring2Top();
		}
		
		public function dispose():void
		{
		}
	}
}