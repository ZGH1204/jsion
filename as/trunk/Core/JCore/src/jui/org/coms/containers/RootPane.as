package jui.org.coms.containers
{
	import flash.display.InteractiveObject;
	
	import jui.org.Container;
	import jui.org.coms.buttons.Button;
	import jui.org.keyboard.KeyboardManager;
	
	public class RootPane extends Container
	{
		protected var defaultButton:Button;
		protected var mnemonics:HashMap;
		protected var mnemonicJustActed:Boolean;
		protected var keyManager:KeyboardManager;
		
		private var triggerProxy:InteractiveObject;
		
		public function RootPane()
		{
			super();
			setName("RootPane");
			mnemonicJustActed = false;
//			layout = new BorderLayout();
//			mnemonics = new HashMap();
//			keyManager = new KeyboardManager();
//			keyManager.init(this);
//			triggerProxy = this;//just make below call works
//			setMnemonicTriggerProxy(null);
//			addEventListener(Event.REMOVED_FROM_STAGE, __removedFromStage);
		}
	}
}