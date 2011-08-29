package
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	import jcomponent.org.basic.BasicLookAndFeel;
	
	public class TestLookAndFeel extends BasicLookAndFeel
	{
		public function TestLookAndFeel()
		{
			super();
		}
		
		override protected function initComponentResources(list:Array):void
		{
			var myElements_array:Array = [	0.3, 	0.59, 	0.11, 	0, 	0, 
											0.3, 	0.59, 	0.11, 	0, 	0, 
										  	0.3, 	0.59, 	0.11, 	0, 	0, 
										   	0, 		0, 		0, 		1, 	0	];
			var gray_filter:ColorMatrixFilter = new ColorMatrixFilter(myElements_array);//灰显滤镜
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			var lightingFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);//高亮滤镜
			
			list.push("ImageButton.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//我发光滤镜
//			list.push("ImageButton.upFilters", null);
			list.push("ImageButton.overFilters", [lightingFilter]);
//			list.push("ImageButton.downFilters", null);
			list.push("ImageButton.disabledFilters", [gray_filter]);
//			list.push("ImageButton.selectedFilters", null);
//			list.push("ImageButton.overSelectedFilters", null);
//			list.push("ImageButton.downSelectedFilters", null);
//			list.push("ImageButton.disabledSelectedFilters", null);
			
			list.push("ImageButton.upImg", ButtonUp_Asset);
			//list.push("ImageButton.overImg", ButtonOver_Asset);
			list.push("ImageButton.downImg", ButtonDown_Asset);
//			list.push("ImageButton.disabledImg", null);
//			list.push("ImageButton.selectedImg", null);
//			list.push("ImageButton.overSelectedImg", null);
//			list.push("ImageButton.downSelectedImg", null);
//			list.push("ImageButton.disabledSelectedImg", null);
		}
	}
}