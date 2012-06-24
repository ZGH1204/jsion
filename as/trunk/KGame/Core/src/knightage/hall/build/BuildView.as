package knightage.hall.build
{
	import flash.display.DisplayObject;
	
	import jsion.display.Button;
	import jsion.loaders.SwfLoader;
	import jsion.utils.DisposeUtil;
	
	import knightage.mgrs.PlayerMgr;
	import knightage.mgrs.TemplateMgr;
	import knightage.templates.BuildTemplate;
	
	public class BuildView extends Button
	{
		private var m_type:int;
		
		private var m_templateID:int;
		
		private var m_loader:SwfLoader;
		
		public function BuildView(type:int)
		{
			m_type = type;
			
			super();
		}
		
		override protected function configUI():void
		{
			stopMouseDownPropagation();
			
			switch(m_type)
			{
				case BuildType.Castle:
					m_templateID = PlayerMgr.self.castleTID;
					break;
				case BuildType.Framland:
					m_templateID = PlayerMgr.self.farmlandTID;
					break;
				case BuildType.Tavern:
					m_templateID = PlayerMgr.self.tavernTID;
					break;
				case BuildType.College:
					m_templateID = PlayerMgr.self.collegeTID;
					break;
				case BuildType.Barracks:
					m_templateID = PlayerMgr.self.barracksTID;
					break;
				case BuildType.Training:
					m_templateID = PlayerMgr.self.trainingTID;
					break;
				case BuildType.Market:
					m_templateID = PlayerMgr.self.marketTID;
					break;
				case BuildType.Prison:
					m_templateID = PlayerMgr.self.prisonTID;
					break;
				case BuildType.Divine:
					m_templateID = PlayerMgr.self.divineTID;
					break;
				case BuildType.Pandora:
					m_templateID = PlayerMgr.self.pandoraTID;
					break;
				case BuildType.Efigy:
					m_templateID = PlayerMgr.self.efigyTID;
					break;
				case BuildType.Smithy:
					m_templateID = PlayerMgr.self.smithyTID;
					break;
			}
			
			var template:BuildTemplate = TemplateMgr.findBuildTemplate(m_templateID);
			
			if(template == null) return;
			
			if(template.BuildType != m_type)
			{
				throw new Error("建筑类型不匹配");
				return;
			}
			
			m_loader = new SwfLoader(template.profileURL, Config.ResRoot);
			
			m_loader.loadAsync(loadCallback);
			
			clickSoundID = "008";
		}
		
		private function loadCallback(loader:SwfLoader, success:Boolean):void
		{
			// TODO Auto Generated method stub
			
			if(success)
			{
				upImage = m_loader.data as DisplayObject;
				
				ignoreTransparents = true;
			}
			
			var template:BuildTemplate = TemplateMgr.findBuildTemplate(m_templateID);
			x = template.PosX;
			y = template.PosY;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_loader);
			m_loader = null;
			
			super.dispose();
		}
	}
}