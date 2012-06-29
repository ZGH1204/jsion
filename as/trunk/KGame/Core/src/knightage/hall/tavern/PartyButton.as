package knightage.hall.tavern
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	
	import jsion.display.IconLabelButton;
	import jsion.display.Image;
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.KhakiButton;
	
	public class PartyButton extends IconLabelButton
	{
		public static const Party:int = 1;
		
		public static const GrandParty:int = 2;
		
		public static const PartyButtonWidth:int = 110;
		public static const PartyButtonHeight:int = 70;
		
		private var m_type:int;
		
		private var m_iconContainer:Sprite;
		
		private var m_moneyIcon:DisplayObject;
		
		private var m_moneyLabel:Label;
		
		public function PartyButton(type:int)
		{
			m_type = type;
			
			super();
		}
		
		override protected function configUI():void
		{
			var img:Image = new Image();
			
			img.beginChanges();
			img.freeSource = false;
			img.source = KhakiButton.UpImageBMD;
			img.scale9Insets = KhakiButton.ScaleInsets;
			img.commitChanges();
			
			
			
			m_iconContainer = new Sprite();
			
			
			m_moneyLabel = new Label();
			m_moneyLabel.beginChanges();
			m_moneyLabel.width = 65;
			m_moneyLabel.text = "30";
			m_moneyLabel.embedFonts = true;
			m_moneyLabel.textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			m_moneyLabel.commitChanges();
			
			if(m_type == Party)
			{
				m_moneyIcon = new Bitmap(StaticRes.CoinsIcon);
			}
			else
				
			{
				m_moneyIcon = new Bitmap(StaticRes.GoldsIcon);
			}
			
			m_iconContainer.graphics.clear();
			m_iconContainer.graphics.beginFill(0x0, 0);
			m_iconContainer.graphics.drawRect(0, 0, 104, m_moneyIcon.height);
			m_iconContainer.graphics.endFill();
			
			m_iconContainer.addChild(m_moneyLabel);
			m_iconContainer.addChild(m_moneyIcon);
			
			m_moneyLabel.x = m_moneyIcon.x + m_moneyIcon.width;
			m_moneyLabel.y = 10;
			
			
			
			beginChanges();
			frozen = true;
			frozenFrames = 60;
			clickSoundID = StaticRes.ButtonClickSoundID;
			width = PartyButtonWidth;
			height = PartyButtonHeight;
			upImage = img;
			embedFonts = true;
			label = m_type == Party ? "举行派对" : "豪华派对";
			antiAliasType = AntiAliasType.ADVANCED;
			thickness = 200;
			sharpness = 100;
			labelColor = StaticRes.WhiteColor;
			textFormat = StaticRes.WaWaEmbedTextFormat22;
			labelUpFilters = StaticRes.TextFilters8;
			labelOverFilters = StaticRes.TextFilters8;
			labelDownFilters = StaticRes.TextFilters8;
			
			iconDir = TOP;
			iconUpImage = m_iconContainer;
			hAlign = CENTER;
			
			vOffset = -8;
			
			commitChanges();
		}
		
		public function setMoney(value:int):void
		{
			m_moneyLabel.text = value.toString();
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_iconContainer);
			m_iconContainer = null;
			
			DisposeUtil.free(m_moneyIcon, false);
			m_moneyIcon = null;
			
			DisposeUtil.free(m_moneyLabel);
			m_moneyLabel = null;
			
			super.dispose();
		}
	}
}