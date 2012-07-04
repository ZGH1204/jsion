package knightage.gameui.heros.lists
{
	import knightage.HeroType;
	import knightage.gameui.heros.HeroListView;
	
	public class ArcherListPane extends HeroListView
	{
		public function ArcherListPane()
		{
			m_heroType = HeroType.Archer;
			super();
		}
	}
}