package jui.org.coms.buttons
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.IButtonModel;
	import jui.org.ICanUpdateProvider;
	import jui.org.IUIResource;
	import jui.org.JColor;
	import jui.org.StyleResult;
	import jui.org.StyleTune;
	import jui.org.brushs.GradientBrush;
	
	import jutils.org.util.DisposeUtil;
	
	public class ButtonBackground implements ICanUpdateProvider, IUIResource
	{
		protected var shape:Shape;
		
		public function ButtonBackground()
		{
		}
		
		public function update(c:Component, g:Graphics2D, bounds:IntRectangle):void
		{
			var b:AbstractButton = c as AbstractButton;
			
			if(b == null)
			{
				return;
			}
			
			shape.graphics.clear();
			g = new Graphics2D(shape.graphics);
			bounds = bounds.clone();
			// make 2 pixel space for shadow filter effect
			bounds.width -= 2;
			bounds.height -= 2;
			
			var cl:JColor = c.getBackground();
			var style:StyleResult;
			var adjuster:StyleTune = c.getStyleTune();
			
			if(c.isOpaque())
			{
				var model:IButtonModel = b.getModel();
				var isPressing:Boolean = model.isArmed() || model.isSelected();
				var shadowScale:Number = 1;
				var bo:IntRectangle = bounds.clone();
				var matrix:Matrix = new Matrix();
				var cDir:Number = Math.PI/2;
				var paintDefault:Boolean = false;
				
				if(!b.isEnabled())
				{//disabled
					cl = cl.offsetHLS(0, 0.2, -0.06);
					adjuster = adjuster.sharpen(0.4);
					//paint
				}
				else if(isPressing)
				{//pressed
					//adjuster = adjuster.sharpen(0.8);
					cDir = -Math.PI/2;
					//paint
				}
				else if(model.isRollOver())
				{//over
					cl = cl.offsetHLS(0, 0.1, 0);
					//paint
				}
				else
				{//normal
					if(b is Button && Button(b).isDefaultButton())
					{//default button
						paintDefault = true;
					}
				}
				
				style = new StyleResult(cl, adjuster);
				
				JUtil.fillGradientRoundRect(g, bounds, style, cDir);
				
				matrix.createGradientBox(bo.width, bo.height, Math.PI/2, bo.x, bo.y);
				
				g.beginFill(new GradientBrush(
					GradientType.LINEAR, 
					[style.bdark.getRGB(), style.bdark.getRGB()], 
					[1, 0.6], 
					[0, 255], 
					matrix));
				
				JUtil.drawRoundRectLine(g, bo.x, bo.y, bo.width, bo.height, style.round, 1);
				g.endFill();
				
				matrix.createGradientBox(bo.width, bo.height, Math.PI/6, bo.x, bo.y);
				g.beginFill(new GradientBrush(
					GradientType.LINEAR, 
					[style.blight.getRGB(), style.blight.getRGB()], 
					[1, 0.5], 
					[0, 255], 
					matrix));
				
				bo.grow(-1, -1);
				JUtil.drawRoundRectLine(g, bo.x, bo.y, bo.width, bo.height, style.round-1, 1);
				g.endFill();
				
				if(paintDefault)
				{
					cl = cl.offsetHLS(0, -0.05, 0);
					var db:IntRectangle = bounds.clone();
					db.grow(-2, -2);
					JUtil.fillGradientRoundRect(
						g, db, new StyleResult(cl, adjuster));
				}
				
				shape.filters = [new DropShadowFilter(1, 45, 0x0, style.shadow*shadowScale, 2, 2, 1, 1)];
			}
			else
			{
				shape.filters = [];
			}
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return shape;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(shape);
			shape = null;
		}
	}
}