package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.ddrop.IDragDrop;
	import jsion.display.IconButton;
	
	import knightage.StaticRes;
	import knightage.player.goods.EquipType;
	
	public class EquipItem extends IconButton implements IDragDrop
	{
		private var m_background:Sprite;
		
		private var m_itemBg:DisplayObject;
		
		private var m_wenZi:DisplayObject;
		
		private var m_type:int;
		
		public function EquipItem(type:int)
		{
			m_type = type;
			
			super();
		}
		
		override protected function configUI():void
		{
			m_background = new Sprite();
			
			m_itemBg = new Bitmap(StaticRes.EquipItemBackgroundBMD);
			m_background.addChild(m_itemBg);
			
			switch(m_type)
			{
				case EquipType.Weapon:
					m_wenZi = new Bitmap(new WenZiWuQiAsset(0, 0));
					break;
				case EquipType.Armor:
					m_wenZi = new Bitmap(new WenZiFangJuAsset(0, 0));
					break;
				case EquipType.Cloak:
					m_wenZi = new Bitmap(new WenZiPiFengAsset(0, 0));
					break;
				case EquipType.Mount:
					m_wenZi = new Bitmap(new WenZiZuoJiAsset(0, 0));
					break;
			}
			
			if(m_wenZi)
			{
				m_background.addChild(m_wenZi);
				m_itemBg.y = m_wenZi.height / 2;
				
				m_wenZi.x = (m_itemBg.width - m_wenZi.width) / 2;
			}
			
			
			
			beginChanges();
			upImage = m_background;
			commitChanges();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function get isClickDrag():Boolean
		{
			return false;
		}
		
		public function get lockCenter():Boolean
		{
			return false;
		}
		
		public function set lockCenter(value:Boolean):void
		{
		}
		
		public function get transData():*
		{
			return null;
		}
		
		public function get reviseInStage():Boolean
		{
			return false;
		}
		
		public function get freeDragingIcon():Boolean
		{
			return false;
		}
		
		public function get dragingIcon():DisplayObject
		{
			return null;
		}
		
		public function groupDragCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function groupDropCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		public function startDragCallback():void
		{
		}
		
		public function dragingCallback():void
		{
		}
		
		public function dropCallback():void
		{
		}
		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
	}
}