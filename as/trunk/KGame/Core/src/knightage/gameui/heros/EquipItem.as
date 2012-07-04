package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.ddrop.DDropMgr;
	import jsion.ddrop.IDragDrop;
	import jsion.display.IconButton;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.player.goods.EquipType;
	
	public class EquipItem extends Sprite implements IDragDrop, IDispose//IconButton implements IDragDrop
	{
		private var m_background:Sprite;
		
		private var m_itemBg:DisplayObject;
		
		private var m_wenZi:DisplayObject;
		
		private var m_type:int;
		
		private var m_equipIcon:DisplayObject;
		
		public function EquipItem(type:int)
		{
			m_type = type;
			
			super();
			
			configUI();
		}
		
		protected function configUI():void
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
			
			
			addChild(m_background);
//			beginChanges();
//			upImage = m_background;
//			commitChanges();
			
			
			DDropMgr.registeDrag(this);
		}
		
		
		public function dispose():void
		{
			DDropMgr.unregisteDrag(this);
			
			DisposeUtil.free(m_wenZi);
			m_wenZi = null;
			
			DisposeUtil.free(m_itemBg, false);
			m_itemBg = null;
			
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_equipIcon);
			m_equipIcon = null;
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
			return true;
		}
		
		public function get dragingIcon():DisplayObject
		{
			if(m_equipIcon)
			{
				var bmp:Bitmap = new Bitmap(new BitmapData(m_equipIcon.width, m_equipIcon.height, true, 0x0));
				
				bmp.bitmapData.draw(m_equipIcon);
				
				bmp.x = m_equipIcon.x;
				bmp.y = m_equipIcon.y;
				
				return bmp;
			}
			return null;;
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