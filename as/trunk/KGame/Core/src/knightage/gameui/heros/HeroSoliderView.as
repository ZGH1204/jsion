package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.comps.JsionSprite;
	import jsion.display.Image;
	import jsion.utils.JUtil;
	
	import knightage.StaticRes;
	import knightage.gameui.BigPagingView;
	
	public class HeroSoliderView extends JsionSprite
	{
		private var m_smallTitle:DisplayObject;
		private var m_background:Image;
		private var m_pagingView:BigPagingView;
		
		private var m_items:Array;
		
		public function HeroSoliderView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			m_background = new Image();
			m_background.beginChanges();
			m_background.freeSource = false;
			m_background.source = StaticRes.HeroBackgroundBMD;
			m_background.scale9Insets = StaticRes.HeroBackgroundInsets;
			m_background.width = 564;
			m_background.height = 172;
			m_background.commitChanges();
			addChild(m_background);
			
			
			m_smallTitle = new Bitmap(new WenZiBingZhongAsset(0, 0));
			addChild(m_smallTitle);
			
			
			m_pagingView = new BigPagingView();
			addChild(m_pagingView);
			
			
			
			var offsetX:int = 38;
			
			
			m_smallTitle.x = offsetX + 26;
			m_smallTitle.y = 0;
			
			
			m_background.x = offsetX;
			m_background.y = m_smallTitle.y + m_smallTitle.height / 2;
			
			m_pagingView.y = m_background.y;
			m_pagingView.setContentSize(m_background.width - 8, m_background.height);
			
			m_items = [];
			
			for(var i:int = 0; i < 5; i++)
			{
				var item:HeroSoliderItemView = new HeroSoliderItemView();
				
				item.y = m_background.y + (m_background.height - item.height) / 2;
				
				addChild(item);
				
				m_items.push(item);
			}
			
			m_items[0].x = 55;
			
			JUtil.layeroutOneByOneHorizontal(35, m_items);
		}
	}
}