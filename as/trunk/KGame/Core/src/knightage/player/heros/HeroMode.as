package knightage.player.heros
{
	import jsion.HashMap;
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.DisposeUtil;

	public class HeroMode extends JsionEventDispatcher
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
		
		override public function dispose():void
		{
			DisposeUtil.free(m_list)
			m_list = null;
			
			super.dispose();
		}
	}
}