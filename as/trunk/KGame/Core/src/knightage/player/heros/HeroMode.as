package knightage.player.heros
{
	import jsion.HashMap;

	public class HeroMode
	{
		private var m_list:HashMap;
		
		public function HeroMode()
		{
			m_list = new HashMap();
		}
		
		public function get heroCount():int
		{
			return m_list.size;
		}
		
		public function addHero(hero:PlayerHero):void
		{
			if(m_list.containsKey(hero.heroID))
			{
				throw new Error("指定ID的英雄已存在!");
				return;
			}
			
			m_list.put(hero.heroID, hero);
		}
	}
}