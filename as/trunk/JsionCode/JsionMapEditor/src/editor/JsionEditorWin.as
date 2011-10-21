package editor
{
	import flash.events.Event;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.ext.Form;
	
	public class JsionEditorWin extends JFrame
	{
		/**
		 * 属性窗的标题
		 */ 
		protected var mytitle:String;
		/**
		 * 表单容器
		 */ 
		protected var _box:Form;
		/**
		 * 间距
		 */ 
		protected var _padding:uint=5;
		/**
		 * 主程序的引用
		 */ 
		protected var _root:JsionMapEditor;
		
		public function JsionEditorWin(owner:JsionMapEditor=null)
		{
			_root = owner;
			
			super(_root.Window, mytitle);
			
			init();
		}
		
		protected function init():void
		{
			var bt_ok:JButton = new JButton('确认');
			var bt_cancle:JButton = new JButton('取消');
			
			bt_cancle.addActionListener(onCancle);
			bt_ok.addActionListener(onSubmit);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, _padding));
			jpanle.appendAll(bt_ok,bt_cancle);
			_box.append(jpanle);
			
			var w:Number = _box.width + _padding * 2;
			var h:Number = _box.height + _padding * 2;
			
			setSizeWH(w, h);
			
			setLocationXY((_root.Window.width - w) / 2, (_root.Window.height - h) / 2);
		}
		
		protected function onCancle(e:Event):void
		{
			closeReleased();
		}
		
		protected function onSubmit(e:Event):void
		{
			closeReleased();
		}
	}
}