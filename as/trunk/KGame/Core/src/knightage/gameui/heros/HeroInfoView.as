package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	
	import jsion.IDispose;
	import jsion.display.Image;
	import jsion.display.Label;
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.BlueButton;
	import knightage.display.KhakiButton;
	import knightage.display.RedButton;
	import knightage.homeui.LevelView;
	import knightage.mgrs.MsgTipMgr;
	import knightage.player.goods.EquipType;
	import knightage.player.heros.PlayerHero;
	
	public class HeroInfoView extends Sprite implements IDispose
	{
		private var m_heroBustView:HeroBustView;
		
		private var m_weaponItem:EquipItem;
		
		private var m_armorItem:EquipItem;
		
		
		private var m_cloakItem:EquipItem;
		
		private var m_mountItem:EquipItem;
		
		
		
		
		private var m_tabEquipButton:KhakiButton;
		
		private var m_cultivateButton:BlueButton;
		
		private var m_fireButton:RedButton;
		
		
		private var m_hero:PlayerHero;
		
		public function HeroInfoView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_heroBustView = new HeroBustView();
			addChild(m_heroBustView);
			
			m_weaponItem = new EquipItem(EquipType.Weapon);
			addChild(m_weaponItem);
			
			
			m_armorItem = new EquipItem(EquipType.Armor);
			addChild(m_armorItem);
			
			m_cloakItem = new EquipItem(EquipType.Cloak);
			addChild(m_cloakItem);
			
			m_mountItem = new EquipItem(EquipType.Mount);
			addChild(m_mountItem);
			
			
			
			m_tabEquipButton = new KhakiButton("更换装备");
			m_tabEquipButton.beginChanges();
			m_tabEquipButton.embedFonts = true;
			m_tabEquipButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_tabEquipButton.labelUpFilters = StaticRes.TextFilters8;
			m_tabEquipButton.labelOverFilters = StaticRes.TextFilters8;
			m_tabEquipButton.labelDownFilters = StaticRes.TextFilters8;
			m_tabEquipButton.vOffset = -2;
			m_tabEquipButton.width = 120;
			m_tabEquipButton.height = 46;
			m_tabEquipButton.commitChanges();
			addChild(m_tabEquipButton);
			
			
			
			
			m_cultivateButton = new BlueButton("培养");
			m_cultivateButton.beginChanges();
			m_cultivateButton.embedFonts = true;
			m_cultivateButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_cultivateButton.labelUpFilters = StaticRes.TextFilters8;
			m_cultivateButton.labelOverFilters = StaticRes.TextFilters8;
			m_cultivateButton.labelDownFilters = StaticRes.TextFilters8;
			m_cultivateButton.vOffset = -2;
			m_cultivateButton.width = 85;
			m_cultivateButton.height = 46;
			m_cultivateButton.commitChanges();
			addChild(m_cultivateButton);
			
			
			
			m_fireButton = new RedButton("解雇");
			m_fireButton.beginChanges();
			m_fireButton.embedFonts = true;
			m_fireButton.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_fireButton.labelUpFilters = StaticRes.TextFilters8;
			m_fireButton.labelOverFilters = StaticRes.TextFilters8;
			m_fireButton.labelDownFilters = StaticRes.TextFilters8;
			m_fireButton.vOffset = -2;
			m_fireButton.width = 85;
			m_fireButton.height = 46;
			m_fireButton.commitChanges();
			addChild(m_fireButton);
			
			
			
			
			
			
			m_weaponItem.x = 0;
			m_weaponItem.y = 25;
			
			m_armorItem.x = m_weaponItem.x;
			m_armorItem.y = m_weaponItem.y + m_weaponItem.height + 2;
			
			m_cloakItem.x = m_weaponItem.x + m_weaponItem.width + 144;
			m_cloakItem.y = m_weaponItem.y;
			
			m_mountItem.x = m_cloakItem.x;
			m_mountItem.y = m_armorItem.y;
			
			
			m_tabEquipButton.x = 2;
			m_tabEquipButton.y = m_heroBustView.y + m_heroBustView.height + 5;
			
			m_cultivateButton.x = m_tabEquipButton.x + m_tabEquipButton.width + 6;
			m_cultivateButton.y = m_tabEquipButton.y;
			
			m_fireButton.x = m_cultivateButton.x + m_cultivateButton.width + 6;
			m_fireButton.y = m_cultivateButton.y;
			
			
			
			
			m_tabEquipButton.addEventListener(MouseEvent.CLICK, __tabEquipClickHandler);
			m_cultivateButton.addEventListener(MouseEvent.CLICK, __cultivateClickHandler);
			m_fireButton.addEventListener(MouseEvent.CLICK, __fireClickHandler);
		}
		
		private function __tabEquipClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("更换装备功能开发中...");
		}
		
		private function __cultivateClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("培养功能开发中...");
		}
		
		private function __fireClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("解雇功能开发中...");
		}
		
		public function setData(hero:PlayerHero):void
		{
			if(m_hero != hero)
			{
				m_hero = hero;
				
				refreshView(m_hero);
			}
		}
		
		private function refreshView(hero:PlayerHero):void
		{
			m_heroBustView.setData(hero);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_tabEquipButton);
			m_tabEquipButton = null;
			
			DisposeUtil.free(m_cultivateButton);
			m_cultivateButton = null;
			
			DisposeUtil.free(m_fireButton);
			m_fireButton = null;
			
			DisposeUtil.freeChildren(this);
			
			m_hero = null;
		}
	}
}