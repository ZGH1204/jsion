package knightage.gameui.heros.lists
{
	import knightage.HeroType;
	import knightage.gameui.heros.HeroListView;
	
	public class CavalryListPane extends HeroListView
	{
		public function CavalryListPane()
		{
			m_heroType = HeroType.Cavalry;
			super();
		}
	}
}