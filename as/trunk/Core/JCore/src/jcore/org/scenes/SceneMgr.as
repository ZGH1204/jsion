package jcore.org.scenes
{
	import flash.utils.Dictionary;

	public class SceneMgr
	{
		private static var m_sceneList:Dictionary;
		
		private static var m_fading:IFading;
		private static var m_creator:ISceneCreator;
		
		private static var m_data:Object;
		private static var m_nextScene:BaseScene;
		
		private static var m_current:BaseScene;
		private static var m_currentType:String;
		
		public static function get currentType():String
		{
			return m_currentType;
		}
		
		public function SceneMgr()
		{
		}
		
		public static function setup(creator:ISceneCreator, fading:IFading = null):void
		{
			m_creator = creator;
			m_fading = fading == null ? new DefaultFading() : fading;
		}
		
		public static function setScene(type:String, data:Object = null):void
		{
			var next:BaseScene = getScene(type);
			
			m_data = data;
			
			if(next)
			{
				setSceneImp(next);
			}
			else
			{
				createSceneAsync(type);
			}
		}
		
		private static function createSceneAsync(type:String):void
		{
			var scene:BaseScene = m_creator.create(type);
			
			if(scene != null)
			{
				setSceneImp(scene);
			}
			else
			{
				m_creator.createAsync(type, setSceneImp);
			}
		}
		
		private static function setSceneImp(scene:BaseScene):void
		{
			if(scene == null || scene == m_current || scene == m_nextScene) return;
			
			var t:String = scene.getSceneType();
			
			if(m_sceneList[t] == null) m_sceneList[t] = scene;
			
			if(scene.check(m_currentType))
			{
				m_nextScene = scene;
				
				if(m_nextScene.prepared == false)
				{
					m_nextScene.prepare();
				}
				
				m_fading.setFading(addNextSceneToStage);
			}
		}
		
		private static function addNextSceneToStage():void
		{
			if(m_current)
			{
				m_current.living(m_nextScene);
			}
		}
		
		private static function getScene(type:String):BaseScene
		{
			return m_sceneList[type] as BaseScene;
		}
	}
}