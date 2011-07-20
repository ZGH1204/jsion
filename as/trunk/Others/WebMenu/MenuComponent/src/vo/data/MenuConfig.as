package vo.data
{
	public dynamic class MenuConfig
	{
		public var id:String;
		public var file:String;
		
		public var logoCls:String;
		public var logoX:Number = 0;
		public var logoY:Number = 0;
		
		public var backgroundCls:String;
		public var backgroundX:Number = 0;
		public var backgroundY:Number = 0;
		
		public var itemStartX:Number;
		public var itemStartY:Number;
		public var itemWidth:Number;
		public var itemHeight:Number;
		public var itemCls:String;
		public var splitCls:String;
		public var overCls:String;
		public var downCls:String;
		public var direction:String;
		
		public var enable:Boolean;
		public var grey:Boolean;
		
		public var itemList:Array = [];
	}
}