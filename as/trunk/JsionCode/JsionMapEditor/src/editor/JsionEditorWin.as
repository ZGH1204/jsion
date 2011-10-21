package editor
{
	import flash.events.Event;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JFrameTitleBar;
	import org.aswing.JPanel;
	import org.aswing.ext.Form;
	
	public class JsionEditorWin extends JFrame
	{
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
		 * 间距
		 */ 
		protected var padding:uint=5;
		/**
		 * 主程序的引用
		 */ 
		protected var mapEditor:JsionMapEditor;
		
		public function JsionEditorWin(owner:JsionMapEditor, modal:Boolean = false)
		{
			mapEditor = owner;
			
			super(mapEditor.Window, mytitle, modal);
			
			init();
		}
		
		protected function init():void
		{
			setResizable(false);
			
			var bt_ok:JButton = new JButton('确认');
			bt_ok.setPreferredWidth(80);
			var bt_cancle:JButton = new JButton('取消');
			bt_cancle.setPreferredWidth(80);
			
			bt_cancle.addActionListener(onCancle);
			bt_ok.addActionListener(onSubmit);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, padding));
			jpanle.appendAll(bt_ok, bt_cancle);
			box.append(jpanle);
			
			var w:Number = main.width + padding * 2;
			var h:Number = main.height + padding * 2;
			
			setSizeWH(w, h);
			
			setLocationXY((mapEditor.Window.width - w) / 2, (mapEditor.Window.height - h) / 2);
			
			getContentPane().append(main);
			//JFrameTitleBar(titleBar).setPreferredHeight(42);
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
			
			super.dispose();
		}
	}
}