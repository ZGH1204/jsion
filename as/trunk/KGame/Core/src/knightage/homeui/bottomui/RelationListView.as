package knightage.homeui.bottomui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.display.Button;
	
	public class RelationListView extends Sprite implements IDispose
	{
		private static const ListItemPadding:int = 1;
		
		private static const ArrowOffsetY:int = 15;
		
		private static const ArrowPadding:int = 8;
		
		private var m_leftButton:Button;
		
		private var m_lastLeftButton:Button;
		
		private var m_rightButton:Button;
		
		private var m_lastRightButton:Button;
		
		private var m_inviteButton:Button;
		
		private var m_items:Array;
		private var m_buttons:Array;
		
		public function RelationListView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			
			m_leftButton = new Button();
			m_leftButton.freeBMD = true;
			m_leftButton.upImage = new Bitmap(new RelationRightArrowAsset(0, 0));
			m_leftButton.x = 0;
			m_leftButton.y = ArrowOffsetY;
			addChild(m_leftButton);
			
			m_lastLeftButton = new Button();
			m_lastLeftButton.freeBMD = true;
			m_lastLeftButton.upImage = new Bitmap(new RelationLastRightArrowAsset(0, 0));
			m_lastLeftButton.x = m_leftButton.x;
			m_lastLeftButton.y = m_leftButton.y + m_leftButton.height + ArrowPadding;
			addChild(m_lastLeftButton);
			
			
			m_items = [];
			m_buttons = [];
			
			var posX:int = m_leftButton.x + m_leftButton.width;
			
			var button:Button;
			var item:RelationListItemView;
			for(var i:int = 0; i < 6; i++)
			{
				item = new RelationListItemView();
				button = new Button();
				button.upImage = item;
				
				m_items.push(item);
				m_buttons.push(button);
				
				button.x = posX + i * ListItemPadding;
				
				addChild(button);
				
				posX += button.width;
			}
			
			m_rightButton = new Button();
			m_rightButton.freeBMD = true;
			m_rightButton.upImage = new Bitmap(new RelationLeftArrowAsset(0, 0));
			m_rightButton.x = button.x + button.width;
			m_rightButton.y = ArrowOffsetY;
			addChild(m_rightButton);
			
			m_lastRightButton = new Button();
			m_lastRightButton.freeBMD = true;
			m_lastRightButton.upImage = new Bitmap(new RelationLastLeftArrowAsset(0, 0));
			m_lastRightButton.x = m_rightButton.x;
			m_lastRightButton.y = m_rightButton.y + m_rightButton.height + ArrowPadding;
			addChild(m_lastRightButton);
			
			m_inviteButton = new Button();
			m_inviteButton.freeBMD = true;
			m_inviteButton.upImage = new Bitmap(new InviteFriendButtonUpAsset(0, 0));
			m_inviteButton.x = m_rightButton.x + m_rightButton.width;
			m_inviteButton.y = 3;
			addChild(m_inviteButton);
		}
		
		public function dispose():void
		{
		}
	}
}