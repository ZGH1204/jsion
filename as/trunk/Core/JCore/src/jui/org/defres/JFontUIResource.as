package jui.org.defres
{
	import jui.org.IUIResource;
	import jui.org.JFont;

	public class JFontUIResource extends JFont implements IUIResource
	{
		public function JFontUIResource(nameOrTextFormat:*="Tahoma", size:Number=11, bold:Boolean=false, italic:Boolean=false, underline:Boolean=false, embedFontsOrAdvancedPros:*=null)
		{
			super(nameOrTextFormat, size, bold, italic, underline, embedFontsOrAdvancedPros);
		}
		
		public static function createResourceFont(font:JFont):JFontUIResource
		{
			return new JFontUIResource(font.getName(), font.getSize(), font.isBold(), font.isItalic(), font.isUnderline(), font.getAdvancedProperties());
		}
	}
}