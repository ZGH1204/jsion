package jcore.org.moduls
{
	import flash.utils.Dictionary;
	
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.DictionaryUtil;
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.StringUtil;

	public class ModuleMonitor
	{
		private static var loadedModuleDic:Dictionary = new Dictionary();
		
		/**
		 * 加载完成后创建对应模块(未安装)
		 * @param moduleInfo 模块信息
		 * 
		 */		
		public static function createModule(moduleInfo:ModuleInfo):DefaultModule
		{
			if(moduleInfo == null)
			{
				throw new ArgumentError("参数 moduleInfo 不能为空!");
				return null;
			}
			
			if(moduleInfo.isError || moduleInfo.isLoaded == false)
			{
				throw new Error("模块库文件未加载或加载失败，无法创建模块。 File: " + moduleInfo.file);
				return null;
			}
			
			var clsStr:String = moduleInfo.cls;
			
			if(StringUtil.isNullOrEmpty(clsStr)) return null;
			
			var cls:Class = AppDomainUtil.getClass(clsStr);
			
			if(cls == null)
			{
				throw new Error("模块类不存在，无法创建模块。 Class: " + clsStr);
				return null;
			}
			
			if(loadedModuleDic[moduleInfo.id])
			{
				throw new Error("模块已创建，不能重复创建模块。 Type：" + moduleInfo.id + "\t\tClass: " + clsStr);
				return null;
			}
			
			var module:DefaultModule;
			
			try
			{
				module = new cls(moduleInfo);
				
				module.reflection(moduleInfo.assembly);
				
				loadedModuleDic[moduleInfo.id] = module;
				
				return module;
			}
			catch(e:Error)
			{
				throw e;
				return null;
			}
			
			return null;
		}
		
		/**
		 * 移除模块
		 * @param moduleInfo 模块信息
		 * @return 移除的模块对象
		 * 
		 */		
		public static function removeModule(moduleInfo:ModuleInfo):DefaultModule
		{
			if(moduleInfo == null)
			{
				throw new ArgumentError("参数 moduleInfo 不能为空!");
				return null;
			}
			
			var delItem:DefaultModule = DictionaryUtil.delKey(loadedModuleDic, moduleInfo.id);
			
			DisposeUtil.free(delItem);
			
			return delItem;
		}
	}
}