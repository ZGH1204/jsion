package jsion.utils
{
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * 显示对象工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class DisplayUtil
	{
		/**
		 * 替换新的显示对象到指定显示对象的位置
		 * @param oldChild 指定显示对象的位置
		 * @param newChild 新的显示对象
		 * @param parent 新的显示容器,未指定则以 oldChild.parent 作为其容器。
		 * 
		 */		
		public static function replace(oldChild:DisplayObject, newChild:DisplayObject, parent:DisplayObjectContainer = null):void
		{
			if(parent == null) parent = oldChild.parent;
			var p:Point = new Point(oldChild.x, oldChild.y);
			p = oldChild.parent.localToGlobal(p);
			p = parent.globalToLocal(p);
			var index:int = parent.getChildIndex(oldChild);
			newChild.x = p.x;
			newChild.y = p.y;
			parent.addChildAt(newChild, index);
			parent.removeChild(oldChild);
		}
		
		/**
		 * 使用矢量画出一个模态阴影。
		 * @param display 要画模态阴影的显示对象
		 * @param color 模态阴影颜色
		 * @param alpha 模态阴影透明度
		 * @param width 模态阴影宽度
		 * @param height 模态阴影高度
		 * 
		 */		
		public static function drawModal(display:Sprite, color:uint = 0xCCCCCC, alpha:Number = 0.5, width:int = 2000, height:int = 2000):void
		{
			display.graphics.clear();
			display.graphics.beginFill(color, alpha);
			display.graphics.drawRect(-width, -height, width * 3, height * 3);
			display.graphics.endFill();
		}
	}
}