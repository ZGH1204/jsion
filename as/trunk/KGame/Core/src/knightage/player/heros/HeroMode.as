package knightage.player.heros
{
	import jsion.HashMap;
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.DisposeUtil;
	
	import knightage.events.HeroEvent;
	import knightage.mgrs.TemplateMgr;

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
			
			TemplateMgr.fillPlayerHero(hero);
			
			m_list.put(hero.heroID, hero);
			
			dispatchEvent(new HeroEvent(HeroEvent.ADD_HERO, hero));
		}
		
		/**
		 * 通过英雄类型获取对应的英雄列表
		 * @param type
		 * @return 
		 * 
		 */		
		public function getHeroListByType(type:int):Array
		{
			var temp:Array = m_list.getValues();
			
			var list:Array = [];
			
			for each(var h:PlayerHero in temp)
			{
				if(h.HeroType == type) list.push(h);
			}
			
			return list;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_list)
			m_list = null;
			
			super.dispose();
		}
	}
}