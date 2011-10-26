package editor.hideshower
{
	import flash.display.Shape;
	import flash.geom.Point;
	import editor.showers.MapShower;

	public class TileShower extends BaseShower
	{
		public var tileGrid:Shape;
		
		public function TileShower(shower:MapShower)
		{
			super(shower);
		}
		
		override protected function initialize():void
		{
			tileGrid = new Shape();
			tileGrid.visible = false;
		}
		
		override public function update():void
		{
			if(tileGrid == null || tileGrid.visible == false)
			{
				tileGrid.graphics.clear();
				return;
			}
			
			var tilex:int = map.originTileX;
			var tiley:int = map.originTileY;
			
			var areax:int = map.areaTileX + 1;
			var areay:int = map.areaTileY + 1;
			
			var point:Point = map.tileToScreen(tilex, tiley);
			
			var drawX:int = point.x;
			var drawY:int = point.y;
			
			tileGrid.graphics.clear();
			tileGrid.graphics.lineStyle(1, 0xFF0000);
			
			for(var i:int = 0; i < areax; i++)
			{
				tileGrid.graphics.moveTo(drawX + (i * map.tileWidth), drawY);
				tileGrid.graphics.lineTo(drawX + (i * map.tileWidth), shower.gameHeight + map.tileHeight * 2);
			}
			
			for(var j:int = 0; j < areay; j++)
			{
				tileGrid.graphics.moveTo(drawX, drawY + (j * map.tileHeight));
				tileGrid.graphics.lineTo(shower.gameWidth + map.tileWidth * 2, drawY + (j * map.tileHeight));
			}
		}
		
		override public function setVisible(value:Boolean):void
		{
			if(tileGrid) tileGrid.visible = value;
		}
	}
}