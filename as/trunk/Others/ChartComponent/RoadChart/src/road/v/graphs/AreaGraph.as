package road.v.graphs
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.v.core.GraphItem;
	import road.v.core.GridPlacement;
	import road.v.core.LineStyle;
	import road.v.events.ItemEvent;
	
	public class AreaGraph extends GridBasedGraph
	{
		public static const GRAPH_AREA_COLOR:String = "graphAreaColor";
		public static const GRAPH_AREA_ALPHA:String = "graphAreaAlpha";
		
        protected var _graphLayer:Shape;
        protected var _graphMask:Shape;
		
		public function AreaGraph()
		{
			
		}
		
		override protected function initStyle():void
		{
			_styles[GRAPH_LINE_STYLE] = new LineStyle(0x222222, 1, 1);
			_styles[GRAPH_AREA_COLOR] = 0x222222;
			_styles[GRAPH_AREA_ALPHA] = 0.5;
		}
		
		override protected function applyChanges():void
		{
			if (!_categoryGrid || !_valueGrid || !_data) return;
			
			drawGraph();
			
			if (isInvalidOnly(INVALID_TYPE_SIZE))
            {
                locateItems();
            }
            else
            {
            	if (_items)
                {
                    for each (var gi:GraphItem in _items)
                    {
                        
                        if (this.contains(gi))
                        {
                            this.removeChild(gi);
                        }
                    }
                }
                genItems();
                locateItems();
            }
		}
		
		protected function genItems():void
		{
			_items = [];
			
			if (_itemRenderer)
			{
				var i:uint = 0;
				var count:uint = _data.length;
				while(i < count)
				{
					if(isNaN(_data[i]))
					{
						i++;
						continue;
					}
					
					var gi:GraphItem = new _itemRenderer();
					gi.setStyles(_itemStylesCache);
					gi.index = i;
					gi.setStyle("color",_styles[GRAPH_LINE_STYLE].color);
					addChild(gi);
					gi.addEventListener(MouseEvent.ROLL_OVER,doItemOperate);
					gi.addEventListener(MouseEvent.ROLL_OUT,doItemOperate);
					gi.addEventListener(MouseEvent.CLICK,doItemOperate);
					_items[i] = gi;
					
					i++;
				}
			}
		}
		
		protected function doItemOperate(e:MouseEvent) : void
		{
			var type:String
			
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					type = ItemEvent.ITEM_OVER;
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					type = ItemEvent.ITEM_OUT;
					break;
				}
				case MouseEvent.CLICK:
				{
					type = ItemEvent.ITEM_CLICK;
					break;
				}
				default:
				{
					break;
				}
			}
			
			var ie:ItemEvent = new ItemEvent(type);
            ie.index = (e.currentTarget as GraphItem).index;
            this.dispatchEvent(ie);
		}
		
		protected function locateItems():void
		{
			var point:Point;
			for each(var gi:GraphItem in _items)
			{
				point = getPointByIndex(gi.index);
				gi.x = point.x;
				gi.y = point.y;
			}
		}
		
		protected function drawGraph():void
		{
			if (_graphLayer == null)
            {
                _graphLayer = new Shape();
                addChildAt(_graphLayer, 0);
                _graphMask = new Shape();
                addChild(_graphMask);
                _graphLayer.mask = _graphMask;
            }
            
            var g:Graphics = _graphLayer.graphics;
            g.clear();
            
            var ls:LineStyle = _styles[GRAPH_LINE_STYLE];
            g.lineStyle(ls.thickness, ls.color, ls.alpha);
            
            var point:Point;
			var firstPoint:Point;
			var i:uint = 0;
            var count:uint = _data.length;
            
            if(count > 0)
            	g.beginFill(_styles[GRAPH_AREA_COLOR], _styles[GRAPH_AREA_ALPHA]);
            
            while(i < count)
            {
            	if(isNaN(_data[i]))
            	{
            		i++;
            		continue;
            	}
            	
            	point = getPointByIndex(i);
            	if(firstPoint)
            	{
            		g.lineTo(point.x, point.y);
            		i++;
            		continue;
            	}
            	g.moveTo(point.x, point.y);
            	firstPoint = point.clone();
            	i++;
            }
            
            g.lineStyle();
            
            if(firstPoint)
            {
            	switch(_categoryGrid.placement)
            	{
            		case GridPlacement.BOTTOM:
            		{
            			g.lineTo(point.x, _height);
            			g.lineTo(firstPoint.x, _height);
            			g.lineTo(firstPoint.x, firstPoint.y);
            			break;
            		}
            		case GridPlacement.TOP:
            		{
            			g.lineTo(point.x, 0);
            			g.lineTo(firstPoint.x, 0)
            			g.lineTo(firstPoint.x, firstPoint.y);
            			break;
            		}
            		case GridPlacement.LEFT:
            		{
            			g.lineTo(0, point.y)
            			g.lineTo(0, firstPoint.y);
            			g.lineTo(firstPoint.x, firstPoint.y);
            			break;
            		}
            		case GridPlacement.RIGHT:
            		{
            			g.lineTo(_width, point.y);
            			g.lineTo(_width, firstPoint.y);
            			g.lineTo(firstPoint.x, firstPoint.y);
            			break;
            		}
            		default:
            		{
            			break;
            		}
            	}
            	g.endFill();
            	g = _graphMask.graphics;
            	g.clear();
            	g.beginFill(0,1);
            	g.drawRect(0,0,_width,_height);
            	g.endFill();
            }
		}
	}
}