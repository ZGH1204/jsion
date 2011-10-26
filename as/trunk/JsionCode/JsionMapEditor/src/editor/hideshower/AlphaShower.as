package editor.hideshower
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	import jsion.utils.RandomUtil;
	import editor.showers.MapShower;

	public class AlphaShower extends BaseShower
	{
		public var tileGrid:Shape;
		
		public function AlphaShower(shower:MapShower)
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
			
			var list:Array = JsionEditor.mapWayConfig;
			
			var tilex:int = map.originWayTileX;
			var tiley:int = map.originWayTileY;
			
			var areax:int = map.wayAreaTileX + 1;
			var areay:int = map.wayAreaTileY + 1;
			
			if((areax + tilex) > map.maxWayTileX) areax--;
			if((areay + tiley) > map.maxWayTileY) areay--;
			
			var point:Point = map.wayTileToScreen(tilex, tiley);
			
			var drawX:int = point.x;
			var drawY:int = point.y;
			
			tileGrid.graphics.clear();
			
			tileGrid.graphics.lineStyle(1, 0x0000FF);
			
			for(var n:int = 0; n < areay; n++)
			{
				for(var m:int = 0; m < areax; m++)
				{
					if(list[n + tiley][m + tilex] == 1)
					{
						tileGrid.graphics.beginFill(0xFF5555, 0.5);
						tileGrid.graphics.drawRect(drawX + (m * map.wayTileWidth), drawY + (n * map.wayTileHeight), map.wayTileWidth, map.wayTileHeight);
						tileGrid.graphics.endFill();
					}
				}
			}
			
			for(var i:int = 0; i < areax; i++)
			{
				tileGrid.graphics.moveTo(drawX + (i * map.wayTileWidth),  drawY);
				tileGrid.graphics.lineTo(drawX + (i * map.wayTileWidth), shower.gameHeight + map.wayTileHeight * 2);
			}
			
			for(var j:int = 0; j < areay; j++)
			{
				tileGrid.graphics.moveTo(drawX, 								  drawY + (j * map.wayTileHeight));
				tileGrid.graphics.lineTo(shower.gameWidth + map.wayTileWidth * 2, drawY + (j * map.wayTileHeight));
			}
		}
		
		public function setTilesCross(x:int, y:int, $x:int, $y:int):void
		{
			var lastStatus:int = -1;
			
			var statusAllSame:Boolean = true;
			
			if($x < x)
			{
				$x = x - $x;
				x = x - $x;
				$x = x + $x;
			}
			
			if($y < y)
			{
				$y = y - $y;
				y = y - $y;
				$y = y + $y;
			}
			
			var i:int, j:int;
			
			var list:Array = JsionEditor.mapWayConfig;
			
			for(j = y; j <= $y; j++)
			{
				for(i = x; i <= $x; i++)
				{
					if(lastStatus == -1)
					{
						lastStatus = int(list[j][i]);
					}
					else if(lastStatus != int(list[j][i]))
					{
						statusAllSame = false;
						break;
					}
				}
			}
			
			var rltStatus:int = 1;
			
			if(statusAllSame)
			{
				if(rltStatus == lastStatus) rltStatus = 0;
			}
			
			for(j = y; j <= $y; j++)
			{
				for(i = x; i <= $x; i++)
				{
					list[j][i] = rltStatus;
				}
			}
			
			update();
		}
		
		override public function setVisible(value:Boolean):void
		{
			if(tileGrid) tileGrid.visible = value;
		}
	}
}