package jsion.rpg.engine.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.gameobjects.GameObject;
	import jsion.rpg.engine.games.BaseGame;

	public class Render
	{
		/**
		 * 引用成像区位图数据
		 */		
		public var buffer:BitmapData;
		
		/**
		 * 上一次渲染的屏幕位置
		 */		
		protected var lastPoint:Point = new Point();
		
		/**
		 * 当前要渲染的屏幕位置
		 */		
		protected var renderPoint:Point = new Point();
		
		/**
		 * 脏矩形范围,即要擦除的矩形区域,擦除时使用lastPoint设置范围位置,drawClear方法中的objRenderRect参数设置范围大小
		 */		
		protected var dirtyRect:Rectangle = new Rectangle();
		
		public function Render()
		{
		}
		
		protected function updateRenderPoint(object:GameObject):void
		{
			switch(object.renderType)
			{
				case GameObject.RENDER_BOTTOM_CENTER:
					renderPoint.x = renderPoint.x - object.graphicResource.frameWidth / 2;
					renderPoint.y = renderPoint.y - object.graphicResource.frameHeight;
					break;
				case GameObject.RENDER_CENTER:
					renderPoint.x = renderPoint.x - object.graphicResource.frameWidth / 2;
					renderPoint.y = renderPoint.y - object.graphicResource.frameHeight / 2;
					break;
			}
		}
		
		public function render(object:GameObject):void
		{
			lastPoint.x = renderPoint.x;
			lastPoint.y = renderPoint.y;
		}
		
		public function renderClear(object:GameObject):void
		{
			drawClear(null, object.renderRect, object.game);
		}
		
		/**
		 * 使用WorldMap.buffer位图数据将buffer的lastPoint位置覆盖擦除
		 * @param source 位图数据(未使用)
		 * @param objRenderRect 要擦除的帧范围,只使用宽和高属性.
		 * @param game 游戏对象数据
		 * 
		 */		
		protected function drawClear(source:BitmapData, objRenderRect:Rectangle, game:BaseGame):void
		{
			dirtyRect.x = lastPoint.x;
			dirtyRect.y = lastPoint.y;
			dirtyRect.width = objRenderRect.width;
			dirtyRect.height = objRenderRect.height;
			
			buffer.copyPixels(game.worldMap.buffer, dirtyRect, lastPoint);
		}
		
		/**
		 * 将指定范围内的位图数据从参数source提供的位图数据中复制到buffer的renderPoint位置
		 * @param source 要显示的位图数据
		 * @param sourceRect 在要显示的位图数据中的范围
		 * @param game 游戏对象数据
		 * 
		 */		
		protected function draw(source:BitmapData, sourceRect:Rectangle, game:BaseGame):void
		{
			if(source == null) return;
			
			try
			{
				buffer.copyPixels(source, sourceRect, renderPoint, null, null, true);
			}
			catch(err:Error)
			{
				trace('渲染错误：', err.name, err.message);
			}
		}
	}
}