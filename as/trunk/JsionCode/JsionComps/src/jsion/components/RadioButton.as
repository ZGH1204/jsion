package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	public class RadioButton extends Component
	{
		public static const LEFT:String = CompGlobal.LEFT;
		public static const RIGHT:String = CompGlobal.RIGHT;
		public static const TOP:String = CompGlobal.TOP;
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		public static const PADDING:String = CompGlobal.PADDING;
		
		private var m_box:JToggleButton;
		
		private var m_label:JLabel;
		
		private var m_text:String;
		
		private var m_boxDir:String;
		
		private var m_group:ButtonGroup;
		
		public function RadioButton(label:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_text = label;
			
			m_boxDir = LEFT;
			
			super(container, xPos, yPos);
		}
		
		public function get group():ButtonGroup
		{
			return m_group;
		}
		
		public function set group(value:ButtonGroup):void
		{
			m_group = value;
		}
		
		public function get label():String
		{
			return m_text;
		}
		
		public function set label(value:String):void
		{
			if(m_text != value)
			{
				m_text = value;
				
				invalidate();
			}
		}
		
		public function get boxDir():String
		{
			return m_boxDir;
		}
		
		public function set boxDir(value:String):void
		{
			if(m_boxDir != value)
			{
				m_boxDir = value;
				
				invalidate();
			}
		}
		
		public function get selected():Boolean
		{
			return m_box.selected;
		}
		
		public function set selected(value:Boolean):void
		{
			m_box.selected = value;
		}
		
		override public function setStyle(key:String, value:*, freeBMD:Boolean=true):void
		{
			if(key == FONT || key == COLOR)
			{
				m_label.setStyle(key, value, freeBMD);
			}
			else
			{
				throw new Error("除了 font 和 color 使用此方法,其他请使用setUnCheckedStyle或setCheckedStyle方法.");
			}
		}
		
		public function setUnCheckedStyle(key:String, value:*, freeBMD:Boolean=true):void
		{
			m_box.setUnSelectedStyle(key, value, freeBMD);
		}
		
		public function setCheckedStyle(key:String, value:*, freeBMD:Boolean=true):void
		{
			m_box.setSelectedStyle(key, value, freeBMD);
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, __clickHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(m_group)
			{
				m_group.selected = this;
			}
			else
			{
				selected = !selected;
			}
		}
		
		override protected function addChildren():void
		{
			m_box = new JToggleButton();
			m_box.stopPropagation = true;
			addChild(m_box);
			
			m_label = new JLabel(m_text);
			addChild(m_label);
		}
		
		override public function draw():void
		{
			m_box.drawAtOnce();
			
			m_label.text = m_text;
			
			m_label.drawAtOnce();
			
			layout();
			
			super.draw();
		}
		
		private function layout():void
		{
			var w:int = Math.max(m_box.originalWidth, m_label.width);
			var h:int = Math.max(m_box.originalHeight, m_label.height);
			
			switch(m_boxDir)
			{
				case CompGlobal.LEFT:
					m_box.x = 0;
					m_label.x = m_box.x + m_box.originalWidth;
					m_label.x += getInt(PADDING);
					
					m_box.y = (h - m_box.originalHeight) / 2;
					m_label.y = (h - m_label.height) / 2;
					break;
				case CompGlobal.RIGHT:
					m_label.x = 0;
					m_box.x = m_label.x + m_label.width;
					m_box.x += getInt(PADDING);
					
					m_box.y = (h - m_box.originalHeight) / 2;
					m_label.y = (h - m_label.height) / 2;
					break;
				case CompGlobal.TOP:
					m_box.y = 0;
					m_label.y = m_box.y + m_box.originalHeight;
					m_label.y += getInt(PADDING);
					
					m_box.x = (w - m_box.originalWidth) / 2;
					m_label.x = (w - m_label.width) / 2;
					break;
				case CompGlobal.BOTTOM:
					m_label.y = 0;
					m_box.y = m_label.y + m_label.height;
					m_box.y += getInt(PADDING);
					
					m_box.x = (w - m_box.originalWidth) / 2;
					m_label.x = (w - m_label.width) / 2;
					break;
			}
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_box);
			m_box = null;
			
			DisposeUtil.free(m_label);
			m_label = null;
			
			m_group = null;
			
			super.dispose();
		}
	}
}