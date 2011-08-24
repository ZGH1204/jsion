package jui.org.uis.buttons
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.filters.ColorMatrixFilter;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.Icon;
	
	public class SimpleButtonIcon implements Icon
	{
		private var asset:SimpleButton;
		private var width:int;
		private var height:int;
		
		private static var disabledFilters:Array;
		private static var eabledFilters:Array = [];
		
		public function SimpleButtonIcon(asset:SimpleButton)
		{
			this.asset = asset;
			width = Math.ceil(asset.width);
			height = Math.ceil(asset.height);
			
			if(disabledFilters == null)
			{
				var cmatrix:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
				disabledFilters = [new ColorMatrixFilter(cmatrix)];			
			}
		}
		
		public function getIconWidth(c:Component):int
		{
			return width;
		}
		
		public function getIconHeight(c:Component):int
		{
			return height;
		}
		
		public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void
		{
			asset.x = x;
			asset.y = y;
			asset.mouseEnabled = c.isEnabled();
			asset.filters = c.isEnabled() ? eabledFilters : disabledFilters;
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return asset;
		}
		
		public function dispose():void
		{
			asset = null;
			
			disabledFilters = null;
			
			eabledFilters = null;
		}
	}
}