package knightage.gameui.heros.lists
{
	import knightage.HeroType;
	import knightage.gameui.heros.HeroListView;
	
	public class PikemanListPane extends HeroListView
	{
		public function PikemanListPane()
		{
			m_heroType = HeroType.Pikeman;
			super();
		}
	}
}