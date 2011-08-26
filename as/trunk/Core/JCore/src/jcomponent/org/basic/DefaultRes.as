package jcomponent.org.basic
{
	import jcomponent.org.basic.borders.EmptyBorder;
	import jcomponent.org.basic.borders.IBorder;

	public class DefaultRes
	{
		public static const DEFAULT_COLOR:ASColor = new ASColor(0, 0);

		public static const DEFAULT_BACKGROUND_COLOR:ASColor = new ASColor(0, 1);

		public static const DEFAULT_FOREGROUND_COLOR:ASColor = new ASColor(0xFFFFFF);

		public static const DEFAULT_FONT:ASFont = new ASFont();

		public static const DEFAULT_STYLE_TUNE:StyleTune = new StyleTune();

		public static const DEFAULT_BORDER:IBorder = new EmptyBorder();
	}
}

