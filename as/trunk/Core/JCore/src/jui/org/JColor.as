package jui.org
{
	public class JColor
	{
		protected var rgb:uint;
		protected var alpha:Number;
		
		/**
		 * 色相
		 */		
		protected var hue:Number;
		
		/**
		 * 亮度
		 */		
		protected var luminance:Number;
		
		/**
		 * 饱和度
		 */		
		protected var saturation:Number;
		
		/**
		 * 指示色相、亮度、饱和度是否计算过
		 */		
		private var hlsCounted:Boolean;
		
		public function JColor(rgb:uint=0x000000, alpha:Number=1)
		{
			this.rgb = rgb;
			
			this.alpha = Math.min(1, Math.max(0, alpha));
			
			hlsCounted = false;
		}
		
		public function getAlpha():Number
		{
			return alpha;	
		}
		
		public function getRGB():uint
		{
			return rgb;	
		}
		
		public function getARGB():uint
		{
			var a:uint = alpha * 255;
			return rgb | (a << 24);
		}
		
		public function getRed():uint
		{
			return (rgb & 0x00FF0000) >> 16;
		}
		
		public function getGreen():uint
		{
			return (rgb & 0x0000FF00) >> 8;
		}
		
		public function getBlue():uint
		{
			return (rgb & 0x000000FF);
		}
		
		public function getHue():Number
		{
			countHLS();
			return hue;
		}
		
		public function getLuminance():Number
		{
			countHLS();
			return luminance;
		}
		
		public function getSaturation():Number
		{
			countHLS();
			return saturation;
		}
		
		private function countHLS():void
		{
			if(hlsCounted)
			{
				return;
			}
			hlsCounted = true;
			var rr:Number = getRed() / 255.0;
			var gg:Number = getGreen() / 255.0;
			var bb:Number = getBlue() / 255.0;
			
			var rnorm:Number, gnorm:Number, bnorm:Number;
			var minval:Number, maxval:Number, msum:Number, mdiff:Number;
			var r:Number, g:Number, b:Number;
			
			r = g = b = 0;
			if (rr > 0) r = rr; if (r > 1) r = 1;
			if (gg > 0) g = gg; if (g > 1) g = 1;
			if (bb > 0) b = bb; if (b > 1) b = 1;
			
			minval = r;
			if (g < minval) minval = g;
			if (b < minval) minval = b;
			maxval = r;
			if (g > maxval) maxval = g;
			if (b > maxval) maxval = b;
			
			rnorm = gnorm = bnorm = 0;
			mdiff = maxval - minval;
			msum  = maxval + minval;
			luminance = 0.5 * msum;
			if (maxval != minval)
			{
				rnorm = (maxval - r)/mdiff;
				gnorm = (maxval - g)/mdiff;
				bnorm = (maxval - b)/mdiff;
			}
			else
			{
				saturation = hue = 0;
				return;
			}
			
			if (luminance < 0.5)
				saturation = mdiff/msum;
			else
				saturation = mdiff/(2.0 - msum);
			
			if (r == maxval)
				hue = 60.0 * (6.0 + bnorm - gnorm);
			else if (g == maxval)
				hue = 60.0 * (2.0 + rnorm - bnorm);
			else
				hue = 60.0 * (4.0 + gnorm - rnorm);
			
			if (hue > 360)
				hue = hue - 360;
			
			hue /= 360;
		}
		
		public function changeAlpha(newAlpha:Number):JColor
		{
			return new JColor(getRGB(), newAlpha);
		}
		
		public function changeHue(newHue:Number):JColor
		{
			return getJColorWithHLS(newHue, getLuminance(), getSaturation(), getAlpha());
		}
		
		public function changeLuminance(newLuminance:Number):JColor
		{
			return getJColorWithHLS(getHue(), newLuminance, getSaturation(), getAlpha());
		}
		
		public function changeSaturation(newSaturation:Number):JColor
		{
			return getJColorWithHLS(getHue(), getLuminance(), newSaturation, getAlpha());
		}
		
		public function scaleHLS(hScale:Number, lScale:Number, sScale:Number):JColor
		{
			var h:Number = getHue() * hScale;
			var l:Number = getLuminance() * lScale;
			var s:Number = getSaturation() * sScale;
			return getJColorWithHLS(h, l, s, alpha);
		}
		
		public function offsetHLS(hOffset:Number, lOffset:Number, sOffset:Number):JColor
		{
			var h:Number = getHue() + hOffset;
			if(h > 1) h -= 1;
			if(h < 0) h += 1;
			var l:Number = getLuminance() + lOffset;
			var s:Number = getSaturation() + sOffset;
			return getJColorWithHLS(h, l, s, alpha);
		}
		
		public function darker(factor:Number=0.7):JColor
		{
			var r:uint = getRed();
			var g:uint = getGreen();
			var b:uint = getBlue();
			return getJColor(r*factor, g*factor, b*factor, alpha);
		}
		
		public function brighter(factor:Number=0.7):JColor
		{
			var r:uint = getRed();
			var g:uint = getGreen();
			var b:uint = getBlue();
			
			/* From 2D group:
			* 1. black.brighter() should return grey
			* 2. applying brighter to blue will always return blue, brighter
			* 3. non pure color (non zero rgb) will eventually return white
			*/
			var i:Number = Math.floor(1.0/(1.0-factor));
			if ( r == 0 && g == 0 && b == 0)
			{
				return getJColor(i, i, i, alpha);
			}
			
			if ( r > 0 && r < i ) r = i;
			if ( g > 0 && g < i ) g = i;
			if ( b > 0 && b < i ) b = i;
			
			return getJColor(r/factor, g/factor, b/factor, alpha);
		}
		
		public static function getJColor(r:uint, g:uint, b:uint, a:Number=1):JColor
		{
			return new JColor(getRGBWith(r, g, b), a);
		}
		
		public static function getWithARGB(argb:uint):JColor
		{
			var rgb:uint = argb & 0x00FFFFFF;
			var alpha:Number = (argb >>> 24)/255;
			return new JColor(rgb, alpha);
		}
		
		public static function getJColorWithHLS(h:Number, l:Number, s:Number, a:Number=1):JColor
		{
			var c:JColor = new JColor(0, a);
			c.hlsCounted = true;
			c.hue = Math.max(0, Math.min(1, h));
			c.luminance = Math.max(0, Math.min(1, l));
			c.saturation = Math.max(0, Math.min(1, s));
			
			var H:Number = c.hue;
			var L:Number = c.luminance;
			var S:Number = c.saturation;
			
			var p1:Number, p2:Number, r:Number, g:Number, b:Number;
			p1 = p2 = 0;
			H = H*360;
			if(L<0.5)
			{
				p2=L*(1+S);
			}
			else
			{
				p2=L + S - L*S;
			}
			p1=2*L-p2;
			if(S==0)
			{
				r=L;
				g=L;
				b=L;
			}
			else
			{
				r = hlsValue(p1, p2, H+120);
				g = hlsValue(p1, p2, H);
				b = hlsValue(p1, p2, H-120);
			}
			r *= 255;
			g *= 255;
			b *= 255;
			var color_n:Number = (r<<16) + (g<<8) +b;
			var color_rgb:uint = Math.max(0, Math.min(0xFFFFFF, Math.round(color_n)));
			c.rgb = color_rgb;
			return c;
		}
		
		private static function hlsValue(p1:Number, p2:Number, h:Number):Number
		{
			if (h > 360) h = h - 360;
			if (h < 0)   h = h + 360;
			if (h < 60 ) return p1 + (p2-p1)*h/60;
			if (h < 180) return p2;
			if (h < 240) return p1 + (p2-p1)*(240-h)/60;
			return p1;
		}
		
		public static function getRGBWith(rr:uint, gg:uint, bb:uint):uint
		{
			var r:uint = rr;
			var g:uint = gg;
			var b:uint = bb;
			
			if(r > 255)
			{
				r = 255;
			}
			if(g > 255)
			{
				g = 255;
			}
			if(b > 255)
			{
				b = 255;
			}
			var color_n:uint = (r<<16) + (g<<8) + b;
			
			return color_n;
		}
		
		public function toString():String
		{
			return "JColor(rgb:"+rgb.toString(16)+", alpha:"+alpha+")";
		}
		
		public function equals(o:Object):Boolean
		{
			var c:JColor = o as JColor;
			
			if(c != null)
			{
				return c.alpha === alpha && c.rgb === rgb;
			}
			else
			{
				return false;
			}
		}
		
		public function clone():JColor
		{
			return new JColor(getRGB(), getAlpha());
		}
	}
}