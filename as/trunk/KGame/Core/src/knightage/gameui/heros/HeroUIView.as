package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.display.TabPanel;
	import jsion.utils.DisposeUtil;
	import jsion.utils.InstanceUtil;
	
	import knightage.display.Frame;
	import knightage.gameui.heros.lists.ArcherListPane;
	import knightage.gameui.heros.lists.CavalryListPane;
	import knightage.gameui.heros.lists.InfantryListPane;
	import knightage.gameui.heros.lists.MasterListPane;
	import knightage.gameui.heros.lists.PikemanListPane;
	
	public class HeroUIView extends Frame
	{
		private var m_titleIcon:DisplayObject;
		
		private var m_heroInfoView:HeroInfoView;
		
		private var m_heroTabPanel:TabPanel;
		
		private var m_heroSoliderView:HeroSoliderView;
		
		public function HeroUIView()
		{
			super("", false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			m_titleIcon = new Bitmap(new HeroTitleIconAsset(0, 0));
			
			
			beginChanges();
			
			width = 700;
			height = 550;
			
			contentOffsetX = 30;
			contentOffsetY = 30;
			
			titleView = m_titleIcon;
			titleVOffset = -8;
			
			commitChanges();
			
			
			
			m_heroInfoView = new HeroInfoView();
			addToContent(m_heroInfoView);
			
			
			m_heroTabPanel = new TabPanel();
			addToContent(m_heroTabPanel);
			
			m_heroTabPanel.beginChanges();
			m_heroTabPanel.tabOffset = 22;
			m_heroTabPanel.paneOffset = -11;
			m_heroTabPanel.addTab(new HeroTabButton(new Bitmap(new InfantryTabUpAsset(0, 0)), new Bitmap(new InfantryTabSelectedUpAsset(0, 0))), InfantryListPane);
			m_heroTabPanel.addTab(new HeroTabButton(new Bitmap(new CavalryTabUpAsset(0, 0)), new Bitmap(new CavalryTabSelectedUpAsset(0, 0))), CavalryListPane);
			m_heroTabPanel.addTab(new HeroTabButton(new Bitmap(new ArcherTabUpAsset(0, 0)), new Bitmap(new ArcherTabSelectedUpAsset(0, 0))), ArcherListPane);
			m_heroTabPanel.addTab(new HeroTabButton(new Bitmap(new MasterTabUpAsset(0, 0)), new Bitmap(new MasterTabSelectedUpAsset(0, 0))), MasterListPane);
			m_heroTabPanel.addTab(new HeroTabButton(new Bitmap(new PikemanTabUpAsset(0, 0)), new Bitmap(new PikemanTabSelectedUpAsset(0, 0))), PikemanListPane);
			m_heroTabPanel.commitChanges();
			
			m_heroSoliderView = new HeroSoliderView();
			addToContent(m_heroSoliderView);
			
			
			m_heroInfoView.x = 0;
			m_heroInfoView.y = 0;
			
			m_heroTabPanel.x = m_heroInfoView.x + m_heroInfoView.width + 10;
			m_heroTabPanel.y = m_heroInfoView.y;
			
			
			m_heroSoliderView.x = m_heroInfoView.x;
			m_heroSoliderView.y = m_heroInfoView.y + m_heroInfoView.height + 10;
		}
		
		override public function dispose():void
		{
			InstanceUtil.removeSingletion(HeroUIView);
			
			DisposeUtil.free(m_titleIcon);
			m_titleIcon = null;
			
			m_heroInfoView = null;
			
			super.dispose();
		}
	}
}