package knightage.gameui.heros
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.comps.JsionSprite;
	import jsion.comps.ToggleGroup;
	import jsion.display.ITabPanel;
	import jsion.display.Image;
	import jsion.events.DisplayEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	
	import knightage.StaticRes;
	import knightage.events.UIEvent;
	import knightage.gameui.PagingView;
	import knightage.mgrs.PlayerMgr;
	import knightage.player.heros.HeroMode;
	import knightage.player.heros.PlayerHero;
	
	public class HeroListView extends JsionSprite implements ITabPanel
	{
		private static const OffsetX:int = 29;
		private static const OffsetY:int = 24;
		
		private static const PaddingX:int = 4;
		private static const PaddingY:int = 4;
		
		private var m_width:int;
		private var m_height:int;
		
		private var m_background:Image;
		
		private var m_items:Array;
		
		private var m_row:int;
		
		private var m_column:int;
		
		private var m_group:ToggleGroup;
		
		private var m_pagingView:PagingView;
		
		private var m_selectedHero:PlayerHero;
		
		protected var m_heroMode:HeroMode;
		
		protected var m_heroList:Array;
		
		protected var m_heroType:int;
		
		public function HeroListView(row:int = 3, column:int = 4)
		{
			m_row = row;
			
			m_column = column;
			
			super();
			
			initialized();
			
			initEvent();
			
			setData(PlayerMgr.self.heroMode);
		}
		
		private function initialized():void
		{
			m_background = new Image();
			m_background.beginChanges();
			m_background.freeSource = false;
			m_background.source = StaticRes.HeroListBackgroundBMD;
			m_background.scale9Insets = StaticRes.HeroListBackgroundInset;
			m_background.width = 316;
			m_background.height = 270;
			m_background.commitChanges();
			addChild(m_background);
			
			m_width = m_background.width;
			m_height = m_background.height;
			
			
			m_items = [];
			
			m_group = new ToggleGroup();
			m_group.autoSelected = false;
			
			var posX:int;
			var posY:int = OffsetY;
			
			for(var j:int = 0; j < m_row; j++)
			{
				posX = OffsetX;
				
				var item:HeroListItemView;
				
				for(var i:int = 0; i < m_column; i++)
				{
					item = new HeroListItemView();
					
					addChild(item);
					
					m_items.push(item);
					
					item.x = posX;
					item.y = posY;
					
					m_group.addItem(item);
					
					posX += item.width + PaddingX;
				}
				
				posY += item.height + PaddingY;
			}
			
			
			m_pagingView = new PagingView();
			addChild(m_pagingView);
			
			m_pagingView.x = (width - m_pagingView.width) / 2;
			m_pagingView.y = height - m_pagingView.height - 8;
		}
		
		private function initEvent():void
		{
			// TODO Auto Generated method stub
			
			m_group.addEventListener(DisplayEvent.SELECT_CHANGED, __selectedChangedHandler);
			m_pagingView.addEventListener(UIEvent.PAGE_CHANGED, __pageChangedHandler);
		}
		
		private function __selectedChangedHandler(e:DisplayEvent):void
		{
			if(m_group.selected)
			{
				var item:HeroListItemView = HeroListItemView(m_group.selected);
				
				if(item.hero && item.hero != m_selectedHero)
				{
					m_selectedHero = item.hero;
				}
				
				dispatchEvent(new UIEvent(UIEvent.HERO_SELECTED_CHANGED, m_selectedHero));
			}
		}
		
		private function __pageChangedHandler(e:UIEvent):void
		{
			var list:Array = e.data4 as Array;
			
			clearItemsData();
			
			if(list == null) return;
			
			setItemsData(list);
		}
		
		public function beginChangeBackground():void
		{
			m_background.beginChanges();
		}
		
		public function commitChangeBackground():void
		{
			m_background.commitChanges();
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set width(value:Number):void
		{
			m_width = int(value);
			m_background.width = m_width;
		}
		
		override public function get height():Number
		{
			return m_height;
		}
		
		override public function set height(value:Number):void
		{
			m_height = int(m_height);
			m_background.height = m_height;
		}
		
		public function get pageSize():int
		{
			return m_row * m_column;
		}
		
		public function setData(heroMode:HeroMode):void
		{
			m_heroMode = heroMode;
			
			m_heroList = m_heroMode.getHeroListByType(m_heroType);
			
			ArrayUtil.sortDescByNum(m_heroList, "heroID");
			
			m_pagingView.setDataList(m_heroList);
			m_pagingView.setPagingData(pageSize, m_heroList.length);
		}
		
		public function clearItemsData():void
		{
			for each(var item:HeroListItemView in m_items)
			{
				item.clear();
			}
			
			m_group.selected = null;
		}
		
		public function setItemsData(list:Array):void
		{
			if(list == null) return;
			
			for(var i:int = 0; i < list.length; i++)
			{
				var item:HeroListItemView = m_items[i];
				
				item.setData(list[i]);
				
				if(list[i] == m_selectedHero)
				{
					m_group.selected = item;
				}
			}
		}
		
		public function setDefaultSelected():void
		{
			if(m_heroList && m_heroList.length > 0)
			{
				m_group.selectedIndex = 0;
			}
		}
		
		public function showPanel():void
		{
			m_group.selected = m_group.selected;
		}
		
		public function hidePanel():void
		{
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_group, m_freeBMD);
			m_group = null;
			
			DisposeUtil.free(m_background, m_freeBMD);
			m_background = null;
			
			DisposeUtil.free(m_items, m_freeBMD);
			m_items = null;
			
			DisposeUtil.free(m_pagingView, m_freeBMD);
			m_pagingView = null;
			
			m_heroMode = null;
			m_heroList = null;
			m_selectedHero = null;
			
			super.dispose();
		}
	}
}