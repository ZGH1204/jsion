package knightage.gameui.heros
{
	import flash.display.Bitmap;
	
	import jsion.display.IconToggleButton;
	import jsion.loaders.DisplayLoader;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.player.heros.PlayerHero;
	
	public class HeroListItemView extends IconToggleButton
	{
		private var m_hero:PlayerHero;
		
		private var m_iconFile:String;
		private var m_iconLoader:DisplayLoader;
		
		public function HeroListItemView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			beginChanges();
			
			freeBMD = false;
			var bmp:Bitmap = new Bitmap(StaticRes.HeroListItemBGBMD);
			upImage = bmp;
			selectedUpImage = bmp;
			selectedUpFilters = StaticRes.ButtonDefaultSelectedUpFilters;
			selectedOverFilters = StaticRes.ButtonDefaultSelectedOverFilters;
			
			commitChanges();
		}
		
		public function get hero():PlayerHero
		{
			return m_hero;
		}
		
		public function clear():void
		{
			refreshView(null);
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
				if(m_iconFile != hero.HeadImg)
				{
					m_iconFile = hero.HeadImg;
					beginChanges();
					iconUpImage = null;
					selectedIconUpImage = null;
					commitChanges();
					DisposeUtil.free(m_iconLoader);
					m_iconLoader = new DisplayLoader(m_iconFile, Config.ResRoot);
					m_iconLoader.loadAsync(loadCallback);
				}
			}
			else
			{
				beginChanges();
				iconUpImage = null;
				selectedIconUpImage = null;
				commitChanges();
				DisposeUtil.free(m_iconLoader);
				m_iconLoader = null;
				m_iconFile = null;
				m_hero = null;
			}
		}
		
		private function loadCallback(loader:DisplayLoader, success:Boolean):void
		{
			if(success)
			{
				beginChanges();
				iconUpImage = m_iconLoader;
				selectedIconUpImage = m_iconLoader;
				commitChanges();
			}
		}
		
		override public function get allowSelected():Boolean
		{
			return m_hero != null;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_iconLoader);
			m_iconLoader = null;
			
			m_hero = null;
			m_iconFile = null;
			
			super.dispose();
		}
	}
}