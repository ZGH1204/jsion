package jsion.scenes
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;

	/**
	 * 场景基类
	 * @author Jsion
	 */	
	public class BaseScene extends Sprite implements IDispose
	{
		public function BaseScene()
		{
		}
		
		/** @private */
		protected var m_prepared:Boolean;
		
		/**
		 * 指示场景是否已准备
		 */		
		public function get prepared():Boolean
		{
			return m_prepared;
		}
		
		/**
		 * 准备场景
		 */		
		public function prepare():void
		{
			m_prepared = true;
		}
		
		/**
		 * 检查场景是否可进入
		 * @param sceneType 场景类型
		 */		
		public function check(sceneType:String):Boolean
		{
			return true;
		}
		
		/**
		 * 进入场景
		 * @param preScene 上一个场景对象
		 * @param data 场景数据
		 * 
		 */		
		public function enter(preScene:BaseScene, data:Object = null):void
		{
		}
		
		/**
		 * 离开场景
		 * @param nextScene 下一个场景对象
		 * 
		 */		
		public function leaving(nextScene:BaseScene):void
		{
		}
		
		/**
		 * 获取场景视图
		 */		
		public function getView():DisplayObject
		{
			return this;
		}
		
		/**
		 * 获取当前场景的场景类型
		 */		
		public function getSceneType():String
		{
			return SceneType.DEFAULT;
		}
		
		/**
		 * 指示是否返回上一个场景
		 */		
		public function goBack():Boolean
		{
			return false;
		}
		
		/**
		 * 返回的场景类型
		 */		
		public function getBackType():String
		{
			return null;
		}
		
		/**
		 * 场景被添加到舞台时被调用
		 */		
		public function onAddedToStage():void
		{
		}
		
		/**
		 * 场景从舞台上移除时被调用
		 */		
		public function onRemovedFromStage():void
		{
		}
		
		/**
		 * 场景过渡动画完成时被调用(仅当前场景,上一个场景此时不调用.)
		 */		
		public function onFadingComplete():void
		{
		}
		
		/**
		 * 释放场景内存
		 */		
		public function dispose():void
		{
		}
	}
}