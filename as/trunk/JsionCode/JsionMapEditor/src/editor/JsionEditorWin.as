package editor
{
	import flash.events.Event;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;
	
	public class JsionEditorWin extends JFrame
	{
		/**
		 * 间距
		 */ 
		protected static const Padding:uint=5;
		
		/**
		 * 属性窗的标题
		 */ 
		protected var mytitle:String;
		
		/**
		 * 主容器
		 */		
		protected var main:JPanel;
		
		/**
		 * 表单容器
		 */ 
		protected var box:Form;
		
		/**
		 * 主程序的引用
		 */ 
		protected var mapEditor:JsionMapEditor;
		
		/**
		 * 窗口宽度
		 */		
		protected var WinWidth:int;
		
		/**
		 * 窗口高度
		 */		
		protected var WinHeight:int;
		
		protected var bt_ok:JButton;
		protected var bt_cancle:JButton;
		
		public function JsionEditorWin(owner:JsionMapEditor, modal:Boolean = false)
		{
			mapEditor = owner;
			
			super(mapEditor.Window, mytitle, modal);
			
			init();
		}
		
		protected function init():void
		{
			setResizable(false);
			
			main.setSizeWH(WinWidth, WinHeight);
			
			bt_ok = new JButton('确认');
			bt_ok.setPreferredWidth(80);
			bt_cancle = new JButton('取消');
			bt_cancle.setPreferredWidth(80);
			
			bt_cancle.addActionListener(onCancle);
			bt_ok.addActionListener(onSubmit);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, Padding));
			jpanle.appendAll(bt_ok, bt_cancle);
			box.append(jpanle);
			
			var w:Number = main.width + Padding * 2;
			var h:Number = main.height + Padding * 2;
			
			setSizeWH(w, h);
			
			setLocationXY((mapEditor.Window.width - w) / 2, (mapEditor.Window.height - h) / 2);
			
			getContentPane().append(main);
			//JFrameTitleBar(titleBar).setPreferredHeight(42);
		}
		
		protected function initMain():void
		{
			main = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			
			box = new Form();
			
			main.append(new JPanel());
			main.append(box);
		}
		
		protected function onCancle(e:Event):void
		{
			closeReleased();
		}
		
		protected function onSubmit(e:Event):void
		{
			closeReleased();
		}
		
		override public function dispose():void
		{
			main = null;
			
			box = null;
			
			mapEditor = null;
			
			bt_ok = null;
			
			bt_cancle = null;
			
			super.dispose();
		}
	}
}