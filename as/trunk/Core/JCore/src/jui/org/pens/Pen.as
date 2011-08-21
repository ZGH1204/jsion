package jui.org.pens
{
	import flash.display.Graphics;
	
	import jui.org.IPen;
	import jui.org.JColor;
	
	public class Pen implements IPen
	{
		private var _thickness:Number;
		private var _color:JColor;
		private var _pixelHinting:Boolean;
		private var _scaleMode:String;
		private var _caps:String;
		private var _joints:String;
		private var _miterLimit:Number;
		
		public function Pen(color:JColor,
							thickness:Number=1, 
							pixelHinting:Boolean = false, 
							scaleMode:String = "normal", 
							caps:String = null, 
							joints:String = null, 
							miterLimit:Number = 3)
		{
			this._color = color;
			this._thickness = thickness;
			this._pixelHinting = pixelHinting;
			this._scaleMode = scaleMode;
			this._caps = caps;
			this._joints = joints;
			this._miterLimit = miterLimit;
		}
		
		public function getColor():JColor
		{
			return _color;
		}
		
		public function setColor(color:JColor):void
		{
			this._color=color;
		}
		
		public function getThickness():Number
		{
			return _thickness;
		}
		
		public function setThickness(thickness:Number):void
		{
			this._thickness=thickness;
		}
		
		public function getPixelHinting():Boolean
		{
			return this._pixelHinting;
		}
		
		public function setPixelHinting(pixelHinting:Boolean):void
		{
			this._pixelHinting = pixelHinting;
		}
		
		public function getScaleMode():String
		{
			return this._scaleMode;
		}
		
		public function setScaleMode(scaleMode:String="normal"):void
		{
			this._scaleMode =  scaleMode;
		}
		
		public function getCaps():String
		{
			return this._caps;
		}
		
		public function setCaps(caps:String):void
		{
			this._caps=caps;
		}
		
		public function getJoints():String
		{
			return this._joints;
		}
		
		public function setJoints(joints:String):void
		{
			this._joints=joints;
		}
		
		public function getMiterLimit():Number
		{
			return this._miterLimit;
		}
		
		public function setMiterLimit(miterLimit:Number):void
		{
			this._miterLimit=miterLimit;
		}
		
		public function setTo(target:Graphics):void
		{
			target.lineStyle(_thickness, _color.getRGB(), _color.getAlpha(), _pixelHinting,_scaleMode,_caps,_joints,_miterLimit);
		}
	}
}