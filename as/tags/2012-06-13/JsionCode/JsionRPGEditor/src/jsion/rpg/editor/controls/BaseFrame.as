package jsion.rpg.editor.controls
{
	import flash.events.Event;
	
	import jsion.*;
	import jsion.rpg.editor.EditorGlobal;
	import jsion.utils.DisposeUtil;
	
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	
	public class BaseFrame extends JFrame implements IDispose
	{
		protected var m_title:String;
		
		protected var m_modal:Boolean;
		
		protected var m_screenCenter:Boolean;
		
		protected var m_frameWidth:int;
		
		protected var m_frameHeight:int;
		
		protected var bt_ok:JButton;
		protected var bt_cancle:JButton;
		protected var m_container:JPanel;
		
		public function BaseFrame()
		{
			configFrame();
			
			super(EditorGlobal.mainEditor, m_title, m_modal);
			
			m_container = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 0));
			m_container.append(new JPanel());
			getContentPane().append(m_container);
			
			setSizeWH(m_frameWidth, m_frameHeight);
			
			initialize();
			
			setResizable(false);
			
			if(m_screenCenter)
			{
				setLocationXY((EditorGlobal.mainEditor.width - m_frameWidth) / 2,
					(EditorGlobal.mainEditor.height - m_frameHeight) / 2);
			}
		}
		
		protected function configFrame():void
		{
			m_title = "窗口基类";
			m_modal = true;
			m_screenCenter = true;
			m_frameWidth = 200;
			m_frameHeight = 110;
		}
		
		protected function initialize():void
		{
		}
		
		protected function createOKAndCancelBtn():void
		{
			bt_ok = new JButton("确定");
			bt_ok.setPreferredWidth(80);
			bt_ok.addActionListener(onSubmit);
			
			bt_cancle = new JButton("取消");
			bt_cancle.setPreferredWidth(80);
			bt_cancle.addActionListener(onCancle);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, 5));
			jpanle.appendAll(bt_ok, bt_cancle);
			m_container.append(jpanle);
		}
		
		protected function createOKBtn():void
		{
			bt_ok = new JButton("确定");
			bt_ok.setPreferredWidth(80);
			
			bt_ok.addActionListener(onSubmit);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 5));
			jpanle.append(bt_ok);
			m_container.append(jpanle);
		}
		
		protected function onCancle(e:Event):void
		{
			closeReleased();
		}
		
		protected function onSubmit(e:Event):void
		{
			closeReleased();
		}
		
		override public function closeReleased():void
		{
			super.closeReleased();
			
			DisposeUtil.free(this);
		}
		
		override public function dispose():void
		{
			bt_ok = null;
			bt_cancle = null;
			m_container = null;
			
			super.dispose();
		}
	}
}