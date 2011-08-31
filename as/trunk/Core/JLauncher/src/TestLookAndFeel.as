package
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	import jcomponent.org.basic.BasicLookAndFeel;
	import jcomponent.org.coms.buttons.ButtonImageBackground;
	import jcomponent.org.coms.buttons.ButtonScaleImageBackground;
	import jcomponent.org.coms.buttons.CheckBoxBackground;
	
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
			
//			list.push("ImageButton.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("ImageButton.upFilters", null);
//			list.push("ImageButton.overFilters", [lightingFilter]);
//			list.push("ImageButton.downFilters", null);
//			list.push("ImageButton.disabledFilters", [gray_filter]);
//			list.push("ImageButton.selectedFilters", null);
//			list.push("ImageButton.overSelectedFilters", null);
//			list.push("ImageButton.downSelectedFilters", null);
//			list.push("ImageButton.disabledSelectedFilters", null);
			
			list.push("ImageButton.bg", ButtonImageBackground);
			
			list.push("ImageButton.upImg", ButtonUp_Asset);
			list.push("ImageButton.overImg", ButtonOver_Asset);
			list.push("ImageButton.downImg", ButtonDown_Asset);
//			list.push("ImageButton.disabledImg", null);
//			list.push("ImageButton.selectedImg", null);
//			list.push("ImageButton.overSelectedImg", null);
//			list.push("ImageButton.downSelectedImg", null);
//			list.push("ImageButton.disabledSelectedImg", null);
			
			
			
			
			
			
//			list.push("ScaleImageButton.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("ScaleImageButton.upFilters", null);
//			list.push("ScaleImageButton.overFilters", [lightingFilter]);
//			list.push("ScaleImageButton.downFilters", null);
//			list.push("ScaleImageButton.disabledFilters", [gray_filter]);
//			list.push("ScaleImageButton.selectedFilters", null);
//			list.push("ScaleImageButton.overSelectedFilters", null);
//			list.push("ScaleImageButton.downSelectedFilters", null);
//			list.push("ScaleImageButton.disabledSelectedFilters", null);
			
			list.push("ScaleImageButton.bg", ButtonScaleImageBackground);
			
			list.push("ScaleImageButton.upImg", ButtonUp_Asset);
			list.push("ScaleImageButton.overImg", ButtonOver_Asset);
			list.push("ScaleImageButton.downImg", ButtonDown_Asset);
//			list.push("ScaleImageButton.disabledImg", null);
//			list.push("ScaleImageButton.selectedImg", null);
//			list.push("ScaleImageButton.overSelectedImg", null);
//			list.push("ScaleImageButton.downSelectedImg", null);
//			list.push("ScaleImageButton.disabledSelectedImg", null);
			
			var insets:Insets = new Insets(7, 7, 7, 7);
			list.push("ScaleImageButton.upInsets", insets);
			list.push("ScaleImageButton.overInsets", insets);
			list.push("ScaleImageButton.downInsets", insets);
//			list.push("ScaleImageButton.disabledInsets", null);
//			list.push("ScaleImageButton.selectedInsets", null);
//			list.push("ScaleImageButton.overSelectedInsets", null);
//			list.push("ScaleImageButton.downSelectedInsets", null);
//			list.push("ScaleImageButton.disabledSelectedInsets", null);
			
			
			
			
			
//			list.push("ToggleButton.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("ToggleButton.upFilters", null);
//			list.push("ToggleButton.overFilters", [lightingFilter]);
//			list.push("ToggleButton.downFilters", null);
//			list.push("ToggleButton.disabledFilters", [gray_filter]);
//			list.push("ToggleButton.selectedFilters", null);
//			list.push("ToggleButton.overSelectedFilters", null);
//			list.push("ToggleButton.downSelectedFilters", null);
//			list.push("ToggleButton.disabledSelectedFilters", null);
			
			list.push("ToggleButton.bg", ButtonImageBackground);
			
			list.push("ToggleButton.upImg", ButtonUp_Asset);
			list.push("ToggleButton.overImg", ButtonOver_Asset);
			list.push("ToggleButton.downImg", ButtonDown_Asset);
//			list.push("ToggleButton.disabledImg", null);
			list.push("ToggleButton.selectedImg", ButtonDown_Asset);
			list.push("ToggleButton.overSelectedImg", ButtonDown_Asset);
