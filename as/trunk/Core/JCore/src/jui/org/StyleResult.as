package jui.org
{
	
	/**
	 * The class for a result of a main color adjusted by a adjuster.
	 */
	public class StyleResult
	{
		
		/**
		 * Content light color
		 */
		public var clight:JColor;
		/**
		 * Content dark color
		 */	
		public var cdark:JColor;
		/**
		 * Border light color
		 */		
		public var blight:JColor;
		/**
		 * Border dark color
		 */		
		public var bdark:JColor;
		/**
		 * Shadow color alpha
		 */
		public var shadow:Number;
		/**
		 * The round rect radius
		 */
		public var round:Number;
		
		public function StyleResult(mainColor:JColor, tune:StyleTune)
		{
			clight = tune.getCLight(mainColor);
			cdark  = tune.getCDark(mainColor);
			blight = tune.getBLight(mainColor);
			bdark  = tune.getBDark(mainColor);
			shadow = tune.getShadowAlpha();
			round  = tune.round;
		}
		
	}
}