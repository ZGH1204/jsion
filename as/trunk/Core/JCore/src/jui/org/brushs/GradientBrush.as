package jui.org.brushs
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import jui.org.IBrush;
	
	public class GradientBrush implements IBrush
	{
		public static const LINEAR:String = GradientType.LINEAR;
		public static const RADIAL:String = GradientType.RADIAL;
		
		private var fillType:String;
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		private var matrix:Matrix;
		private var spreadMethod:String;
		private var interpolationMethod:String;
		private var focalPointRatio:Number;
		
		public function GradientBrush(fillType:String , colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0)
		{
			this.fillType = fillType;
			this.colors = colors;
			this.alphas = alphas;
			this.ratios = ratios;
			this.matrix = matrix;
			this.spreadMethod = spreadMethod;
			this.interpolationMethod = interpolationMethod;
			this.focalPointRatio = focalPointRatio;
		}
		
		public function getFillType():String
		{
			return fillType;
		}
		
		public function setFillType(t:String):void
		{
			fillType = t;
		}
		
		public function getColors():Array
		{
			return colors;
		}
		
		public function setColors(cs:Array):void
		{
			colors = cs;
		}
		
		public function getAlphas():Array
		{
			return alphas;
		}
		
		/**
		 * Pay attention that the value in the array should be between 0-1. if the value is greater than 1, 1 will be used, if the value is less than 0, 0 will be used
		 */
		public function setAlphas(alphas:Array):void
		{
			this.alphas = alphas;
		}
		
		public function getRatios():Array
		{
			return ratios;
		}
		
		/**
		 * Ratios should be between 0-255, if the value is greater than 255, 255 will be used, if the value is less than 0, 0 will be used
		 */
		public function setRatios(ratios:Array):void
		{
			ratios = ratios;
		}
		
		public function getMatrix():Object
		{
			return matrix;
		}
		
		public function setMatrix(m:Matrix):void
		{
			matrix = m;
		}
		
		public function beginFill(target:Graphics):void
		{
			target.beginGradientFill(fillType, colors, alphas, ratios, matrix, 
				spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		public function endFill(target:Graphics):void
		{
			target.endFill();
		}
		
		public function dispose():void
		{
		}
	}
}