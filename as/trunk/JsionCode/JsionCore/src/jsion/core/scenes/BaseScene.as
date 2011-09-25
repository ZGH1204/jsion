package jsion.core.scenes
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class BaseScene extends Sprite implements IDispose
	{
		public function BaseScene()
		{
		}
		
		protected var m_prepared:Boolean;
		
		public function get prepared():Boolean
		{
			return m_prepared;
		}
		
		public function prepare():void
		{
			m_prepared = true;
		}
		
		public function check(sceneType:String):Boolean
		{
			return true;
		}
		
		public function enter(preScene:BaseScene, data:Object = null):void
		{
		}
		
		public function leaving(nextScene:BaseScene):void
		{
		}
		
		public function getView():DisplayObject
		{
			return this;
		}
		
		public function getSceneType():String
		{
			return SceneType.DEFAULT;
		}
		
		public function goBack():Boolean
		{
			return false;
		}
		
		public function getBackType():String
		{
			return null;
		}
		
		public function onAddedToStage():void
		{
		}
		
		public function onRemovedFromStage():void
		{
		}
		
		public function onFadingComplete():void
		{
		}
		
		public function dispose():void
		{
		}
	}
}