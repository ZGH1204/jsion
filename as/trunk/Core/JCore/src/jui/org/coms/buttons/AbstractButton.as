package jui.org.coms.buttons
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jui.org.Component;
	import jui.org.IButtonModel;
	import jui.org.IUIResource;
	import jui.org.Icon;
	import jui.org.UIConstants;
	import jui.org.defres.ArrayUIResource;
	import jui.org.defres.InsetsUIResource;
	import jui.org.events.InteractiveEvent;
	import jui.org.events.JEvent;
	import jui.org.events.ReleaseEvent;
	import jui.org.uis.buttons.SimpleButtonIconToggle;
	
	import jutils.org.util.StringUtil;
	
	public class AbstractButton extends Component
	{
		public static const CENTER:int  = UIConstants.CENTER;
		
		public static const TOP:int     = UIConstants.TOP;
		
		public static const LEFT:int    = UIConstants.LEFT;
		
		public static const BOTTOM:int  = UIConstants.BOTTOM;
		
		public static const RIGHT:int   = UIConstants.RIGHT;
		
		public static const HORIZONTAL:int = UIConstants.HORIZONTAL;
		
		public static const VERTICAL:int   = UIConstants.VERTICAL;
		
		
		
		protected var model:IButtonModel;
		
		private var text:String;
		private var displayText:String;
		
		private var mnemonic:int;
		private var mnemonicIndex:int;
		private var mnemonicEnabled:Boolean;
		private var margin:Insets;
		private var defaultMargin:Insets;
		
		// Button icons
		private var       defaultIcon:Icon;
		private var       pressedIcon:Icon;
		private var       disabledIcon:Icon;
		
		private var       selectedIcon:Icon;
		private var       disabledSelectedIcon:Icon;
		
		private var       rolloverIcon:Icon;
		private var       rolloverSelectedIcon:Icon;
		
		// Display properties
		private var    rolloverEnabled:Boolean;
		
		// Icon/Label Alignment
		private var        verticalAlignment:int;
		private var        horizontalAlignment:int;
		
		private var        verticalTextPosition:int;
		private var        horizontalTextPosition:int;
		
		private var        iconTextGap:int;	
		private var        shiftOffset:int = 0;
		private var        shiftOffsetSet:Boolean=false;
		
		private var        textFilters:Array;
		
		public function AbstractButton(text:String = "", icon:Icon = null)
		{
			super();
			setName("AbstractButton");
			
			rolloverEnabled = true;
			
			verticalAlignment = CENTER;
			horizontalAlignment = CENTER;
			verticalTextPosition = CENTER;
			horizontalTextPosition = CENTER;
			
			textFilters = new ArrayUIResource();
			
			iconTextGap = 2;
			mnemonicEnabled = true;
			this.text = text;
			this.analyzeMnemonic();
			this.defaultIcon = icon;
			//setText(text);
			//setIcon(icon);
			initSelfHandlers();
			updateUI();
			installIcon(defaultIcon);
		}
		
		public function getModel():IButtonModel
		{
			return model;
		}
		
		public function setModel(newModel:IButtonModel):void
		{
			var oldModel:IButtonModel = getModel();
			
			if (oldModel != null)
			{
				oldModel.removeActionListener(__modelActionListener);
				oldModel.removeStateListener(__modelStateListener);
				oldModel.removeSelectionListener(__modelSelectionListener);
			}
			
			model = newModel;
			
			if (newModel != null)
			{
				newModel.addActionListener(__modelActionListener);
				newModel.addStateListener(__modelStateListener);
				newModel.addSelectionListener(__modelSelectionListener);
			}
			
			if (newModel != oldModel)
			{
				revalidate();
				repaint();
			}
		}
		
		public function getText():String
		{
			return text;
		}
		
		public function setText(value:String):void
		{
			if(text != value)
			{
				text = value;
				analyzeMnemonic();
				repaint();
				invalidate();
			}
		}
		
		public function getDisplayText():String
		{
			return displayText;
		}
		
		public function getMnemonicIndex():int
		{
			return mnemonicIndex;
		}
		
		public function getMnemonic():int
		{
			return mnemonic;
		}
		
		public function getMargin():Insets
		{
			var m:Insets = margin;
			
			if(margin == null)
			{
				m = defaultMargin;
			}
			
			if(m == null)
			{
				return new InsetsUIResource();
			}
			else if(m is IUIResource)
			{//make it can be replaced by LAF
				return new InsetsUIResource(m.top, m.left, m.bottom, m.right);
			}
			else
			{
				return new Insets(m.top, m.left, m.bottom, m.right);
			}
		}
		
		public function setMargin(m:Insets):void
		{
			if(m is IUIResource)
			{
				defaultMargin = m;
			}
			
			if(m == null && defaultMargin != null)
			{
				m = defaultMargin;
			}
			
			var old:Insets = margin;
			margin = m;
			if(old == null || !m.equals(old))
			{
				revalidate();
				repaint();
			}
		}
		
		public function getIcon():Icon
		{
			return defaultIcon;
		}
		
		public function setIcon(ic:Icon):void
		{
			if(defaultIcon != ic)
			{
				if(defaultIcon)
				{
					uninstallIcon(defaultIcon);
				}
				
				defaultIcon = ic;
				
				installIcon(defaultIcon);
				
				repaint();
				invalidate();
			}
		}
		
		public function getPressedIcon():Icon
		{
			return pressedIcon;
		}
		
		public function setPressedIcon(ic:Icon):void
		{
			if(pressedIcon != ic)
			{
				if(pressedIcon)
				{
					uninstallIcon(pressedIcon);
				}
				
				pressedIcon = ic;
				
				installIcon(pressedIcon);
				repaint();
			}
		}
		
		public function getDisabledIcon():Icon
		{
			return disabledIcon;
		}
		
		public function setDisabledIcon(ic:Icon):void
		{
			if(disabledIcon != ic)
			{
				if(disabledIcon)
				{
					uninstallIcon(disabledIcon);
				}
				
				disabledIcon = ic;
				
				installIcon(disabledIcon);
				
				repaint();
			}
		}
		
		public function getSelectedIcon():Icon
		{
			return selectedIcon;
		}
		
		public function setSelectedIcon(ic:Icon):void
		{
			if(selectedIcon != ic)
			{
				if(selectedIcon)
				{
					uninstallIcon(selectedIcon);
				}
				
				selectedIcon = ic;
				installIcon(selectedIcon);
				repaint();
			}
		}
		
		public function getDisabledSelectedIcon():Icon
		{
			return disabledSelectedIcon;
		}
		
		public function setDisabledSelectedIcon(ic:Icon):void
		{
			if(disabledSelectedIcon != ic)
			{
				if(disabledSelectedIcon)
				{
					uninstallIcon(disabledSelectedIcon);
				}
				
				disabledSelectedIcon = ic;
				installIcon(disabledSelectedIcon);
				repaint();
			}
		}
		
		public function getRollOverIcon():Icon
		{
			return rolloverIcon;
		}
		
		public function setRollOverIcon(ic:Icon):void
		{
			if(rolloverIcon != ic)
			{
				if(rolloverIcon)
				{
					uninstallIcon(rolloverIcon);
				}
				
				rolloverIcon = ic;
				installIcon(rolloverIcon);
				repaint();
			}
		}
		
		public function getRollOverSelectedIcon():Icon
		{
			return rolloverSelectedIcon;
		}
		
		public function setRollOverSelectedIcon(ic:Icon):void
		{
			if(rolloverSelectedIcon != ic)
			{
				if(rolloverSelectedIcon)
				{
					uninstallIcon(rolloverSelectedIcon);
				}
				
				rolloverSelectedIcon = ic;
				installIcon(rolloverSelectedIcon);
				repaint();
			}
		}
		
		public function isRollOverEnabled():Boolean
		{
			return rolloverEnabled;
		}
		
		public function setRollOverEnabled(value:Boolean):void
		{
			if(rolloverEnabled != value)
			{
				rolloverEnabled = value;
				repaint();
			}
		}
		
		public function getVerticalAlignment():int
		{
			return verticalAlignment;
		}
		
		public function setVerticalAlignment(value:int):void
		{
			if(verticalAlignment != value)
			{
				verticalAlignment = value;
				repaint();
			}
		}
		
		public function getHorizontalAlignment():int
		{
			return horizontalAlignment;
		}
		
		public function setHorizontalAlignment(value:int):void
		{
			if(horizontalAlignment != value)
			{
				horizontalAlignment = value;
				repaint();
			}
		}
		
		public function getVerticalTextPosition():int
		{
			return verticalTextPosition;
		}
		
		public function setVerticalTextPosition(value:int):void
		{
			if(verticalTextPosition != value)
			{
				verticalTextPosition = value;
				repaint();
			}
		}
		
		public function getHorizontalTextPosition():int
		{
			return horizontalTextPosition;
		}
		
		public function setHorizontalTextPosition(value:int):void
		{
			if(horizontalTextPosition != value)
			{
				horizontalTextPosition = value;
				repaint();
			}
		}
		
		public function getIconTextGap():int
		{
			return iconTextGap;
		}
		
		public function setIconTextGap(value:int):void
		{
			if(iconTextGap != value)
			{
				iconTextGap = value;
				revalidate();
				repaint();
			}
		}
		
		public function getShiftOffset():int
		{
			return shiftOffset;
		}
		
		public function setShiftOffset(value:int):void
		{
			if (value != shiftOffset)
			{
				this.shiftOffset = value;
				setShiftOffsetSet(true);
				revalidate();
				repaint();
			}
		}
		
		public function isShiftOffsetSet():Boolean
		{
			return shiftOffsetSet;
		}
		
		public function setShiftOffsetSet(b:Boolean):void
		{
			shiftOffsetSet = b;
		}
		
		public function getTextFilters():Array
		{
			return textFilters;
		}
		
		public function setTextFilters(fs:Array):void
		{
			textFilters = fs;
			repaint();
		}
		
		protected function installIcon(icon:Icon):void
		{
			if(icon != null && icon.getDisplay(this) != null)
			{
				addChild(icon.getDisplay(this));
			}
		}
		
		protected function uninstallIcon(icon:Icon):void
		{
			var iconDis:DisplayObject = (icon == null ? null : icon.getDisplay(this));
			
			if(iconDis != null && isChild(iconDis))
			{
				removeChild(icon.getDisplay(this));
			}
		}
		
		private function analyzeMnemonic():void
		{
			displayText = text;
			mnemonic = -1;
			mnemonicIndex = -1;
			
			if(text == null)
			{
				return;
			}
			
			if(!mnemonicEnabled)
			{
				return;
			}
			
			var mi:int = text.indexOf("&");
			var mc:String = "";
			var found:Boolean = false;
			
			while(mi >= 0)
			{
				if((mi + 1) < text.length)
				{
					mc = text.charAt(mi + 1);
					
					if(StringUtil.isLetter(mc))
					{
						found = true;
						break;
					}
				}
				else
				{
					break;
				}
				
				mi = text.indexOf("&", mi + 1);
			}
			
			if(found)
			{
				displayText = text.substring(0, mi) + "[" + text.substring(mi + 1) + "]";
				mnemonic = mc.toUpperCase().charCodeAt(0);
				mnemonicIndex = mi;
			}
		}
		
		
		public function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(JEvent.ACT, listener, false, priority, useWeakReference);
		}
		
		public function removeActionListener(listener:Function):void{
			removeEventListener(JEvent.ACT, listener);
		}
		
		public function addSelectionListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
		}
		
		public function removeSelectionListener(listener:Function):void
		{
			removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
		}
		
		public function addStateListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
		}
		
		public function removeStateListener(listener:Function):void
		{
			removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
		}
		
		
		
		public function wrapSimpleButton(btn:SimpleButton):AbstractButton
		{
			setShiftOffset(0);
			setIcon(new SimpleButtonIconToggle(btn));
			setBorder(null);
			setMargin(new Insets());
			setBackgroundProvider(null);
			
			return this;
		}
		
		
		
		override public function setEnabled(b:Boolean):void
		{
			if (!b && model.isRollOver())
			{
				model.setRollOver(false);
			}
			
			super.setEnabled(b);
			
			model.setEnabled(b);
		}
		
		public function isSelected():Boolean
		{
			return model.isSelected();
		}
		
		public function setSelected(b:Boolean):void
		{
			model.setSelected(b);
		}
		
		
		
		
		private function initSelfHandlers():void
		{
			addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
			addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
			//addEventListener(MouseEvent.MOUSE_UP, __mouseUpListener);
			addEventListener(ReleaseEvent.RELEASE, __mouseReleaseListener);
			//addEventListener(Event.ADDED_TO_STAGE, __addedToStage);
			//addEventListener(Event.REMOVED_FROM_STAGE, __removedFromStage);
		}
		
		private function __addedToStage(e:Event):void
		{
			
		}
		
		private function __removedFromStage(e:Event):void
		{
			
		}
		
		private function __rollOutListener(e:MouseEvent):void
		{
			var m:IButtonModel = getModel();
			
			if(isRollOverEnabled())
			{
				if(!m.isPressed())
				{
					m.setRollOver(false);
				}
			}
			
			m.setArmed(false);
		}
		
		private function __rollOverListener(e:MouseEvent):void
		{
			var m:IButtonModel = getModel();
			
			if(isRollOverEnabled())
			{
				if(m.isPressed() || !e.buttonDown)
				{
					m.setRollOver(true);
				}
			}
			
			if(m.isPressed())
			{
				m.setArmed(true);
			}
		}
		
		private function __mouseDownListener(e:MouseEvent):void
		{
			getModel().setArmed(true);
			getModel().setPressed(true);
		}
		
		private function __mouseReleaseListener(e:ReleaseEvent):void
		{
			getModel().setPressed(false);
			getModel().setArmed(false);
			
			if(isRollOverEnabled() && !hitTestMouse())
			{
				getModel().setRollOver(false);
			}
		}
		
		private function __modelActionListener(e:JEvent):void
		{
			dispatchEvent(new JEvent(JEvent.ACT));
		}
		
		private function __modelStateListener(e:JEvent):void
		{
			dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
		}
		
		private function __modelSelectionListener(e:JEvent):void
		{
			dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED));
		}
	}
}