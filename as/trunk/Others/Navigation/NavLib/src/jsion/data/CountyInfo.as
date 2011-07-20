package jsion.data
{
	public class CountyInfo extends TownInfo
	{
		public var topPic:String;
		public var topPicX:Number = 0;
		public var topPicY:Number = 0;
		
		public var bottomPic:String;
		public var bottomPicX:Number = 0;
		public var bottomPicY:Number = 0;
		
		public var countyFont:String;
		public var countySize:int;
		public var countyColor:uint;
		public var countyBold:Boolean;
		public var countyItalic:Boolean;
		public var countyX:Number;
		public var countyY:Number;
		
		
		public var background:String;
		public var dialogWidth:Number;
		public var dialogHeight:Number;
		public var dialogClose:String;
		public var dialogCloseX:Number;
		public var dialogCloseY:Number;
		
		
		public var townContainerX:Number;
		public var townContainerY:Number;
		public var townItemWidth:Number;
		public var townItemHeight:Number;
		public var townColumns:int;
		
		
		
		
		
		
		public var townList:Vector.<TownInfo> = new Vector.<TownInfo>();
	}
}