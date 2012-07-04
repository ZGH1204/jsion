package knightage.gameui.heros.lists
{
	import knightage.HeroType;
	import knightage.gameui.heros.HeroListView;
	
	public class InfantryListPane extends HeroListView
	{
		public function InfantryListPane()
		{
			m_heroType = HeroType.Infantry;
			super();
		}
	}
}