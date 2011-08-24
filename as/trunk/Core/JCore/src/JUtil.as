package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.JColor;
	import jui.org.JFont;
	import jui.org.StyleResult;
	import jui.org.brushs.GradientBrush;
	import jui.org.brushs.SolidBrush;
	import jui.org.coms.buttons.AbstractButton;
	import jui.org.pens.Pen;

	/**
	 * 其他特殊工具方法集合
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class JUtil
	{
		private static var TEXT_FIELD_EXT:TextField = new TextField();
		{
			TEXT_FIELD_EXT.autoSize = TextFieldAutoSize.LEFT;
			TEXT_FIELD_EXT.type = TextFieldType.DYNAMIC;
		}
		
		private static var sprite:Sprite = new Sprite();
		
		/**
		 * 替换掉http://..../ 
		 */		
		private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
		/**
		 * 替换: :|.|\/
		 */		
		private static const _reg2:RegExp = /[:|.|\/]/g;
		
		/**
		 * 全局帧频刷新事件, 保证所有处理都在同一帧, 避免异步问题。
		 * @param listener 处理事件的侦听器函数。
		 * @param useCapture 此参数适用于 SWF 内容所使用的 ActionScript 3.0 显示列表体系结构中的显示对象。确定侦听器是运行于捕获阶段还是目标阶段和冒泡阶段。如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。要在所有三个阶段都侦听事件，请调用 addEventListener 两次：一次将 useCapture 设置为 true，一次将 useCapture 设置为 false。
		 * @param priority 事件侦听器的优先级。优先级由一个带符号的 32 位整数指定。数字越大，优先级越高。优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。默认优先级为 0。
		 * @param useWeakReference 确定对侦听器的引用是强引用，还是弱引用。强引用（默认值）可防止您的侦听器被当作垃圾回收。弱引用则没有此作用。
		 * 
		 */		
		public static function addEnterFrame(listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			sprite.addEventListener(Event.ENTER_FRAME, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEnterFrame(listener:Function, useCapture:Boolean = false):void
		{
			sprite.removeEventListener(Event.ENTER_FRAME, listener, useCapture);
		}
		
		/**
		 * 将路径转换为字典键
		 * @param path 路径
		 * @return 字典键
		 * 
		 */		
		public static function path2Key(path:String):String
		{
			var index:int = path.indexOf("?");
			var key:String = path.substring(0, (index == -1 ? int.MAX_VALUE : index));
			
			key = key.replace(_reg1,"");
			key = key.replace(_reg2,"_");
			
			return key;
		}
		
		/**
		 * 获取指定路径中文件的扩展名
		 * @param url 文件的路径
		 * @return 扩展名
		 * 
		 */		
		public static function getExtension(url:String):String
		{
			var startIndex:int = url.lastIndexOf("/");
			if(startIndex == -1) startIndex = 0;
			
			var endIndex:int = url.indexOf("?");
			if(endIndex == -1) endIndex = url.length;
			
			var name:String = url.substring(startIndex, endIndex);
			var dotIndex:int = name.lastIndexOf(".");
			if(dotIndex == -1) return null;
			var ext:String = name.substr(dotIndex + 1);
			return ext;
		}
		
		/**
		 * 指示ancestor容器中是否包含child显示对象
		 * @param ancestor 显示对象容器
		 * @param child 显示对象
		 * @return true表示包含,false反之.
		 */		
		public static function isAncestorDisplayObject(ancestor:DisplayObjectContainer, child:DisplayObject):Boolean
		{
			if(ancestor == null || child == null) 
				return false;
			
			var pa:DisplayObjectContainer = child.parent;
			while(pa != null){
				if(pa == ancestor){
					return true;
				}
				pa = pa.parent;
			}
			return false;
		}
		
		public static function computeStringSize(tf:TextFormat, str:String, includeGutters:Boolean = true, textField:TextField = null):IntDimension
		{
			if(textField)
			{
				TEXT_FIELD_EXT.embedFonts = textField.embedFonts;
				TEXT_FIELD_EXT.antiAliasType = textField.antiAliasType;
				TEXT_FIELD_EXT.gridFitType = textField.gridFitType;
				TEXT_FIELD_EXT.sharpness = textField.sharpness;
				TEXT_FIELD_EXT.thickness = textField.thickness;
			}
			
			TEXT_FIELD_EXT.text = str;
			TEXT_FIELD_EXT.setTextFormat(tf);
			
			if(includeGutters)
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.width), Math.ceil(TEXT_FIELD_EXT.height));
			}
			else
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.textWidth), Math.ceil(TEXT_FIELD_EXT.textHeight));
			}
		}
		
		public static function computeStringSizeWithFont(font:JFont, str:String, includeGutters:Boolean = true):IntDimension
		{
			if(!font.isFullFeatured())
			{
				throw new Error("Font is not full featured : " + font);
			}
			
			TEXT_FIELD_EXT.text = str;
			font.apply(TEXT_FIELD_EXT);
			if(includeGutters)
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.width), Math.ceil(TEXT_FIELD_EXT.height));
			}
			else
			{
				return new IntDimension(Math.ceil(TEXT_FIELD_EXT.textWidth), Math.ceil(TEXT_FIELD_EXT.textHeight));
			}
		}
		
		public static function isDisplayObjectShowing(dis:DisplayObject):Boolean
		{
			if(dis == null || dis.stage == null)
			{
				return false;
			}
			
			while(dis != null && dis.visible == true)
			{
				if(dis == dis.stage)
				{
					return true;
				}
				
				dis = dis.parent;
			}
			
			return false;
		}
		
		public static function applyTextColor(text:TextField, color:JColor):void
		{
			if(text.textColor !== color.getRGB())
			{
				text.textColor = color.getRGB();
			}
			
			if(text.alpha !== color.getAlpha())
			{
				text.alpha = color.getAlpha();
			}
		}
		
		public static function applyTextFont(text:TextField, font:JFont):void
		{
			font.apply(text);
		}
		
		public static function applyTextFontAndColor(text:TextField, font:JFont, color:JColor):void
		{
			applyTextFont(text, font);
			applyTextColor(text, color);
		}
		
		public static function createLabel(parent:DisplayObjectContainer = null, name:String = null):TextField
		{
			var textField:TextField = new TextField();
			textField.focusRect = false;
			
			if(name != null)
			{
				textField.name = name;
			}
			
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.tabEnabled = false;
			
			if(parent != null)
			{
				parent.addChild(textField);
			}
			
			return textField;
		}
		
		public static function createShape(parent:DisplayObjectContainer = null, name:String = null):Shape
		{
			var sp:Shape = new Shape();
			
			if(name != null)
			{
				sp.name = name;
			}
			
			if(parent != null)
			{
				parent.addChild(sp);
			}
			
			return sp;
		}
		
		public static var gradientRatio:Array = [0, 255];
		public static var roundRectBtmFix:Number = 0.5;
		
		public static function getGradientBrush(tune:StyleResult, matrix:Matrix, border:Boolean=false, ratios:Array=null):GradientBrush
		{
			var light:JColor;
			var dark:JColor;
			
			if(border)
			{
				light = tune.blight;
				dark  = tune.bdark;
			}
			else
			{
				light = tune.clight;
				dark  = tune.cdark;
			}
			
			if(ratios == null)
			{
				ratios = gradientRatio;
			}
			
			return new GradientBrush(
				GradientBrush.LINEAR, 
				[light.getRGB(), dark.getRGB()], 
				[light.getAlpha(), dark.getAlpha()], 
				ratios, 
				matrix
			);
		}
		
		private static var sharedMatrix:Matrix = new Matrix();
		
		public static function fillGradientRoundRect(g:Graphics2D, b:IntRectangle, tune:StyleResult, direction:Number = 1.5707963267948966, border:Boolean=false, matrixB:IntRectangle=null, ratios:Array=null):void
		{
			if(matrixB == null)
			{
				matrixB = b;
			}
			
			sharedMatrix.createGradientBox(matrixB.width, matrixB.height, direction, matrixB.x, matrixB.y);
			g.beginFill(getGradientBrush(tune, sharedMatrix, border, ratios));
			var r:Number = tune.round;
			
			if(r < roundRectBtmFix)
			{
				g.rectangle(b.x, b.y, b.width, b.height);
			}
			else
			{
				var fix:Number = roundRectBtmFix;
				
				if(r > 5)
				{
					fix = 0;
				}
				
				g.roundRect(b.x, b.y, b.width, b.height, r, r, r+fix, r+fix);
			}
			
			g.endFill();
		}
		
		public static function fillGradientRoundRectBottomRightAngle(g:Graphics2D, b:IntRectangle, tune:StyleResult, direction:Number=1.5707963267948966, border:Boolean=false, matrixB:IntRectangle=null):void
		{
			if(matrixB == null)
			{
				matrixB = b;
			}
			
			sharedMatrix.createGradientBox(matrixB.width, matrixB.height, direction, matrixB.x, matrixB.y);
			g.beginFill(getGradientBrush(tune, sharedMatrix, border));
			var r:Number = tune.round;
			
			if(r < roundRectBtmFix)
			{
				g.rectangle(b.x, b.y, b.width, b.height);
			}
			else
			{
				var fix:Number = roundRectBtmFix;
				
				if(r > 5)
				{
					fix = 0;
				}
				
				g.roundRect(b.x, b.y, b.width, b.height, r, r, 0, 0);
			}
			g.endFill();
		}
		
		public static function drawRoundRect(g:Graphics2D, x:Number, y:Number, w:Number, h:Number, r:Number):void
		{
			var fix:Number = r > 5 ? 0 : roundRectBtmFix;
			g.roundRect(x, y, w, h, r, r, r+fix, r+fix);
		}
		
		public static function drawRoundRectLine(g:Graphics2D, x:Number, y:Number, w:Number, h:Number, r:Number, t:Number):void
		{
			if(r < roundRectBtmFix)
			{
				g.rectangle(x, y, w, h);
				g.rectangle(x+t, y+t, w-t*2, h-t*2);
			}
			else
			{
				var fix:Number = roundRectBtmFix;
				if(r > 5){
					fix = 0;
				}
				g.roundRect(x, y, w, h, r, r, r+fix, r+fix);
				r -= t/2;
				g.roundRect(x+t, y+t, w-t*2, h-t*2, r, r, r+fix, r+fix);
			}
		}
		
		public static function drawGradientRoundRectLine(g:Graphics2D, b:IntRectangle, t:Number, tune:StyleResult, direction:Number=1.5707963267948966, border:Boolean=true, matrixB:IntRectangle=null):void
		{
			var r:Number = tune.round;
			
			if(matrixB == null)
			{
				matrixB = b;
			}
			
			sharedMatrix.createGradientBox(matrixB.width, matrixB.height, direction, matrixB.x, matrixB.y);
			g.beginFill(getGradientBrush(tune, sharedMatrix, border));
			drawRoundRectLine(g, b.x, b.y, b.width, b.height, r, t);
			g.endFill();
		}
		
		public static function getArrowPath(width:Number, direction:Number, centerX:Number, centerY:Number, round:Boolean=true):Array
		{
			var center:Point = new Point(centerX, centerY);
			var w:Number = width;
			var ps1:Array = new Array();
			ps1.push(nextPoint(center, direction, w/2/2, round));
			var back:Point = nextPoint(center, direction + Math.PI, w/2/2);
			ps1.push(nextPoint(back, direction - Math.PI/2, w/2, round));
			ps1.push(nextPoint(back, direction + Math.PI/2, w/2, round));
			return ps1;
		}
		
		private static function nextPoint(p:Point, dir:Number, dis:Number, round:Boolean=false):Point
		{
			if(round)
			{
				return new Point(Math.round(p.x+Math.cos(dir)*dis), Math.round(p.y+Math.sin(dir)*dis));
			}
			else
			{
				return new Point(p.x+Math.cos(dir)*dis, p.y+Math.sin(dir)*dis);
			}
		}
		
		public static function getDisabledColor(c:Component):JColor
		{
			var bg:JColor = c.getBackground();
			if(bg == null) bg = JColor.BLACK;
			return disabledColor(bg);
		}
		
		public static function disabledColor(cl:JColor):JColor
		{
			var bg:JColor = cl;
			var hue:Number = bg.getHue();
			var lum:Number = bg.getLuminance();
			var sat:Number = bg.getSaturation();
			
			if(lum < 0.6)
			{
				lum += 0.1;
			}
			else
			{
				lum -= 0.1;
			}
			
			sat -= 0.2;
			
			return JColor.getJColorWithHLS(hue, lum, sat, bg.getAlpha());
		}
		
		public static function drawUpperedBezel(g:Graphics2D, r:IntRectangle, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void
		{
			var x1:Number = r.x;
			var y1:Number = r.y;
			var w:Number = r.width;
			var h:Number = r.height;
			
			var brush:SolidBrush = new SolidBrush(darkShadow);
			g.fillRectangleRingWithThickness(brush, x1, y1, w, h, 1);
			
			brush.setColor(lightHighlight);
			g.fillRectangleRingWithThickness(brush, x1, y1, w-1, h-1, 1);
			
			brush.setColor(highlight);
			g.fillRectangleRingWithThickness(brush, x1+1, y1+1, w-2, h-2, 1);
			
			brush.setColor(shadow);
			g.fillRect(brush, x1+w-2, y1+1, 1, h-2);
			g.fillRect(brush, x1+1, y1+h-2, w-2, 1);
		}
		
		public static function drawLoweredBezel(g:Graphics2D, r:IntRectangle, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void
		{
			
			var x1:Number = r.x;
			var y1:Number = r.y;
			var w:Number = r.width;
			var h:Number = r.height;
			
			var brush:SolidBrush = new SolidBrush(darkShadow);
			g.fillRectangleRingWithThickness(brush, x1, y1, w, h, 1);
			
			brush.setColor(darkShadow);
			g.fillRectangleRingWithThickness(brush, x1, y1, w-1, h-1, 1);
			
			brush.setColor(highlight);
			g.fillRectangleRingWithThickness(brush, x1+1, y1+1, w-2, h-2, 1);
			
			brush.setColor(highlight);
			g.fillRect(brush, x1+w-2, y1+1, 1, h-2);
			g.fillRect(brush, x1+1, y1+h-2, w-2, 1);
		}
		
		public static function drawBezel(g:Graphics2D, r:IntRectangle, isPressed:Boolean, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void
		{
			
			if(isPressed)
			{
				drawLoweredBezel(g, r, shadow, darkShadow, highlight, lightHighlight);
			}
			else
			{
				drawUpperedBezel(g, r, shadow, darkShadow, highlight, lightHighlight);
			}
		}
		
		public static function paintBezel(g:Graphics2D, r:IntRectangle, isPressed:Boolean, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void
		{
			
			if(isPressed)
			{
				paintLoweredBevel(g, r, shadow, darkShadow, highlight, lightHighlight);
			}
			else
			{
				paintRaisedBevel(g, r, shadow, darkShadow, highlight, lightHighlight);
			}
		}
		
		public static function paintRaisedBevel(g:Graphics2D, r:IntRectangle, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void
		{
			var h:Number = r.height - 1;
			var w:Number = r.width - 1;
			var x:Number = r.x + 0.5;
			var y:Number = r.y + 0.5;
			var pen:Pen = new Pen(lightHighlight, 1, false, "normal", "square", "miter");
			g.drawLine(pen, x, y, x, y+h-2);
			g.drawLine(pen, x+1, y, x+w-2, y);
			
			pen.setColor(highlight);
			g.drawLine(pen, x+1, y+1, x+1, y+h-3);
			g.drawLine(pen, x+2, y+1, x+w-3, y+1);
			
			pen.setColor(darkShadow);
			g.drawLine(pen, x, y+h-1, x+w-1, y+h-1);
			g.drawLine(pen, x+w-1, y, x+w-1, y+h-2);
			
			pen.setColor(shadow);
			g.drawLine(pen, x+1, y+h-2, x+w-2, y+h-2);
			g.drawLine(pen, x+w-2, y+1, x+w-2, y+h-3);
		}
		
		public static function paintLoweredBevel(g:Graphics2D, r:IntRectangle, shadow:JColor, darkShadow:JColor, highlight:JColor, lightHighlight:JColor):void 
		{
			var h:Number = r.height - 1;
			var w:Number = r.width - 1;
			var x:Number = r.x + 0.5;
			var y:Number = r.y + 0.5;
			var pen:Pen = new Pen(shadow, 1, false, "normal", "square", "miter");
			g.drawLine(pen, x, y, x, y+h-1);
			g.drawLine(pen, x+1, y, x+w-1, y);
			
			pen.setColor(darkShadow);
			g.drawLine(pen, x+1, y+1, x+1, y+h-2);
			g.drawLine(pen, x+2, y+1, x+w-2, y+1);
			
			pen.setColor(lightHighlight);
			g.drawLine(pen, x+1, y+h-1, x+w-1, y+h-1);
			g.drawLine(pen, x+w-1, y+1, x+w-1, y+h-2);
			
			pen.setColor(highlight);
			g.drawLine(pen, x+2, y+h-2, x+w-2, y+h-2);
			g.drawLine(pen, x+w-2, y+2, x+w-2, y+h-3);
		}
		
		public static function paintButtonBackGround(c:AbstractButton, g:Graphics2D, b:IntRectangle):void
		{
			var bgColor:JColor = (c.getBackground() == null ? JColor.WHITE : c.getBackground());
			
			if(c.isOpaque())
			{
				if(c.getModel().isArmed() || c.getModel().isSelected() || !c.isEnabled())
				{
					g.fillRect(new SolidBrush(bgColor), b.x, b.y, b.width, b.height);
				}
				else
				{
					drawControlBackground(g, b, bgColor, Math.PI/2);
				}
			}
		}
		
		public static function drawControlBackground(g:Graphics2D, b:IntRectangle, bgColor:JColor, direction:Number):void
		{
			g.fillRect(new SolidBrush(bgColor), b.x, b.y, b.width, b.height);
			var x:Number = b.x;
			var y:Number = b.y;
			var w:Number = b.width;
			var h:Number = b.height;
			var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [0.75, 0];
			var ratios:Array = [0, 100];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, direction, x, y);       
			var brush:GradientBrush = new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
			g.fillRect(brush, x, y, w, h);
		}
		
		public static function fillGradientRect(g:Graphics2D, b:IntRectangle, c1:JColor, c2:JColor, direction:Number, ratios:Array=null):void
		{
			var x:Number = b.x;
			var y:Number = b.y;
			var w:Number = b.width;
			var h:Number = b.height;
			var colors:Array = [c1.getRGB(), c2.getRGB()];
			var alphas:Array = [c1.getAlpha(), c2.getAlpha()];
			
			if(ratios == null)
			{
				ratios = [0, 255];
			}
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, direction, x, y);       
			var brush:GradientBrush = new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
			g.fillRect(brush, x, y, w, h);
		}
	}
}