package jsion.core.scenes
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	public class SceneMgr
	{
		private static var m_scenesLayer:Sprite;
		
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
		
		public static function setup(root:DisplayObjectContainer, creator:ISceneCreator, fading:IFading = null):void
		{
			if(m_sceneList) return;
			
			m_scenesLayer = new Sprite();
			root.addChild(m_scenesLayer);
			m_sceneList = new Dictionary();
			
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
		
		public static function back():void
		{
			if(m_current)
			{
				var t:String = m_current.getBackType();
				
				if(StringUtil.isNotNullOrEmpty(t))
				{
					setScene(t);
				}
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
				m_current.leaving(m_nextScene);
				
				if(m_current.parent)
				{
					m_scenesLayer.removeChild(m_current);
					//LayerMgr.removeView(m_current);
					
					m_current.onRemovedFromStage();
				}
			}
			
			m_nextScene.enter(m_current, m_data);
			
			m_scenesLayer.addChild(m_nextScene.getView());
			//LayerMgr.addView(m_nextScene.getView());
			
			m_nextScene.onAddedToStage();
			
			m_current = m_nextScene;
			m_currentType = m_nextScene.getSceneType();
			
			m_nextScene = null;
			
			if(m_current.goBack())
			{
				back();
			}
			else
			{
				GC.collect();
			}
		}
		
		private static function getScene(type:String):BaseScene
		{
			return m_sceneList[type] as BaseScene;
		}
	}
}