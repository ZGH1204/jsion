package knightage.homeui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	
	public class LevelView extends Sprite implements IDispose
	{
		public static const TOP:int = 1;
		
		public static const BOTTOM:int = 2;
		
		private var m_levelBackground:DisplayObject;
		
		private var m_levelLabel:Label;
		
		private var m_type:int;
		
		private var m_lv:int;
		
		public function LevelView(lv:int, type:int = TOP)
		{
			m_lv = lv;
			
			m_type = type;
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			m_levelBackground = new Bitmap(StaticRes.LvIcon);
			addChild(m_levelBackground);
			
			m_levelLabel = new Label();
			m_levelLabel.beginChanges();
			setLevel(m_lv);
			if(m_type == TOP)
			{
				m_levelLabel.filters = StaticRes.TextFilters4;
				m_levelLabel.textColor = StaticRes.WhiteColor;
				m_levelLabel.textFormat = StaticRes.TextFormat15;
			}
			else
			{
				m_levelLabel.filters = StaticRes.TextFilters4;
				m_levelLabel.textColor = StaticRes.WhiteColor;
				m_levelLabel.textFormat = StaticRes.TextFormat15;
			}
			m_levelLabel.commitChanges();
			addChild(m_levelLabel);
			
			refreshLvLabelPos();
		}
		
		public function setLevel(value:int):void
		{
			m_lv = value;
			
			m_levelLabel.text = m_lv.toString();
			
			refreshLvLabelPos();
		}
		
		private function refreshLvLabelPos():void
		{
			m_levelLabel.x = m_levelBackground.x + (m_levelBackground.width - m_levelLabel.width) / 2;
			m_levelLabel.y = m_levelBackground.y + (m_levelBackground.height - m_levelLabel.height) / 2 - 4;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_levelBackground, false);
			m_levelBackground = null;
			
			DisposeUtil.free(m_levelLabel, false);
			m_levelLabel = null;
		}
	}
}