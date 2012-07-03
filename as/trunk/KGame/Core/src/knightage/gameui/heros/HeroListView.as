package knightage.gameui.heros
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.comps.JsionSprite;
	import jsion.comps.ToggleGroup;
	import jsion.display.ITabPanel;
	import jsion.display.Image;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	
	import knightage.StaticRes;
	import knightage.gameui.PagingView;
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
		
		public function HeroListView(row:int = 3, column:int = 4)
		{
			m_row = row;
			
			m_column = column;
			
			super();
			
			initialized();
			
			initEvent();
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
			
			super.dispose();
		}
	}
}