package knightage.hall.build
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jsion.display.Button;
	import jsion.loaders.BitmapDataLoader;
	import jsion.utils.DisposeUtil;
	
	import knightage.GameUtil;
	import knightage.StaticRes;
	import knightage.player.GamePlayer;
	import knightage.templates.BuildTemplate;
	
	public class BuildView extends Button
	{
		private var m_type:int;
		
		private var m_templateID:int;
		
		private var m_imgFile:String;
		
		private var m_loader:BitmapDataLoader;
		
		private var m_player:GamePlayer;
		
		public function BuildView(gp:GamePlayer, type:int)
		{
			m_player = gp;
			
			m_type = type;
			
			super();
		}
		
		public function get buildType():int
		{
			return m_type;
		}

		override protected function configUI():void
		{
			stopMouseDownPropagation();
			
			freeBMD = true;
			
			clickSoundID = StaticRes.ButtonClickSoundID;
			
			loadBuildRes();
		}
		
		public function loadBuildRes():void
		{
			var template:BuildTemplate = GameUtil.getBuildTemplate(m_player, m_type);
			
			if(template == null)
			{
				//throw new Error("找不到对应的建筑模板");
				return;
			}
			
			if(template.BuildType != m_type)
			{
				throw new Error("建筑类型不匹配");
				return;
			}
			
			if(m_imgFile == template.profileURL) return;
			
			m_imgFile = template.profileURL;
			
			DisposeUtil.free(m_loader);
			
			m_loader = new BitmapDataLoader(template.profileURL, Config.ResRoot);
			
			m_loader.loadAsync(loadCallback);
		}
		
		private function loadCallback(loader:BitmapDataLoader, success:Boolean):void
		{
			// TODO Auto Generated method stub
			
			if(success)
			{
				upImage = new Bitmap(m_loader.data as BitmapData);
				
				ignoreTransparents = true;
			}
			
			x = -int(width / 2);
			y = -int(height);
			
			DisposeUtil.free(m_loader);
			m_loader = null;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_loader);
			m_loader = null;
			
			m_player = null;
			
			super.dispose();
		}
	}
}