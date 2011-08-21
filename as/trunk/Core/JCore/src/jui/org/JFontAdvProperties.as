package jui.org
{
	import flash.text.TextField;

	public class JFontAdvProperties
	{
		private var fullFeatured:Boolean = false;
		private var antiAliasType:String;
		private var gridFitType:String;
		private var sharpness:Object;
		private var thickness:Object;
		private var embedFonts:Object;
		
		public function JFontAdvProperties(embedFonts:Object = false, antiAliasType:String = "normal", gridFitType:String = "pixel", sharpness:Object = 0, thickness:Object = 0)
		{
			this.embedFonts = embedFonts;
			this.antiAliasType = antiAliasType;
			this.gridFitType = gridFitType;
			this.sharpness = sharpness;
			this.thickness = thickness;
			
			fullFeatured = judegeWhetherFullFeatured();
		}
		
		public function getAntiAliasType():String
		{
			return antiAliasType;
		}
		
		public function changeAntiAliasType(newType:String):JFontAdvProperties
		{
			return new JFontAdvProperties(embedFonts, newType, gridFitType, sharpness, thickness);
		}
		
		public function getGridFitType():String
		{
			return gridFitType;
		}
		
		public function changeGridFitType(newType:String):JFontAdvProperties
		{
			return new JFontAdvProperties(embedFonts, antiAliasType, newType, sharpness, thickness);
		}
		
		public function getSharpness():Object
		{
			return sharpness;
		}
		
		public function changeSharpness(newSharpness:Object):JFontAdvProperties
		{
			return new JFontAdvProperties(embedFonts, antiAliasType, gridFitType, newSharpness, thickness);
		}
		
		public function getThickness():Object
		{
			return thickness;
		}
		
		public function changeThickness(newThickness:Object):JFontAdvProperties
		{
			return new JFontAdvProperties(embedFonts, antiAliasType, gridFitType, sharpness, newThickness);
		}
		
		public function isEmbedFonts():Object
		{
			return embedFonts;
		}
		
		public function changeEmbedFonts(ef:Object):JFontAdvProperties
		{
			return new JFontAdvProperties(ef, antiAliasType, gridFitType, sharpness, thickness);
		}
		
		public function apply(textField:TextField):void
		{
			if(null != isEmbedFonts()){
				textField.embedFonts = isEmbedFonts() == true;
			}
			if(null != getAntiAliasType()){
				textField.antiAliasType = getAntiAliasType();
			}
			if(null != getGridFitType()){
				textField.gridFitType = getGridFitType();
			}
			
			if(null != getSharpness()){
				textField.sharpness = Number(getSharpness());
			}
			
			if(null != getThickness()){
				textField.thickness = Number(getThickness());
			}
		}
		
		public function takeover(oldF:JFontAdvProperties):JFontAdvProperties
		{
			var nadv:JFontAdvProperties = new JFontAdvProperties(embedFonts, antiAliasType, gridFitType, sharpness, thickness);
			if(null == embedFonts){
				nadv.embedFonts = oldF.embedFonts;
			}
			if(null == antiAliasType){
				nadv.antiAliasType = oldF.antiAliasType;
			}
			if(null == gridFitType){
				nadv.gridFitType = oldF.gridFitType;
			}
			if(null == sharpness){
				nadv.sharpness = oldF.sharpness;
			}
			if(null == thickness){
				nadv.thickness = oldF.thickness;
			}
			nadv.fullFeatured = nadv.judegeWhetherFullFeatured();
			return nadv;
		}
		
		public function isFullFeatured():Boolean
		{
			return fullFeatured;
		}
		
		protected function judegeWhetherFullFeatured():Boolean
		{
			if(null == this.antiAliasType) return false;
			if(null == this.embedFonts) return false;
			if(null == this.gridFitType) return false;
			if(null == this.sharpness) return false;
			if(null == this.thickness) return false;
			return true;
		}	
		
		public function toString():String
		{
			return "JFontAdvProperties[" 
			+ "embedFonts : " + embedFonts 
				+ ", antiAliasType : " + antiAliasType 
				+ ", gridFitType : " + gridFitType 
				+ ", sharpness : " + sharpness 
				+ ", thickness : " + thickness 
				+ "]";
		}
	}
}