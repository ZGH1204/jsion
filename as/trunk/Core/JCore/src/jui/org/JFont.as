package jui.org
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class JFont
	{
		private var textFormat:TextFormat;
		private var fullFeatured:Boolean = false;
		private var advancedProperties:JFontAdvProperties;
		
		public function JFont(nameOrTextFormat:* = "Tahoma", size:Number = 11, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false, embedFontsOrAdvancedPros:* = null)
		{
			if(embedFontsOrAdvancedPros is JFontAdvProperties)
			{
				advancedProperties = embedFontsOrAdvancedPros as JFontAdvProperties;
			}
			else
			{
				advancedProperties = new JFontAdvProperties(embedFontsOrAdvancedPros==true);
			}
			
			if(nameOrTextFormat is TextFormat)
			{
				textFormat = cloneTextFormat(nameOrTextFormat);
				fullFeatured = judegeWhetherFullFeatured();
			}
			else
			{
				textFormat = new TextFormat(nameOrTextFormat, size, 0x0, bold, italic, underline, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
				textFormat.blockIndent = 0;
				textFormat.bullet = false;
				textFormat.kerning = false;
				textFormat.letterSpacing = 0;
				textFormat.tabStops = [];
				fullFeatured = true;
			}
		}
		
		public static function create(textFormat:TextFormat, advPro:JFontAdvProperties):JFont
		{
			return new JFont(textFormat, 11, false, false, false, advPro);
		}
		
		public function getName():String
		{
			return textFormat.font;
		}
		
		public function changeName(name:String):JFont
		{
			var tf:TextFormat = cloneTextFormat(textFormat);
			tf.font = name;
			return new JFont(tf, 0, false, false, false, advancedProperties);
		}
		
		public function getSize():uint
		{
			return uint(textFormat.size);
		}
		
		public function changeSize(size:int):JFont
		{
			var tf:TextFormat = cloneTextFormat(textFormat);
			tf.size = size;
			return new JFont(tf, 0, false, false, false, advancedProperties);
		}
		
		public function isBold() : Boolean
		{
			return (textFormat.bold as Boolean);
		}
		
		public function changeBold(bold:Boolean):JFont
		{
			var tf:TextFormat = cloneTextFormat(textFormat);
			tf.bold = bold;
			return new JFont(tf, 0, false, false, false, advancedProperties);
		}
		
		public function isItalic() : Boolean
		{
			return (textFormat.italic as Boolean);
		}
		
		public function changeItalic(italic:Boolean):JFont
		{
			var tf:TextFormat = cloneTextFormat(textFormat);
			tf.italic = italic;
			return new JFont(tf, 0, false, false, false, advancedProperties);
		}
		
		public function isUnderline() : Boolean
		{
			return (textFormat.underline as Boolean);
		}
		
		public function changeUnderline(underline:Boolean):JFont
		{
			var tf:TextFormat = cloneTextFormat(textFormat);
			tf.underline = underline;
			return new JFont(tf, 0, false, false, false, advancedProperties);
		}
		
		public function isEmbedFonts():Boolean
		{
			return advancedProperties.isEmbedFonts();
		}
		
		public function getAdvancedProperties():JFontAdvProperties
		{
			return advancedProperties;
		}
		
		public function apply(textField:TextField, beginIndex:int=-1, endIndex:int=-1):void
		{
			advancedProperties.apply(textField);
			textField.setTextFormat(textFormat, beginIndex, endIndex);
			textField.defaultTextFormat = textFormat;
		}
		
		public function createTextFormat():TextFormat
		{
			return cloneTextFormat(textFormat);
		}
		
		public function computeTextSize(text:String, includeGutters:Boolean=true):IntDimension
		{
			return JUtil.computeStringSizeWithFont(this, text, includeGutters);
		}
		
		public function clone():JFont
		{
			return new JFont(textFormat, 0, false, false, false, advancedProperties);
		}
		
		public function makeFullFeatured():JFont
		{
			if(!isFullFeatured())
			{
				return takeover(DefaultResource.DEFAULT_FONT);
			}
			else
			{
				return this;
			}
		}
		
		public function isFullFeatured():Boolean
		{
			return fullFeatured;
		}
		
		protected function judegeWhetherFullFeatured():Boolean
		{
			if(null == textFormat.align) return false;
			if(null == textFormat.blockIndent) return false;
			if(null == textFormat.bold) return false;
			if(null == textFormat.bullet) return false;
			if(null == textFormat.color) return false;
			if(null == textFormat.font) return false;
			if(null == textFormat.indent) return false;
			if(null == textFormat.italic) return false;
			if(null == textFormat.kerning) return false;
			if(null == textFormat.leading) return false;
			if(null == textFormat.leftMargin) return false;
			if(null == textFormat.letterSpacing) return false;
			if(null == textFormat.rightMargin) return false;
			if(null == textFormat.size) return false;
			//if(null == textFormat.tabStops) return false;
			if(null == textFormat.target) return false;
			if(null == textFormat.underline) return false;
			if(null == textFormat.url) return false;
			return advancedProperties.isFullFeatured();
		}
		
		private function cloneTextFormat(tf:TextFormat):TextFormat
		{
			var newTF:TextFormat = new TextFormat();
			newTF.align = tf.align;
			newTF.blockIndent = tf.blockIndent;
			newTF.bold = tf.bold;
			newTF.bullet = tf.bullet;
			newTF.color = tf.color;
			newTF.font = tf.font;
			newTF.indent = tf.indent;
			newTF.italic = tf.italic;
			newTF.kerning = tf.kerning;
			newTF.leading = tf.leading;
			newTF.leftMargin = tf.leftMargin;
			newTF.letterSpacing = tf.letterSpacing;
			newTF.rightMargin = tf.rightMargin;
			newTF.size = tf.size;
			newTF.tabStops = tf.tabStops;
			newTF.target = tf.target;
			newTF.underline = tf.underline;
			newTF.url = tf.url;
			return newTF;
		}
		
		public function takeover(oldF:JFont):JFont
		{
			if(null == oldF)
			{
				oldF = DefaultResource.DEFAULT_FONT;
			}
			if(this == oldF)
			{
				return this;
			}
			var tf:TextFormat = oldF.textFormat;
			var newTextFormat:TextFormat = cloneTextFormat(textFormat);
			if(null == newTextFormat.align)
			{
				newTextFormat.align = tf.align;
			}
			if(null == newTextFormat.blockIndent)
			{
				newTextFormat.blockIndent = tf.blockIndent;
			}
			if(null == newTextFormat.bold)
			{
				newTextFormat.bold = tf.bold;
			}
			if(null == newTextFormat.bullet)
			{
				newTextFormat.bullet = tf.bullet;
			}
			if(null == newTextFormat.color)
			{
				newTextFormat.color = tf.color;
			}
			if(null == newTextFormat.font)
			{
				newTextFormat.font = tf.font;
			}
			if(null == newTextFormat.indent)
			{
				newTextFormat.indent = tf.indent;
			}
			if(null == newTextFormat.italic)
			{
				newTextFormat.italic = tf.italic;
			}
			if(null == newTextFormat.kerning)
			{
				newTextFormat.kerning = tf.kerning;
			}
			if(null == newTextFormat.leading)
			{
				newTextFormat.leading = tf.leading;
			}
			if(null == newTextFormat.leftMargin)
			{
				newTextFormat.leftMargin = tf.leftMargin;
			}
			if(null == newTextFormat.letterSpacing)
			{
				newTextFormat.letterSpacing = tf.letterSpacing;
			}
			if(null == newTextFormat.rightMargin)
			{
				newTextFormat.rightMargin = tf.rightMargin;
			}
			if(null == newTextFormat.size)
			{
				newTextFormat.size = tf.size;
			}
			if(null == newTextFormat.tabStops)
			{
				newTextFormat.tabStops = tf.tabStops;
			}
			if(null == newTextFormat.target)
			{
				newTextFormat.target = tf.target;
			}
			if(null == newTextFormat.underline)
			{
				newTextFormat.underline = tf.underline;
			}
			if(null == newTextFormat.url)
			{
				newTextFormat.url = tf.url;
			}
			var advP:JFontAdvProperties = advancedProperties.takeover(oldF.advancedProperties);
			return new JFont(newTextFormat, 0, false, false, false, advP);
		}
		
		public function toString():String
		{
			return "JFont[" + "textFormat : " + textFormat + "]";
		}
	}
}