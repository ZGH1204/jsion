package vo.loader
{
	import com.loader.XmlLoader;
	import com.serialize.xml.XmlCoder;
	import com.utils.ClassHelper;
	
	import vo.data.MenuConfig;
	import vo.data.MenuItemConfig;
	
	public class ConfigLoader extends XmlLoader
	{
		public var configList:Array;
		
		public function ConfigLoader(path:String)
		{
			super(path, false);
		}
		
		override protected function onComplete():void
		{
			packXmlData();
			
			configList = [];
			
			var coder:XmlCoder = new XmlCoder();
			
			var cl:XMLList = xmlData..config;
			
			for each(var xml:XML in cl)
			{
				var config:MenuConfig = new MenuConfig();
				
				config.id = String(xml.@id);
				config.file = String(xml.@file);
				config.enable = Boolean(String(xml.@enable).split("|")[0]);
				config.grey = Boolean(String(xml.@grey).split("|")[0]);
				
				config.logoCls = String(xml.logo.@cls);
				config.logoX = Number(xml.logo.@x);
				config.logoY = Number(xml.logo.@y);
				
				config.backgroundCls = String(xml.bg.@cls);
				config.backgroundX = Number(xml.bg.@x);
				config.backgroundY = Number(xml.bg.@y);
				
				config.itemStartX = Number(xml.items.@startX);
				config.itemStartY = Number(xml.items.@startY);
				config.itemWidth = Number(xml.items.@itemWidth);
				config.itemHeight = Number(xml.items.@itemHeight);
				config.itemCls = String(xml.items.@itemCls);
				config.splitCls = String(xml.items.@splitCls);
				config.overCls = String(xml.items.@overCls);
				config.downCls = String(xml.items.@downCls);
				config.direction = String(xml.items.@direction).split("|")[0];
				
				var itemList:XMLList = xml.items..item;
				for each(var item:XML in itemList)
				{
					var obj:Object = coder.decode(item);
					obj["fontBold"] = String(obj["fontBold"]).split("|")[0];
					obj["fontItalic"] = String(obj["fontItalic"]).split("|")[0];
					obj["fontUnderLine"] = String(obj["fontUnderLine"]).split("|")[0];
					obj["fontBold"] = String(obj["overBold"]).split("|")[0];
					obj["fontItalic"] = String(obj["overItalic"]).split("|")[0];
					obj["fontUnderLine"] = String(obj["overUnderLine"]).split("|")[0];
					var ic:MenuItemConfig = ClassHelper.createInstance(MenuItemConfig, obj);
					config.itemList.push(ic);
				}
				
				configList.push(config);
			}
			
			
			super.onComplete();
		}
		
		override protected function onIOError():void
		{
			throw new Error("找不到配置文件，或配置文件编码方式不是UTF8。");
		}
		
		override protected function onSecurityError():void
		{
			throw new Error("安全问题，请在本站内使用。");
		}
	}
}