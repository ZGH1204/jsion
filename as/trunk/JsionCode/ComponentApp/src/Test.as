/**
 * RichTextField 2 Demo
 * @author Alex.li - www.riaidea.com
 * @homepage http://code.google.com/p/richtextfield/
 */

package
{
	import fl.controls.Button;
	import fl.controls.UIScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import jsion.chat.RichTextField;
	import jsion.chat.plugins.ShortcutPlugin;
	
	
	[SWF(width = 500, height = 500, frameRate = 24, backgroundColor = 0x333333)]
	public class Test extends Sprite 
	{
		private var _output:RichTextField;
		private var _input:RichTextField;
		private var _sendBtn:Button;
		private var _smileyContainer:Sprite;
		private var _outputBorder:Shape;
		private var _inputBorder:Shape;
		private var _outputScrollBar:UIScrollBar;
		private var _inputScrollBar:UIScrollBar;
		private var _timer:Timer;
		
		private var _smileys:Array = [jAcid_smiley, jCool_smiley, 
									  jEyelash_smiley, jGawp_smiley, jGrin_smiley, 
									  jHmm_smiley, jHuh_smiley, jKiss_smiley, 
									  jLaugh_smiley, jSad_smiley, jShocked_smiley, 
									  jUnhappy_smiley, jWhat_smiley, jWink_smiley, 
									  jXiaoYu_smiley];
		
		public function Test():void 
		{
			init();
		}
		
		private function init(e:Event = null):void 
		{
			stage.scaleMode = "noScale";
			stage.align = "topLeft";
			
			//text format
			var titleFormat:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);	
			var txtFormat:TextFormat = new TextFormat("Courier New", 12, 0xFFFFFF, false, false, false);	
			
			//main title
			var title:TextField = new TextField();
			title.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFF00, true);
			title.selectable = false;
			title.htmlText = "RichTextField (2.0) Demo";
			title.x = 10;
			title.y = 10;
			title.width = 200;
			addChild(title);
			
			//output title
			var output_title:TextField = new TextField();
			output_title.defaultTextFormat = titleFormat;
			output_title.selectable = false;
			output_title.text = "输出:";
			output_title.x = 10;
			output_title.y = 40;
			addChild(output_title);			
			
			//output border
			var outputBorder:Shape = new Shape();
			outputBorder.graphics.lineStyle(1, 0x666666);
			outputBorder.graphics.drawRect(10, output_title.y + 20, stage.stageWidth - 24, 200);
			addChild(outputBorder);
			_outputBorder = outputBorder;
			
			//output rtf
			_output = new RichTextField();
			_output.x = 10;
			_output.y = output_title.y + 20;
			_output.setSize(stage.stageWidth - 40, 200);			
			_output.type = RichTextField.DYNAMIC;
			_output.defaultTextFormat = txtFormat;
			_output.autoScroll = true;
			_output.name = "output";
			addChild(_output);
			
			//some text for demo
			_output.html = true;			
			_output.append('<p>欢迎进入RichTextField演示程序!</p><br>', [ { index: 4, src:_smileys[0] }, { index: 17, src:_smileys[0] } ]);
			_output.append('本程序具有以下功能：');
			_output.append('* 在文本末尾追加文本和显示元素 <font color="#FFFF00">(append方法)</font>', [ { index:17, src:_smileys[1] } ]);
			_output.append('* 在文本任何位置替换(删除)文本和显示元素 <font color="#FFFF00">(replace方法)</font>', [ { index:15, src:_smileys[2] } ]);
			_output.append('* 支持<a href="http://en.wikipedia.org/wiki/HTML" target="_blank"><u><i>HTML文本</i></u></a> <font color="#FFFF00">(html属性)</font>', [ { index:5, src:_smileys[3] } ]);
			_output.append('* 动态改变文本框尺寸 <font color="#FFFF00">(setSize方法)</font>', [ { index:13, src:_smileys[3] }, { index:-1, src:_smileys[3] } ]);
			_output.append('* 导入和导出XML格式的文本框内容 <font color="#FFFF00">(importXML和exportXML方法)</font>', [ { index:3, src:_smileys[5] } ]);
			_output.append('<br>');
			_output.append('欢迎测试和提交bug！', [ { index:0, src:_smileys[4] }, { index:0, src:_smileys[4] }, { index:11, src:_smileys[4] }, { index:11, src:_smileys[4] } ] );
			
			//output scrollbar
			_outputScrollBar = getUIScrollBar();
			_outputScrollBar.scrollTarget = _output.textfield;
			_outputScrollBar.x = _output.x + _output.width;
			_outputScrollBar.y = _output.y;
			_outputScrollBar.height = _output.viewHeight;
			addChild(_outputScrollBar);
			
			//input title
			var input_title:TextField = new TextField();				
			input_title.defaultTextFormat = titleFormat;
			input_title.selectable = false;
			input_title.text = "输入:";
			input_title.x = 10;
			input_title.y = _output.y + _output.viewHeight + 20;
			addChild(input_title);
			
			//output border
			var inputBorder:Shape = new Shape();
			inputBorder.graphics.lineStyle(1, 0x666666);
			inputBorder.graphics.drawRect(10, input_title.y + 20, stage.stageWidth - 24, 100);
			addChild(inputBorder);
			_inputBorder = inputBorder;
			
			//input rtf			
			_input = new RichTextField();			
			_input.x = 10;
			_input.y = input_title.y + 20;
			_input.setSize(stage.stageWidth - 40, 100);
			_input.type = RichTextField.INPUT;
			_input.defaultTextFormat = txtFormat;
			_input.name = "input";
			_input.textfield.wordWrap = false;
			_input.textfield.multiline = false;
			addChild(_input);
			
			//predefine text
			_input.html = false;
			_input.append("你好，welcome", [ { index:2, src:_smileys[1] }, { index:15, src:_smileys[5] }, { src:_smileys[6] } ]);	
			_input.replace(4, 11, "欢迎", [ { src:_smileys[4] } ]);
			var tf:TextField = new TextField();
			tf.type = TextFieldType.DYNAMIC;
			tf.defaultTextFormat = new TextFormat(null, null, null, null, null, true);
			tf.htmlText = "<a href='event:1|123|54'>sdfsdf</a>";
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = 0x336699;
			tf.addEventListener(TextEvent.LINK, __linkHandler);
			_input.insertSprite(tf);
			_input.caretIndex = _input.contentLength;
			
			var tXml:XML = _input.exportXML();
			
			//_input.clear();
			
			//_input.importXML(tXml);
			
			trace(tXml);
			
			//input scrollbar
			_inputScrollBar = getUIScrollBar();
			_inputScrollBar.scrollTarget = _input.textfield;
			_inputScrollBar.x = _input.x + _input.width;
			_inputScrollBar.y = _input.y;
			_inputScrollBar.height = _input.viewHeight;
			addChild(_inputScrollBar);
			
			//add smileys
			_smileyContainer = new Sprite();
			addChild(_smileyContainer);
			_smileyContainer.x = 25;
			_smileyContainer.y = _input.y + _input.viewHeight + 20;
			createSmileys();
			
			//send button
			_sendBtn = getButton();
			addChild(_sendBtn);
			_sendBtn.x = _input.x + _input.width - _sendBtn.width;
			_sendBtn.y = _smileyContainer.y;
			_sendBtn.label = "发送";
			_sendBtn.addEventListener(MouseEvent.CLICK, sendMessage);
			
			//correct focus
			stage.focus = _input.textfield;	
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);					
			stage.addEventListener(Event.RESIZE, onResize);
			
			//shortcut plugin
			var splugin:ShortcutPlugin = new ShortcutPlugin();			
			var shortcuts:Array = [ { shortcut:"/a", src:_smileys[0] },
									{ shortcut:"/b", src:_smileys[1] },
									{ shortcut:"/c", src:_smileys[2] },
									{ shortcut:"/d", src:_smileys[3] },
									{ shortcut:"/e", src:_smileys[4] },
									{ shortcut:"/f", src:_smileys[5] },
									{ shortcut:"/g", src:_smileys[6] },
									{ shortcut:"/h", src:_smileys[7] },
									{ shortcut:"/i", src:_smileys[8] } ];
			splugin.addShortcut(shortcuts);
			_input.addPlugin(splugin);
			
			//startRobotMessage();
		}
		
		private function __linkHandler(e:TextEvent):void
		{
			trace(e.text);
		}
		
		private function startRobotMessage():void
		{
			var timer:Timer = new Timer(3 * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			_timer = timer;
		}
		
		private function pauseRobotMessage():void
		{
			if (_timer.running) _timer.stop();
			else _timer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			sendMessage();
		}
		
		private function onResize(e:Event):void 
		{
			_output.setSize(stage.stageWidth - 40, 200);
			_input.setSize(stage.stageWidth - 40, 100);
			_outputScrollBar.x = _output.x + _output.viewWidth;
			_outputScrollBar.update();
			_inputScrollBar.x = _input.x + _input.viewWidth;
			_inputScrollBar.update();
			
			_outputBorder.graphics.clear();
			_outputBorder.graphics.lineStyle(1, 0x666666);
			_outputBorder.graphics.drawRect(10, _output.y, stage.stageWidth - 24, 200);
			_inputBorder.graphics.clear();
			_inputBorder.graphics.lineStyle(1, 0x666666);
			_inputBorder.graphics.drawRect(10, _input.y, stage.stageWidth - 24, 100);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{			
			if (evt.keyCode == Keyboard.ENTER && _input.contentLength > 0)
			{				
				//sendMessage();
			}
		}
		
		private function sendMessage(evt:MouseEvent = null):void
		{
			_output.importXML(_input.exportXML());
			_outputScrollBar.update();
		}
		
		private function insertSmiley(evt:MouseEvent):void
		{
			var smiley:Sprite = evt.currentTarget as Sprite;
			var smileyClass:Class = getDefinitionByName(getQualifiedClassName(smiley)) as Class;
			_input.insertSprite(smileyClass, _input.textfield.caretIndex);					
			_inputScrollBar.update();
			
			//correct caretIndex of input
			if (_input.isSpriteAt(_input.caretIndex))
			{				
				_input.caretIndex++;
			}
		}
		
		private function createSmileys():void
		{
			for (var i:int = 0; i < _smileys.length; i++)
			{
				var smiley:Sprite = new _smileys[i]() as Sprite;
				_smileyContainer.addChild(smiley);
				smiley.x = (i % 8) * 35;
				smiley.y = Math.floor(i / 8) * 30;
				smiley.buttonMode = true;
				smiley.addEventListener(MouseEvent.CLICK, insertSmiley);			
			}
		}
		
		private function getButton():Button
		{
			var btn:Button = new Button();
			btn.setStyle("upSkin", Button_upSkin);
			btn.setStyle("overSkin", Button_overSkin);
			btn.setStyle("downSkin", Button_downSkin);
			btn.setStyle("disabledSkin", Button_disabledSkin);
			btn.setStyle("textFormat", new TextFormat("Arial", 12, 0xFFFFFF));
			return btn;
		}
		
		private function getUIScrollBar():UIScrollBar
		{
			var scrollBar:UIScrollBar = new UIScrollBar();
			scrollBar.setStyle("trackUpSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackOverSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackDownSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackDisabledSkin", ScrollBars_trackSkin);			
			scrollBar.setStyle("thumbUpSkin", ScrollBars_thumbUpSkin);
			scrollBar.setStyle("thumbOverSkin", ScrollBars_thumbOverSkin);
			scrollBar.setStyle("thumbDownSkin", ScrollBars_thumbDownSkin);
			scrollBar.setStyle("thumbIcon", ScrollBars_thumbIcon);			
			scrollBar.setStyle("downArrowUpSkin", ScrollBars_downArrowUpSkin);
			scrollBar.setStyle("downArrowOverSkin", ScrollBars_downArrowOverSkin);
			scrollBar.setStyle("downArrowDownSkin", ScrollBars_downArrowDownSkin);
			scrollBar.setStyle("downArrowDisabledSkin", ScrollBars_downArrowDisabledSkin);
			scrollBar.setStyle("upArrowUpSkin", ScrollBars_upArrowUpSkin);
			scrollBar.setStyle("upArrowOverSkin", ScrollBars_upArrowOverSkin);
			scrollBar.setStyle("upArrowDownSkin", ScrollBars_upArrowDownSkin);
			scrollBar.setStyle("upArrowDisabledSkin", ScrollBars_upArrowDisabledSkin);
			return scrollBar;
		}
	}
}