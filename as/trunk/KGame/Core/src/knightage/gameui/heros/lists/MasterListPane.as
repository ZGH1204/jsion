package knightage.gameui.heros.lists
{
	import knightage.HeroType;
	import knightage.gameui.heros.HeroListView;
	
	public class MasterListPane extends HeroListView
	{
		public function MasterListPane()
		{
			m_heroType = HeroType.Master;
			super();
		}
	}
}