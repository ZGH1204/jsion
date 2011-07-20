package road.v.graphs
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.v.core.GraphItem;
	import road.v.core.LineStyle;
	import road.v.events.ItemEvent;
	
	public class LineGraph extends GridBasedGraph
	{
        protected var _graphLayer:Shape;
        protected var _graphMask:Shape;
        
		public function LineGraph()
		{
		}
		
		override protected function initStyle():void
		{
			_styles[GRAPH_LINE_STYLE] = new LineStyle(0x222222, 1, 1);
		}
		
		override protected function applyChanges():void
		{
			if(!_categoryGrid || !_valueGrid || !_data) return;
			
			drawGraph();
			
			if(isInvalidOnly(INVALID_TYPE_SIZE))
			{
				locateItems();
			}
			else
			{
				if(_items)
				{
					for each(var gi:GraphItem in _items)
					{
						if(this.contains(gi))
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
			
			if(_itemRenderer)
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
					addChild(gi);
					gi.addEventListener(MouseEvent.ROLL_OVER, doItemOperate);
					gi.addEventListener(MouseEvent.ROLL_OUT, doItemOperate);
					gi.addEventListener(MouseEvent.CLICK, doItemOperate);
					_items[i] = gi;
					i++;
				}
			}
		}
		
		protected function doItemOperate(e:MouseEvent) : void
		{
			var type:String;
			
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
            
            var ls:LineStyle = _styles[GRAPH_LINE_STYLE] as LineStyle;
            g.lineStyle(ls.thickness, ls.color, ls.alpha);
            
            var flag:Boolean;
            var i:uint = 0;
            var count:uint = _data.length;
            
            while(i < count)
            {
            	if(isNaN(_data[i]))
				{
					i++;
					continue;
				}
            	
            	var point:Point = getPointByIndex(i);
            	if(flag)
            	{
            		g.lineTo(point.x, point.y);
            		i++;
            		continue;
            	}
            	
            	g.moveTo(point.x, point.y);
            	flag = true;
            	i++;
            }
            
            g = _graphMask.graphics;
            g.clear();
            g.beginFill(0, 1);
            g.drawRect(0,0,_width,_height);
            g.endFill();
		}
		
		protected function locateItems():void
		{
			var gi:GraphItem;
			var point:Point;
			for each(gi in _items)
			{
				point = getPointByIndex(gi.index);
				gi.x = point.x;
				gi.y = point.y;
			}
		}
	}
}