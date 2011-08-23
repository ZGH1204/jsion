package jui.org
{
	public class UIDefaults extends HashMap
	{
		public function UIDefaults()
		{
			super();
		}
		
		public function putDefaults(keyValueList:Array):void
		{
			for(var i:Number = 0; i < keyValueList.length; i += 2)
			{
				put(keyValueList[i], keyValueList[i + 1]);
			}
		}
		
		public function containsDefaultsKey(key:String):Boolean
		{
			return this.containsKey(key);
		}
		
		public function getConstructor(key:String):Class
		{
			return this.get(key) as Class;
		}
		
		public function getInstance(key:String):*
		{
			var value:* = get(key);
			
			if(value is Class)
			{
				return getCreateInstance(value);
			}
			else
			{
				return value;
			}
		}
		
		private function getCreateInstance(constructor:Class):Object
		{
			return new constructor();
		}
		
		public function getBoolean(key:String):Boolean
		{
			return (this.get(key) == true);
		}
		
		public function getNumber(key:String):Number
		{
			return this.get(key) as Number;
		}
		
		public function getInt(key:String):int
		{
			return this.get(key) as int;
		}
		
		public function getUint(key:String):uint
		{
			return this.get(key) as uint;
		}
		
		public function getString(key:String):String
		{
			return this.get(key) as String;
		}
		
		public function getUI(target:Component):IComponentUI
		{
			var ui:IComponentUI = getInstance(target.getUIClassID()) as IComponentUI;
			if(ui == null){
				ui = getCreateInstance(target.getDefaultBasicUIClass()) as IComponentUI;
			}
			return ui;
		}
		
		public function getBorder(key:String):IBorder
		{
			var border:IBorder = getInstance(key) as IBorder;
			
			if(border == null)
			{
				border = EmptyUIResources.BORDER; //make it to be an ui resource then can override by next LAF
			}
			
			return border;
		}
		
		public function getIcon(key:String):Icon
		{
			var icon:Icon = getInstance(key) as Icon;
			
			if(icon == null)
			{
				icon = EmptyUIResources.ICON; //make it to be ui resource property then can override by next LAF
			}
			
			return icon;
		}
		
		public function getCanUpdateProvider(key:String):ICanUpdateProvider
		{
			var dec:ICanUpdateProvider = getInstance(key) as ICanUpdateProvider;
			
			if(dec == null)
			{
				dec = EmptyUIResources.CANUPDATEPROVIDER; //make it to be ui resource property then can override by next LAF
			}
			
			return dec;
		}
		
		public function getColor(key:String):JColor
		{
			var color:JColor = getInstance(key) as JColor;
			
			if(color == null)
			{
				color = EmptyUIResources.COLOR; //make it to be an ui resource then can override by next LAF
			}
			
			return color;
		}
		
		public function getFont(key:String):JFont
		{
			var font:JFont = getInstance(key) as JFont;
			
			if(font == null)
			{
				font = EmptyUIResources.FONT; //make it to be an ui resource then can override by next LAF
			}
			
			return font;
		}
		
		public function getInsets(key:String):Insets
		{
			var i:Insets = getInstance(key) as Insets;
			
			if(i == null)
			{
				i = EmptyUIResources.INSETS; //make it to be an ui resource then can override by next LAF
			}
			
			return i;
		}
		
		public function getStyleTune(key:String):StyleTune
		{
			var i:StyleTune = getInstance(key) as StyleTune;
			
			if(i == null)
			{
				i = EmptyUIResources.STYLE_TUNE; //make it to be an ui resource then can override by next LAF
			}
			
			return i;
		}
	}
}