package jcomponent.org.basic
{
	import flash.display.DisplayObject;

	public interface IDecorator extends IDispose
	{
		/**
		 * 此方法多次调用必需返回同一个对象
		 * @param component 被装饰的组件对象
		 * @return 要添加到显示列表的显示对象
		 *
		 */		
		function getDisplay(component:Component):DisplayObject
	}
}

