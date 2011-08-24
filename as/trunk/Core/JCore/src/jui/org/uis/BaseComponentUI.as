package jui.org.uis
{
	import jui.org.Component;
	import jui.org.EmptyUIResources;
	import jui.org.Graphics2D;
	import jui.org.IBorder;
	import jui.org.ICanUpdateProvider;
	import jui.org.IComponentUI;
	import jui.org.Icon;
	import jui.org.JColor;
	import jui.org.JFont;
	import jui.org.StyleTune;
	import jui.org.UIDefaults;
	import jui.org.UIMgr;
	import jui.org.brushs.SolidBrush;
	import jui.org.errors.ImpMissError;
	
	import jutils.org.util.DisposeUtil;
	
	public class BaseComponentUI implements IComponentUI
	{
		protected var defaults:UIDefaults;
		
		public function BaseComponentUI()
		{
		}
		
		public function installUI(component:Component):void
		{
			throw new ImpMissError();
		}
		
		public function uninstallUI(component:Component):void
		{
			throw new ImpMissError();
		}
		
		public function refreshStyleProperties():void
		{
			
		}
		
		public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			paintBackGround(component, graphics, bound);
		}
		
		protected function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):void
		{
			if(c.isOpaque())
			{
				g.fillRect(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
			}
		}
		
		public function getPreferredSize(c:Component):IntDimension
		{
			return c.getPreferredSize();
		}
		
		public function getMinimumSize(c:Component):IntDimension
		{
			return c.getInsets().getOutsideSize();
		}
		
		public function getMaximumSize(c:Component):IntDimension
		{
			return IntDimension.createBigDimension();
		}
		
		
		
		
		
		
		
		
		public function putDefault(key:String, value:*):void
		{
			if(defaults == null)
			{
				defaults = new UIDefaults();
			}
			
			defaults.put(key, value);
		}
		
		public function containsDefaultsKey(key:String):Boolean
		{
			return containsKey(key);
		}
		
		public function containsKey(key:*):Boolean
		{
			return (defaults != null && defaults.containsKey(key));
		}
		
		public function getConstructor(key:String):Class
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getConstructor(key);
			}
			
			return UIMgr.getConstructor(key);
		}
		
		public function getInstance(key:String):*
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getInstance(key);
			}
			
			return UIMgr.getInstance(key);
		}
		
		public function getBoolean(key:String):Boolean
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getBoolean(key);
			}
			
			return UIMgr.getBoolean(key);
		}
		
		public function getNumber(key:String):Number
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getNumber(key);
			}
			
			return UIMgr.getNumber(key);
		}
		
		public function getInt(key:String):int
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getInt(key);
			}
			
			return UIMgr.getInt(key);
		}
		
		public function getUint(key:String):uint
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getUint(key);
			}
			
			return UIMgr.getUint(key);
		}
		
		public function getString(key:String):String
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getString(key);
			}
			
			return UIMgr.getString(key);
		}
		
		public function getUI(target:Component):IComponentUI
		{
			if(containsDefaultsKey(target.getUIClassID()))
			{
				return defaults.getUI(target);
			}
			
			return UIMgr.getUI(target);
		}
		
		public function getBorder(key:String):IBorder
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getBorder(key);
			}
			
			return UIMgr.getBorder(key);
		}
		
		public function getIcon(key:String):Icon
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getIcon(key);
			}
			
			return UIMgr.getIcon(key);
		}
		
		public function getCanUpdateProvider(key:String):ICanUpdateProvider
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getCanUpdateProvider(key);
			}
			
			return UIMgr.getCanUpdateProvider(key);
		}
		
		public function getColor(key:String):JColor
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getColor(key);
			}
			
			return UIMgr.getColor(key);
		}
		
		public function getFont(key:String):JFont
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getFont(key);
			}
			
			return UIMgr.getFont(key);
		}
		
		public function getInsets(key:String):Insets
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getInsets(key);
			}
			
			return UIMgr.getInsets(key);
		}
		
		public function getStyleTune(key:String):StyleTune
		{
			if(containsDefaultsKey(key))
			{
				return defaults.getStyleTune(key);
			}
			
			return UIMgr.getStyleTune(key);
		}
		
		
		
		
		
		public function dispose():void
		{
			DisposeUtil.free(defaults);
			defaults = null;
		}
	}
}