//			list.push("ToggleButton.downSelectedImg", null);
//			list.push("ToggleButton.disabledSelectedImg", null);
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
//			list.push("ScaleToggleButton.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("ScaleToggleButton.upFilters", null);
//			list.push("ScaleToggleButton.overFilters", [lightingFilter]);
//			list.push("ScaleToggleButton.downFilters", null);
//			list.push("ScaleToggleButton.disabledFilters", [gray_filter]);
//			list.push("ScaleToggleButton.selectedFilters", null);
//			list.push("ScaleToggleButton.overSelectedFilters", null);
//			list.push("ScaleToggleButton.downSelectedFilters", null);
//			list.push("ScaleToggleButton.disabledSelectedFilters", null);
			
			list.push("ScaleToggleButton.bg", ButtonScaleImageBackground);
			
			list.push("ScaleToggleButton.upImg", ButtonUp_Asset);
			list.push("ScaleToggleButton.overImg", ButtonOver_Asset);
			list.push("ScaleToggleButton.downImg", ButtonDown_Asset);
//			list.push("ScaleToggleButton.disabledImg", null);
			list.push("ScaleToggleButton.selectedImg", ButtonDown_Asset);
			list.push("ScaleToggleButton.overSelectedImg", ButtonDown_Asset);
//			list.push("ScaleToggleButton.downSelectedImg", null);
//			list.push("ScaleToggleButton.disabledSelectedImg", null);
			
			list.push("ScaleToggleButton.upInsets", insets);
			list.push("ScaleToggleButton.overInsets", insets);
			list.push("ScaleToggleButton.downInsets", insets);
//			list.push("ScaleToggleButton.disabledInsets", null);
			list.push("ScaleToggleButton.selectedInsets", insets);
			list.push("ScaleToggleButton.overSelectedInsets", insets);
//			list.push("ScaleToggleButton.downSelectedInsets", null);
//			list.push("ScaleToggleButton.disabledSelectedInsets", null);
			
			
			
			
			
			
			
			
//			list.push("CheckBox.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("CheckBox.upFilters", null);
//			list.push("CheckBox.overFilters", [lightingFilter]);
//			list.push("CheckBox.downFilters", null);
//			list.push("CheckBox.disabledFilters", [gray_filter]);
//			list.push("CheckBox.selectedFilters", null);
//			list.push("CheckBox.overSelectedFilters", null);
//			list.push("CheckBox.downSelectedFilters", null);
//			list.push("CheckBox.disabledSelectedFilters", null);
			
			list.push("CheckBox.bg", CheckBoxBackground);
			
			list.push("CheckBox.upImg", ButtonUp_Asset);
			list.push("CheckBox.overImg", ButtonOver_Asset);
			list.push("CheckBox.downImg", ButtonDown_Asset);
//			list.push("CheckBox.disabledImg", null);
			list.push("CheckBox.selectedImg", ButtonDown_Asset);
			list.push("CheckBox.overSelectedImg", ButtonDown_Asset);
//			list.push("CheckBox.downSelectedImg", null);
//			list.push("CheckBox.disabledSelectedImg", null);
			
			list.push("CheckBox.upInsets", insets);
			list.push("CheckBox.overInsets", insets);
			list.push("CheckBox.downInsets", insets);
//			list.push("CheckBox.disabledInsets", null);
			list.push("CheckBox.selectedInsets", insets);
			list.push("CheckBox.overSelectedInsets", insets);
//			list.push("CheckBox.downSelectedInsets", null);
//			list.push("CheckBox.disabledSelectedInsets", null);
			
			
			
			
			
			
			
//			list.push("CheckBox.textFilters", [new GlowFilter(0x996348,1,4,4,10)]);//发光滤镜
//			list.push("CheckBox.upFilters", null);
//			list.push("CheckBox.overFilters", [lightingFilter]);
//			list.push("CheckBox.downFilters", null);
//			list.push("CheckBox.disabledFilters", [gray_filter]);
//			list.push("CheckBox.selectedFilters", null);
//			list.push("CheckBox.overSelectedFilters", null);
//			list.push("CheckBox.downSelectedFilters", null);
//			list.push("CheckBox.disabledSelectedFilters", null);
			
			list.push("RadioButton.bg", CheckBoxBackground);
			
			list.push("RadioButton.upImg", ButtonUp_Asset);
			list.push("RadioButton.overImg", ButtonOver_Asset);
			list.push("RadioButton.downImg", ButtonDown_Asset);
//			list.push("CheckBox.disabledImg", null);
			list.push("RadioButton.selectedImg", ButtonDown_Asset);
			list.push("RadioButton.overSelectedImg", ButtonDown_Asset);
//			list.push("CheckBox.downSelectedImg", null);
//			list.push("CheckBox.disabledSelectedImg", null);
			
			list.push("RadioButton.upInsets", insets);
			list.push("RadioButton.overInsets", insets);
			list.push("RadioButton.downInsets", insets);
//			list.push("CheckBox.disabledInsets", null);
			list.push("RadioButton.selectedInsets", insets);
			list.push("RadioButton.overSelectedInsets", insets);
//			list.push("CheckBox.downSelectedInsets", null);
//			list.push("CheckBox.disabledSelectedInsets", null);
		}
	}
}