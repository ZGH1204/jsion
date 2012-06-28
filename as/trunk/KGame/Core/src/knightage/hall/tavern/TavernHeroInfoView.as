package knightage.hall.tavern
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	
	import jsion.IDispose;
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	import jsion.utils.ScaleUtil;
	
	import knightage.GameUtil;
	import knightage.StaticRes;
	import knightage.display.KhakiButton;
	import knightage.mgrs.MsgTipMgr;
	import knightage.templates.HeroTemplate;
	import knightage.templates.SoilderTemplate;
	
	public class TavernHeroInfoView extends Sprite implements IDispose
	{
		private var m_background:DisplayObject;
		
		private var m_heroNameLabel:Label;
		
		private var m_attackLabel:Label;
		
		private var m_defenseLabel:Label;
		
		private var m_critLabel:Label;
		
		
		private var m_soliderTypeLabel:Label;
		
		private var m_coinIcon:DisplayObject;
		
		private var m_coinLabel:Label;
		
		
		private var m_employButton:KhakiButton;
		
		private var m_template:HeroTemplate;
		
		private var m_index:int;
		
		public function TavernHeroInfoView(index:int)
		{
			m_index = index;
			
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_background = new Bitmap(StaticRes.TavernHeroInfoBackgroundBMD);
			addChild(m_background);
			
			m_heroNameLabel = new Label();
			m_heroNameLabel.beginChanges();
			m_heroNameLabel.x = 26;
			m_heroNameLabel.text = "";
			m_heroNameLabel.textColor = StaticRes.WhiteColor;
			m_heroNameLabel.textFormat = StaticRes.TextFormat14;
			m_heroNameLabel.filters = StaticRes.TextFilters4;
			m_heroNameLabel.width = 150;
			m_heroNameLabel.height = 35;
			m_heroNameLabel.commitChanges();
			addChild(m_heroNameLabel);
			
			var posY:int = 40;
			
			
			m_attackLabel = new Label();
			m_attackLabel.beginChanges();
			m_attackLabel.x = 35;
			m_attackLabel.y = posY;
			m_attackLabel.text = "0";
			m_attackLabel.width = 35;
			m_attackLabel.textFormat = StaticRes.TextFormat14;
			m_attackLabel.commitChanges();
			addChild(m_attackLabel);
			
			
			m_defenseLabel = new Label();
			m_defenseLabel.beginChanges();
			m_defenseLabel.x = 95;
			m_defenseLabel.y = posY;
			m_defenseLabel.text = "0";
			m_defenseLabel.width = 35;
			m_defenseLabel.textFormat = StaticRes.TextFormat14;
			m_defenseLabel.commitChanges();
			addChild(m_defenseLabel);
			
			
			m_critLabel = new Label();
			m_critLabel.beginChanges();
			m_critLabel.x = 157;
			m_critLabel.y = posY;
			m_critLabel.text = "0";
			m_critLabel.width = 35;
			m_critLabel.textFormat = StaticRes.TextFormat14;
			m_critLabel.commitChanges();
			addChild(m_critLabel);
			
			
			
			
			
			m_soliderTypeLabel = new Label();
			m_soliderTypeLabel.beginChanges();
			m_soliderTypeLabel.x = 20;
			m_soliderTypeLabel.y = 72;
			m_soliderTypeLabel.width = 80;
			m_soliderTypeLabel.text = "";
			m_soliderTypeLabel.textColor = 0xC79A47;
			m_soliderTypeLabel.textFormat = StaticRes.TextFormat14;
			m_soliderTypeLabel.filters = StaticRes.TextFilters4;
			m_soliderTypeLabel.commitChanges();
			addChild(m_soliderTypeLabel);
			
			
			
			
			
			m_coinLabel = new Label();
			m_coinLabel.beginChanges();
			m_coinLabel.x = 115;
			m_coinLabel.y = 72;
			m_coinLabel.width = 60;
			m_coinLabel.text = "0";
			m_coinLabel.textColor = 0xC79A47;
			m_coinLabel.textFormat = StaticRes.TextFormat14;
			m_coinLabel.filters = StaticRes.TextFilters4;
			m_coinLabel.commitChanges();
			addChild(m_coinLabel);
			
			
			
			
			m_coinIcon = new Bitmap(StaticRes.CoinsIcon, PixelSnapping.AUTO, true);
			var multi:Number = ScaleUtil.calcScaleFullSize(StaticRes.CoinsIcon.width, StaticRes.CoinsIcon.height, 31, 29);
			m_coinIcon.x = 95;
			m_coinIcon.y = 69;
			m_coinIcon.scaleX = multi;
			m_coinIcon.scaleY = multi;
			addChild(m_coinIcon);
			
			
			
			
			
			m_employButton = new KhakiButton("雇 佣");
			m_employButton.beginChanges();
			m_employButton.enabled = false;
			m_employButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_employButton.x = int((width - m_employButton.width) / 2);
			m_employButton.y = 102;
			m_employButton.height = 42;
			m_employButton.vOffset = -1;
			m_employButton.embedFonts = true;
			m_employButton.antiAliasType = AntiAliasType.ADVANCED;
			m_employButton.thickness = 200;
			m_employButton.sharpness = 100;
			m_employButton.textFormat = StaticRes.WaWaEmbedTextFormat22;
			m_employButton.labelUpFilters = StaticRes.TextFilters8;
			m_employButton.labelOverFilters = StaticRes.TextFilters8;
			m_employButton.labelDownFilters = StaticRes.TextFilters8;
			m_employButton.commitChanges();
			addChild(m_employButton);
			
			
			
			
			
			
			
			
			m_employButton.addEventListener(MouseEvent.CLICK, __employClickHandler);
		}
		
		private function __employClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("雇佣英雄开发中...");
		}
		
		
		
		public function setData(template:HeroTemplate):void
		{
			if(m_template != template)
			{
				m_template = template;
				
				refreshView(m_template);
			}
		}
		
		private function refreshView(template:HeroTemplate):void
		{
			if(template)
			{
				m_heroNameLabel.text = template.TemplateName;
				m_attackLabel.text = template.BasicAttack.toString();
				m_defenseLabel.text = template.BasicDefense.toString();
				m_critLabel.text = template.BasicCrit.toString();
				m_coinLabel.text = template.EmployPrice.toString();
				
				var solider:SoilderTemplate = GameUtil.getDefaultSoilderTemplateByCategory(template.SoliderCategory);
				m_soliderTypeLabel.text = solider.TemplateName;
				
				m_employButton.enabled = true;
			}
			else
			{
				m_heroNameLabel.text = "";
				m_attackLabel.text = "0";
				m_defenseLabel.text = "0";
				m_critLabel.text = "0";
				m_coinLabel.text = "0";
				
				m_employButton.enabled = false;
			}
		}
		
		
		
		public function dispose():void
		{
			DisposeUtil.free(m_background, false);
			m_background = null;
		}
	}
}