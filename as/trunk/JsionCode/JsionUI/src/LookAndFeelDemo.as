package
{
	import jsion.*;
	import jsion.ui.BasicLookAndFeel;
	import jsion.ui.ImageBackGround;
	import jsion.ui.components.buttons.ButtonIcon;
	import jsion.ui.components.buttons.ButtonImageBackground;
	import jsion.ui.components.buttons.ButtonScaleImageBackground;
	
	public class LookAndFeelDemo extends BasicLookAndFeel
	{
		public function LookAndFeelDemo()
		{
			super();
		}
		
		override protected function initComponentResources(list:Array):void
		{
//			var myElements_array:Array = [	0.3, 	0.59, 	0.11, 	0, 	0, 
//											0.3, 	0.59, 	0.11, 	0, 	0, 
//										  	0.3, 	0.59, 	0.11, 	0, 	0, 
//										   	0, 		0, 		0, 		1, 	0	];
//			var gray_filter:ColorMatrixFilter = new ColorMatrixFilter(myElements_array);//灰显滤镜
			
//			var matrix:Array = new Array();
//			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
//			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
//			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
//			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
//			var lightingFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);//高亮滤镜
			
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
			
//			list.push("ImageButton.upImg", ButtonUp_Asset);
//			list.push("ImageButton.overImg", ButtonOver_Asset);
//			list.push("ImageButton.downImg", ButtonDown_Asset);
			
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
			
//			list.push("ScaleImageButton.upImg", ButtonUp_Asset);
//			list.push("ScaleImageButton.overImg", ButtonOver_Asset);
//			list.push("ScaleImageButton.downImg", ButtonDown_Asset);
//			list.push("ScaleImageButton.disabledImg", null);
//			list.push("ScaleImageButton.selectedImg", null);
//			list.push("ScaleImageButton.overSelectedImg", null);
//			list.push("ScaleImageButton.downSelectedImg", null);
//			list.push("ScaleImageButton.disabledSelectedImg", null);
			
//			var insets:Insets = new Insets(7, 7, 7, 7);
//			list.push("ScaleImageButton.upInsets", insets);
//			list.push("ScaleImageButton.overInsets", insets);
//			list.push("ScaleImageButton.downInsets", insets);
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
			
//			list.push("ToggleButton.upImg", ButtonUp_Asset);
//			list.push("ToggleButton.overImg", ButtonOver_Asset);
//			list.push("ToggleButton.downImg", ButtonDown_Asset);
//			list.push("ToggleButton.disabledImg", null);
//			list.push("ToggleButton.selectedImg", ButtonDown_Asset);
//			list.push("ToggleButton.overSelectedImg", ButtonDown_Asset);
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
			
//			list.push("ScaleToggleButton.upImg", ButtonUp_Asset);
//			list.push("ScaleToggleButton.overImg", ButtonOver_Asset);
//			list.push("ScaleToggleButton.downImg", ButtonDown_Asset);
//			list.push("ScaleToggleButton.disabledImg", null);
//			list.push("ScaleToggleButton.selectedImg", ButtonDown_Asset);
//			list.push("ScaleToggleButton.overSelectedImg", ButtonDown_Asset);
//			list.push("ScaleToggleButton.downSelectedImg", null);
//			list.push("ScaleToggleButton.disabledSelectedImg", null);
			
//			list.push("ScaleToggleButton.upInsets", insets);
//			list.push("ScaleToggleButton.overInsets", insets);
//			list.push("ScaleToggleButton.downInsets", insets);
//			list.push("ScaleToggleButton.disabledInsets", null);
//			list.push("ScaleToggleButton.selectedInsets", insets);
//			list.push("ScaleToggleButton.overSelectedInsets", insets);
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
			
			list.push("CheckBox.icon", ButtonIcon);
			
//			list.push("CheckBox.iconUpImg", CheckBoxUnSelected_Asset);
//			list.push("CheckBox.iconOverImg", null);
//			list.push("CheckBox.iconDownImg", null);
//			list.push("CheckBox.iconDisabledImg", null);
//			list.push("CheckBox.iconSelectedImg", CheckBoxSelected_Asset);
//			list.push("CheckBox.iconOverSelectedImg", null);
//			list.push("CheckBox.iconDownSelectedImg", null);
//			list.push("CheckBox.iconDisabledSelectedImg", null);
			
//			list.push("CheckBox.upInsets", null);
//			list.push("CheckBox.overInsets", null);
//			list.push("CheckBox.downInsets", null);
//			list.push("CheckBox.disabledInsets", null);
//			list.push("CheckBox.selectedInsets", null);
//			list.push("CheckBox.overSelectedInsets", null);
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
			
			
			
			
			
			
			
			
			
			
			
			list.push("RadioButton.icon", ButtonIcon);
			
//			list.push("RadioButton.iconUpImg", ButtonUp_Asset);
//			list.push("RadioButton.iconOverImg", ButtonOver_Asset);
//			list.push("RadioButton.iconDownImg", ButtonDown_Asset);
//			list.push("RadioButton.iconDisabledImg", null);
//			list.push("RadioButton.iconSelectedImg", ButtonDown_Asset);
//			list.push("RadioButton.iconOverSelectedImg", ButtonDown_Asset);
//			list.push("RadioButton.iconDownSelectedImg", null);
//			list.push("RadioButton.iconDisabledSelectedImg", null);
			
//			list.push("RadioButton.upInsets", null);
//			list.push("RadioButton.overInsets", null);
//			list.push("RadioButton.downInsets", null);
//			list.push("CheckBox.disabledInsets", null);
//			list.push("RadioButton.selectedInsets", null);
//			list.push("RadioButton.overSelectedInsets", null);
//			list.push("RadioButton.downSelectedInsets", null);
//			list.push("RadioButton.disabledSelectedInsets", null);
			
			
			
			
			
			
			
			
			
			list.push("Window.bg", ImageBackGround);
//			list.push("Window.bgImg", WindowBackground_Asset);
//			list.push("Window.bgInsets", new Insets(53, 60, 95, 60));
//			list.push("Window.titleHAlign", null);
//			list.push("Window.titleVAlign", null);
//			list.push("Window.titleHGap", null);
//			list.push("Window.titleVGap", -10);
//			list.push("Window.closeHAlign", null);
//			list.push("Window.closeVAlign", null);
//			list.push("Window.closeHGap", 18);
//			list.push("Window.closeVGap", 20);
			
//			list.push("Window.TitleBar.titleImg", WindowTitleBackground_Asset);
//			list.push("Window.TitleBar.titleImgInsets", null);
//			list.push("Window.TitleBar.titleScaleType", null);
//			list.push("Window.TitleBar.titleFont", null);
//			list.push("Window.TitleBar.titleColor", new ASColor(0xFFFFFF));
//			list.push("Window.TitleBar.textHAlign", null);
//			list.push("Window.TitleBar.textVAlign", null);
//			list.push("Window.TitleBar.textHGap", null);
//			list.push("Window.TitleBar.textVGap", null);
			
//			list.push("Window.CloseButton.upImg", CloseUp_Asset);
//			list.push("Window.CloseButton.overImg", CloseOver_Asset);
//			list.push("Window.CloseButton.downImg", CloseDown_Asset);
//			list.push("Window.CloseButton.disabledImg", null);
//			list.push("Window.CloseButton.upFilters", null);
//			list.push("Window.CloseButton.overFilters", null);
//			list.push("Window.CloseButton.downFilters", null);
//			list.push("Window.CloseButton.disabledFilters", null);
			
			
			
			
			
			
			
			
			
			
			
			list.push("Frame.bg", ImageBackGround);
//			list.push("Frame.bgImg", WindowBackground_Asset);
//			list.push("Frame.bgInsets", new Insets(53, 60, 95, 60));
//			list.push("Frame.titleHAlign", null);
//			list.push("Frame.titleVAlign", null);
//			list.push("Frame.titleHGap", null);
//			list.push("Frame.titleVGap", -10);
//			list.push("Frame.closeHAlign", null);
//			list.push("Frame.closeVAlign", null);
//			list.push("Frame.closeHGap", 18);
//			list.push("Frame.closeVGap", 20);
			
//			list.push("Frame.TitleBar.titleImg", WindowTitleBackground_Asset);
//			list.push("Frame.TitleBar.titleImgInsets", null);
//			list.push("Frame.TitleBar.titleScaleType", null);
//			list.push("Frame.TitleBar.titleFont", null);
//			list.push("Frame.TitleBar.titleColor", new ASColor(0xFFFFFF));
//			list.push("Frame.TitleBar.textHAlign", null);
//			list.push("Frame.TitleBar.textVAlign", null);
//			list.push("Frame.TitleBar.textHGap", null);
//			list.push("Frame.TitleBar.textVGap", null);
			
//			list.push("Frame.CloseButton.upImg", CloseUp_Asset);
//			list.push("Frame.CloseButton.overImg", CloseOver_Asset);
//			list.push("Frame.CloseButton.downImg", CloseDown_Asset);
//			list.push("Frame.CloseButton.disabledImg", null);
//			list.push("Frame.CloseButton.upFilters", null);
//			list.push("Frame.CloseButton.overFilters", null);
//			list.push("Frame.CloseButton.downFilters", null);
//			list.push("Frame.CloseButton.disabledFilters", null);
			
			
			
			
			
			
			
			
			
			
//			list.push("VScrollBar.hDirHGap", null);
//			list.push("VScrollBar.hDirVGap", null);
//			
//			list.push("VScrollBar.vDirHGap", null);
//			list.push("VScrollBar.vDirVGap", null);
//			
//			list.push("VScrollBar.vThumbHGap", null);
//			list.push("VScrollBar.vThumbVGap", null);
//			
//			list.push("VScrollBar.delay", null);
//			list.push("VScrollBar.step", null);
			
			list.push("VScrollBar.bg", ImageBackGround);
//			list.push("VScrollBar.bgImg", VScrollBarBackground_Asset);
//			list.push("VScrollBar.bgInsets", new Insets(0, 1, 0, 1));
			
			list.push("VScrollBar.TopButton.bg", ButtonScaleImageBackground);
//			list.push("VScrollBar.TopButton.upImg", VScrollBarUpBtnUpImg_Asset);
//			list.push("VScrollBar.TopButton.overImg", VScrollBarUpBtnOverImg_Asset);
//			list.push("VScrollBar.TopButton.downImg", VScrollBarUpBtnDownImg_Asset);
//			list.push("VScrollBar.TopButton.disabledImg", ScrollBarBtnDisabledImg_Asset);
//			list.push("VScrollBar.TopButton.upInsets", null);
//			list.push("VScrollBar.TopButton.overInsets", null);
//			list.push("VScrollBar.TopButton.downInsets", null);
//			list.push("VScrollBar.TopButton.disabledInsets", null);
//			list.push("VScrollBar.TopButton.upFilters", null);
//			list.push("VScrollBar.TopButton.overFilters", null);
//			list.push("VScrollBar.TopButton.downFilters", null);
//			list.push("VScrollBar.TopButton.disabledFilters", null);
			
			list.push("VScrollBar.BottomButton.bg", ButtonScaleImageBackground);
//			list.push("VScrollBar.BottomButton.upImg", VScrollBarBottomBtnUpImg_Asset);
//			list.push("VScrollBar.BottomButton.overImg", VScrollBarBottomBtnOverImg_Asset);
//			list.push("VScrollBar.BottomButton.downImg", VScrollBarBottomBtnDownImg_Asset);
//			list.push("VScrollBar.BottomButton.disabledImg", ScrollBarBtnDisabledImg_Asset);
//			list.push("VScrollBar.BottomButton.upInsets", null);
//			list.push("VScrollBar.BottomButton.overInsets", null);
//			list.push("VScrollBar.BottomButton.downInsets", null);
//			list.push("VScrollBar.BottomButton.disabledInsets", null);
//			list.push("VScrollBar.BottomButton.upFilters", null);
//			list.push("VScrollBar.BottomButton.overFilters", null);
//			list.push("VScrollBar.BottomButton.downFilters", null);
//			list.push("VScrollBar.BottomButton.disabledFilters", null);
			
			var thumbInsets:Insets = new Insets(5, 0, 5, 0);
			
			list.push("VScrollBar.Thumb.bg", ButtonScaleImageBackground);
//			list.push("VScrollBar.Thumb.upImg", VScrollBarThumbUpImg_Asset);
//			list.push("VScrollBar.Thumb.overImg", VScrollBarThumbOverImg_Asset);
//			list.push("VScrollBar.Thumb.downImg", VScrollBarThumbDownImg_Asset);
//			list.push("VScrollBar.Thumb.disabledImg", null);
//			list.push("VScrollBar.Thumb.upInsets", thumbInsets);
//			list.push("VScrollBar.Thumb.overInsets", thumbInsets);
//			list.push("VScrollBar.Thumb.downInsets", thumbInsets);
//			list.push("VScrollBar.Thumb.disabledInsets", null);
//			list.push("VScrollBar.BottomButton.upFilters", null);
//			list.push("VScrollBar.BottomButton.overFilters", null);
//			list.push("VScrollBar.BottomButton.downFilters", null);
//			list.push("VScrollBar.BottomButton.disabledFilters", null);
			
			
			
			
			
			
			
			
			
			
			
			
//			list.push("HScrollBar.hDirHGap", null);
//			list.push("HScrollBar.hDirVGap", null);
//			
//			list.push("HScrollBar.vDirHGap", null);
//			list.push("HScrollBar.vDirVGap", null);
//			
//			list.push("HScrollBar.hThumbHGap", null);
//			list.push("HScrollBar.hThumbVGap", null);
//			
//			list.push("HScrollBar.delay", null);
//			list.push("HScrollBar.step", null);
			
			list.push("HScrollBar.bg", ImageBackGround);
//			list.push("HScrollBar.bgImg", HScrollBarBackground_Asset);
//			list.push("HScrollBar.bgInsets", new Insets(1, 0, 1, 0));
			
			list.push("HScrollBar.LeftButton.bg", ButtonScaleImageBackground);
//			list.push("HScrollBar.LeftButton.upImg", HScrollBarLeftBtnUpImg_Asset);
//			list.push("HScrollBar.LeftButton.overImg", HScrollBarLeftBtnOverImg_Asset);
//			list.push("HScrollBar.LeftButton.downImg", HScrollBarLeftBtnDownImg_Asset);
//			list.push("HScrollBar.LeftButton.disabledImg", ScrollBarBtnDisabledImg_Asset);
//			list.push("HScrollBar.LeftButton.upInsets", null);
//			list.push("HScrollBar.LeftButton.overInsets", null);
//			list.push("HScrollBar.LeftButton.downInsets", null);
//			list.push("HScrollBar.LeftButton.disabledInsets", null);
//			list.push("HScrollBar.LeftButton.upFilters", null);
//			list.push("HScrollBar.LeftButton.overFilters", null);
//			list.push("HScrollBar.LeftButton.downFilters", null);
//			list.push("HScrollBar.LeftButton.disabledFilters", null);
			
			list.push("HScrollBar.RightButton.bg", ButtonScaleImageBackground);
//			list.push("HScrollBar.RightButton.upImg", HScrollBarRightBtnUpImg_Asset);
//			list.push("HScrollBar.RightButton.overImg", HScrollBarRightBtnOverImg_Asset);
//			list.push("HScrollBar.RightButton.downImg", HScrollBarRightBtnDownImg_Asset);
//			list.push("HScrollBar.RightButton.disabledImg", ScrollBarBtnDisabledImg_Asset);
//			list.push("HScrollBar.RightButton.upInsets", null);
//			list.push("HScrollBar.RightButton.overInsets", null);
//			list.push("HScrollBar.RightButton.downInsets", null);
//			list.push("HScrollBar.RightButton.disabledInsets", null);
//			list.push("HScrollBar.RightButton.upFilters", null);
//			list.push("HScrollBar.RightButton.overFilters", null);
//			list.push("HScrollBar.RightButton.downFilters", null);
//			list.push("HScrollBar.RightButton.disabledFilters", null);
			
			thumbInsets = new Insets(0, 5, 0, 5);
			
			list.push("HScrollBar.Thumb.bg", ButtonScaleImageBackground);
//			list.push("HScrollBar.Thumb.upImg", HScrollBarThumbUpImg_Asset);
//			list.push("HScrollBar.Thumb.overImg", HScrollBarThumbOverImg_Asset);
//			list.push("HScrollBar.Thumb.downImg", HScrollBarThumbDownImg_Asset);
//			list.push("HScrollBar.Thumb.disabledImg", null);
//			list.push("HScrollBar.Thumb.upInsets", thumbInsets);
//			list.push("HScrollBar.Thumb.overInsets", thumbInsets);
//			list.push("HScrollBar.Thumb.downInsets", thumbInsets);
//			list.push("HScrollBar.Thumb.disabledInsets", null);
//			list.push("HScrollBar.Thumb.upFilters", null);
//			list.push("HScrollBar.Thumb.overFilters", null);
//			list.push("HScrollBar.Thumb.downFilters", null);
//			list.push("HScrollBar.Thumb.disabledFilters", null);
			
			
			
			
			
			
			
			
//			list.push("HSlider.step", null);
//			
//			list.push("HSlider.hThumbHGap", null);
//			list.push("HSlider.hThumbVGap", null);
			
			list.push("HSlider.bg", ImageBackGround);
//			list.push("HSlider.bgImg", HSliderBackgroundUpImg_Asset);
//			list.push("HSlider.bgInsets", new Insets(2, 3, 2, 3));
			
			list.push("HSlider.Thumb.bg", ButtonScaleImageBackground);
//			list.push("HSlider.Thumb.upImg", HSliderThumbUpImg_Asset);
//			list.push("HSlider.Thumb.overImg", HSliderThumbOverImg_Asset);
//			list.push("HSlider.Thumb.downImg", HSliderThumbDownImg_Asset);
//			list.push("HSlider.Thumb.disabledImg", HSliderThumbDisabledImg_Asset);
//			list.push("HScrollBar.Thumb.upInsets", null);
//			list.push("HScrollBar.Thumb.overInsets", null);
//			list.push("HScrollBar.Thumb.downInsets", null);
//			list.push("HScrollBar.Thumb.disabledInsets", null);
//			list.push("HSlider.Thumb.upFilters", null);
//			list.push("HSlider.Thumb.overFilters", null);
//			list.push("HSlider.Thumb.downFilters", null);
//			list.push("HSlider.Thumb.disabledFilters", null);
			
			
			
			
			
			
//			list.push("VSlider.step", null);
//			
//			list.push("VSlider.vThumbHGap", null);
//			list.push("VSlider.vThumbVGap", null);
			
			list.push("VSlider.bg", ImageBackGround);
//			list.push("VSlider.bgImg", VSliderThumbBackgroundUpImg_Asset);
//			list.push("VSlider.bgInsets", new Insets(2, 3, 2, 3));
			
			list.push("VSlider.Thumb.bg", ButtonScaleImageBackground);
//			list.push("VSlider.Thumb.upImg", VSliderThumbUpImg_Asset);
//			list.push("VSlider.Thumb.overImg", VSliderThumbOverImg_Asset);
//			list.push("VSlider.Thumb.downImg", VSliderThumbDownImg_Asset);
//			list.push("VSlider.Thumb.disabledImg", VSliderThumbDisabledImg_Asset);
//			list.push("VSlider.Thumb.upInsets", null);
//			list.push("VSlider.Thumb.overInsets", null);
//			list.push("VSlider.Thumb.downInsets", null);
//			list.push("VSlider.Thumb.disabledInsets", null);
//			list.push("VSlider.Thumb.upFilters", null);
//			list.push("VSlider.Thumb.overFilters", null);
//			list.push("VSlider.Thumb.downFilters", null);
//			list.push("VSlider.Thumb.disabledFilters", null);
		}
	}
}