package jui.org
{
	import flash.display.Graphics;

	public class Graphics2D implements IDispose
	{
		private var target:Graphics;
		private var brush:IBrush;
		
		public function Graphics2D(graphics:Graphics)
		{
			target = graphics;
		}
		
		public function fillRect(brush:IBrush, x:Number, y:Number, width:Number, height:Number):void
		{
			startBrush(brush);
			rectangle(x, y, width, height);
			endBrush();
		}
		
		public function clear():void
		{
			target.clear();
		}
		
		public function rectangle(x:Number, y:Number, width:Number, height:Number):void
		{
			target.drawRect(x, y, width, height);
		}
		
		public function fillRoundRectRingWithThickness(brush:IBrush, x:Number, y:Number, width:Number, height:Number, radius:Number, thickness:Number, innerRadius:Number = -1):void
		{
			startBrush(brush);
			roundRect(x, y, width, height, radius);
			if(innerRadius == -1) innerRadius = radius - thickness;
			roundRect(x + thickness, y + thickness, width - thickness * 2, height - thickness * 2, innerRadius);
			endBrush();
		}	
		
		public function circle(x:Number, y:Number, radius:Number):void
		{
			target.drawCircle(x, y, radius);
		}
		
		public function ellipse(x:Number, y:Number, width:Number, height:Number):void
		{
			target.drawEllipse(x, y, width, height);
		}
		
		public function line(x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			target.moveTo(x1, y1);
			target.lineTo(x2, y2);
		}
		
		public function beginFill(brush:IBrush):void
		{
			startBrush(brush);
		}
		
		public function endFill():void
		{
			endBrush();
			target.moveTo(0, 0); //avoid a drawing error
		}
		
		public function beginDraw(pen:IPen):void
		{
			startPen(pen);
		}
		
		public function endDraw():void
		{
			endPen();
			target.moveTo(0, 0); //avoid a drawing error
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			target.moveTo(x, y);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			target.curveTo(controlX, controlY, anchorX, anchorY);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			target.lineTo(x, y);
		}
		
		public function polyline(points:Array):void
		{
			if(points.length > 1)
			{
				target.moveTo(points[0].x, points[0].y);
				for(var i:Number=1; i<points.length; i++)
				{
					target.lineTo(points[i].x, points[i].y);
				}
			}
		}
		
		public function polygon(points:Array):void
		{
			if(points.length > 1)
			{
				polyline(points);
				target.lineTo(points[0].x, points[0].y);
			}
		}
		
		public function roundRect(x:Number, y:Number, width:Number, height:Number, radius:Number, topRightRadius:Number = -1, bottomLeftRadius:Number = -1, bottomRightRadius:Number = -1):void
		{
			if(topRightRadius == -1) topRightRadius = radius;
			if(bottomLeftRadius == -1) bottomLeftRadius = radius;
			if(bottomRightRadius == -1) bottomRightRadius = radius;
			
			target.drawRoundRectComplex(x, y, width, height, radius, topRightRadius, bottomLeftRadius, bottomRightRadius);
		}
		
		private function startPen(p:IPen):void
		{
			p.setTo(target);
		}
		
		private function endPen():void
		{
			target.lineStyle();
			target.moveTo(0, 0); //avoid a drawing error
		}
		
		private function startBrush(b:IBrush):void
		{
			brush = b;
			b.beginFill(target);
		}
		
		private function endBrush():void
		{
			brush.endFill(target);
			target.moveTo(0, 0); //avoid a drawing error
		}
		
		public function wedge(radius:Number, x:Number, y:Number, angle:Number):void
		{
			target.moveTo(0, 0);
			target.lineTo(radius, 0);
			
			var nSeg:Number = Math.floor(angle / 30);
			var pSeg:Number = angle - nSeg * 30;
			var a:Number = 0.268;
			var endx:Number;
			var endy:Number;
			var ax:Number;
			var ay:Number;
			var storeCount:Number = 0;
			
			for (var i:Number = 0; i < nSeg; i++)
			{
				endx = radius * Math.cos((i + 1) * 30 * (Math.PI / 180));
				endy = radius * Math.sin((i + 1) * 30 * (Math.PI / 180));
				ax = endx + radius * a * Math.cos(((i + 1) * 30 - 90) * (Math.PI / 180));
				ay = endy + radius * a * Math.sin(((i + 1) * 30 - 90) * (Math.PI / 180));
				target.curveTo(ax, ay, endx, endy);
				storeCount = i + 1;
			}
			
			if (pSeg>0)
			{
				a = Math.tan(pSeg / 2 * (Math.PI / 180));
				endx = radius * Math.cos((storeCount * 30 + pSeg) * (Math.PI / 180));
				endy = radius * Math.sin((storeCount * 30 + pSeg) * (Math.PI / 180));
				ax = endx + radius * a * Math.cos((storeCount * 30 + pSeg - 90) * (Math.PI / 180));
				ay = endy + radius * a * Math.sin((storeCount * 30 + pSeg - 90) * (Math.PI / 180));
				target.curveTo(ax, ay, endx, endy);
			}
			
			target.lineTo(0, 0);
		}
		
		public function fillRectangleRingWithThickness(brush:IBrush, x:Number, y:Number, width:Number, height:Number, thickness:Number):void
		{
			startBrush(brush);
			rectangle(x, y, width, height);
			rectangle(x+thickness, y+thickness, width -thickness*2, height - thickness*2);
			endBrush();
		}
		
		public function dispose():void
		{
			target = null;
			
			brush = null;
		}
		
		public function drawLine(p:IPen, x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			startPen(p);
			line(x1, y1, x2, y2);
			endPen();
		}
	}
}