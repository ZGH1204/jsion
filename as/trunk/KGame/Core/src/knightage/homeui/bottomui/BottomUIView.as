package knightage.homeui.bottomui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.display.Button;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.VisitEvent;
	import knightage.mgrs.MsgTipMgr;
	import knightage.mgrs.VisitMgr;
	
	public class BottomUIView extends Sprite implements IDispose
	{
		private static const PADDING:int = 10;
		
		private static const OFFSETY:int = 18;
		
		private var m_background:Bitmap;
		
		private var m_heroButton:Button;
		
		private var m_expeditionButton:Button;
		
		private var m_embattleButton:Button;
		
		private var m_strengthenButton:Button;
		
		private var m_bagButton:Button;
		
		private var m_mallButton:Button;
		
		private var m_taskButton:Button;
		
		private var m_relationView:RelationView;
		
		public function BottomUIView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			m_background = new Bitmap(new BottomBackgroundAsset(0, 0));
			addChild(m_background);
			
			y = Config.GameHeight - m_background.height;
			
			m_heroButton = new Button();
			m_heroButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_heroButton.freeBMD = true;
			m_heroButton.upImage = new Bitmap(new HeroIcon(0, 0));
			m_heroButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_heroButton);
			
			m_expeditionButton = new Button();
			m_expeditionButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_expeditionButton.freeBMD = true;
			m_expeditionButton.upImage = new Bitmap(new ExpeditionIcon(0, 0));
			m_expeditionButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_expeditionButton);
			
			m_embattleButton = new Button();
			m_embattleButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_embattleButton.freeBMD = true;
			m_embattleButton.upImage = new Bitmap(new EmbattleIcon(0, 0));
			m_embattleButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_embattleButton);
			
			m_strengthenButton = new Button();
			m_strengthenButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_strengthenButton.freeBMD = true;
			m_strengthenButton.upImage = new Bitmap(new StrengthenIcon(0, 0));
			m_strengthenButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_strengthenButton);
			
			m_bagButton = new Button();
			m_bagButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_bagButton.freeBMD = true;
			m_bagButton.upImage = new Bitmap(new BagIcon(0, 0));
			m_bagButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_bagButton);
			
			m_mallButton = new Button();
			m_mallButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_mallButton.freeBMD = true;
			m_mallButton.upImage = new Bitmap(new MallIcon(0, 0));
			m_mallButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_mallButton);
			
			m_taskButton = new Button();
			m_taskButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_taskButton.freeBMD = true;
			m_taskButton.upImage = new Bitmap(new TaskIcon(0, 0));
			m_taskButton.addEventListener(MouseEvent.CLICK, __clickHandler);
			addChild(m_taskButton);
			
			
			
			
			
			
			
			m_heroButton.x = 315;
			m_heroButton.y = OFFSETY - m_heroButton.height;
			
			m_expeditionButton.x = m_heroButton.x + m_heroButton.width + PADDING;
			m_expeditionButton.y = OFFSETY - m_expeditionButton.height;
			
			m_embattleButton.x = m_expeditionButton.x + m_expeditionButton.width + PADDING;
			m_embattleButton.y = OFFSETY - m_embattleButton.height;
			
			m_strengthenButton.x = m_embattleButton.x + m_embattleButton.width + PADDING;
			m_strengthenButton.y = OFFSETY - m_strengthenButton.height;
			
			m_bagButton.x = m_strengthenButton.x + m_strengthenButton.width + PADDING;
			m_bagButton.y = OFFSETY - m_bagButton.height;
			
			m_mallButton.x = m_bagButton.x + m_bagButton.width + PADDING;
			m_mallButton.y = OFFSETY - m_mallButton.height;
			
			m_taskButton.x = m_mallButton.x + m_mallButton.width + PADDING;
			m_taskButton.y = OFFSETY - m_taskButton.height;
			
			
			
			
			
			m_relationView = new RelationView();
			m_relationView.y = 18;
			addChild(m_relationView);
			
			
			
			
			VisitMgr.addEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
		}
		
		private function __visitFriendHandler(e:VisitEvent):void
		{
			// TODO Auto Generated method stub
			
			var rlt:Boolean = VisitMgr.isSelf;
			
			m_heroButton.visible = rlt;
			m_expeditionButton.visible = rlt;
			m_embattleButton.visible = rlt;
			m_strengthenButton.visible = rlt;
			m_bagButton.visible = rlt;
			m_mallButton.visible = rlt;
			m_taskButton.visible = rlt;
			m_relationView.visible = rlt;
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			var btnName:String = "";
			
			switch(e.currentTarget)
			{
				case m_heroButton:
					btnName = "英雄";
					break;
				case m_expeditionButton:
					btnName = "出征";
					break;
				case m_embattleButton:
					btnName = "布阵";
					break;
				case m_strengthenButton:
					btnName = "强化";
					break;
				case m_bagButton:
					btnName = "背包";
					break;
				case m_mallButton:
					btnName = "商城";
					break;
				case m_taskButton:
					btnName = "任务";
					break;
			}
			
			MsgTipMgr.show(btnName + "功能开发中...");
		}
		
		public function dispose():void
		{
			VisitMgr.removeEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
			
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_heroButton);
			m_heroButton = null;
			
			DisposeUtil.free(m_expeditionButton);
			m_expeditionButton = null;
			
			DisposeUtil.free(m_embattleButton);
			m_embattleButton = null;
			
			DisposeUtil.free(m_strengthenButton);
			m_strengthenButton = null;
			
			DisposeUtil.free(m_bagButton);
			m_bagButton = null;
			
			DisposeUtil.free(m_mallButton);
			m_mallButton = null;
			
			DisposeUtil.free(m_taskButton);
			m_taskButton = null;
			
			DisposeUtil.free(m_relationView);
			m_relationView = null;
		}
	}
}