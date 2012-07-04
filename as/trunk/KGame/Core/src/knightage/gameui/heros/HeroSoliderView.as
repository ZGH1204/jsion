package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.comps.JsionSprite;
	import jsion.display.Image;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	
	import knightage.GameUtil;
	import knightage.StaticRes;
	import knightage.events.UIEvent;
	import knightage.gameui.BigPagingView;
	import knightage.player.heros.PlayerHero;
	
	public class HeroSoliderView extends JsionSprite
	{
		private var m_smallTitle:DisplayObject;
		private var m_background:Image;
		private var m_pagingView:BigPagingView;
		
		private var m_items:Array;
		
		
		private var m_hero:PlayerHero;
		
		private var m_soilderList:Array;
		
		
		public function HeroSoliderView()
		{
			super();
			
			initialized();
			
			initEvent();
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
			m_pagingView.setContentSize(m_background.width, m_background.height);
			
			m_items = [];
			
			for(var i:int = 0; i < 5; i++)
			{
				var item:HeroSoliderItemView = new HeroSoliderItemView();
				
				item.y = m_background.y + (m_background.height - item.height) / 2;
				
				addChild(item);
				
				m_items.push(item);
			}
			
			m_items[0].x = 55;
			
			JUtil.layeroutOneByOneHorizontal(18, m_items);
		}
		
		
		private function initEvent():void
		{
			m_pagingView.addEventListener(UIEvent.PAGE_CHANGED, __pageChangedHandler);
		}
		
		private function __pageChangedHandler(e:UIEvent):void
		{
			var list:Array = e.data4 as Array;
			
			clearItemsData();
			
			if(list == null) return;
			
			setItemsData(list);
		}
		
		public function setItemsData(list:Array):void
		{
			if(list == null) return;
			
			for(var i:int = 0; i < list.length; i++)
			{
				var item:HeroSoliderItemView = m_items[i];
				
				item.setData(list[i]);
				
				if(m_hero) item.setCurrentSoilderTID(m_hero.curSoliderType);
			}
		}
		
		public function setData(hero:PlayerHero):void
		{
			if(m_hero != hero)
			{
				m_hero = hero;
				
				if(m_hero)
				{
					m_soilderList = GameUtil.getSoilderListByCategory(hero.SoliderCategory);
				}
				else
				{
					m_soilderList = [];
				}
				
				m_pagingView.setDataList(m_soilderList);
				m_pagingView.setPagingData(m_items.length, m_soilderList.length);
			}
		}
		
		private function clearItemsData():void
		{
			for each(var item:HeroSoliderItemView in m_items)
			{
				item.clear();
			}
		}
		
		private function refreshView(hero:PlayerHero):void
		{
			if(hero)
			{
			}
			else
			{
				
			}
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_smallTitle);
			m_smallTitle = null;
			
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_pagingView);
			m_pagingView = null;
			
			DisposeUtil.free(m_items);
			m_items = null;
			
			m_hero = null;
			
			m_soilderList = null;
			
			super.dispose();
		}
	}
}