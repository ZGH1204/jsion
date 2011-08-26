package jutils.org.reflection
{
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.ReflectionUtil;

	public class Assembly extends EventDispatcher
	{
		public var clsList:Vector.<String>;
		protected var callback:Function;
		
		public function Assembly(clsList:Vector.<String> = null)
		{
			this.clsList = clsList;
		}
		
		public function getIsImplInterface(interfaceStr:String):Type
		{
			var list:Vector.<Type> = getTypes();
			
			for each(var type:Type in list)
			{
				if(type.getIsImplInterface(interfaceStr))
				{
					return type;
				}
			}
			
			list = null;
			
			return null;
		}
		
		public function getIsImplInterfaceByInterface(interfaceCls:Class):Type
		{
			var clsPath:String = ReflectionUtil.getClassPath(interfaceCls);
			var list:Vector.<Type> = getTypes();
			
			for each(var type:Type in list)
			{
				if(type.getIsImplInterface(clsPath))
				{
					return type;
				}
			}
			
			list = null;
			
			return null;
		}
		
		public function getTypes():Vector.<Type>
		{
			var tList:Vector.<Type> = new Vector.<Type>();
			for each(var item:String in clsList)
			{
				var type:Type = getType(item);
				if(type) tList.push(type);
			}
			return tList;
		}
		
		public function getTypeByObject(obj:Object):Type
		{
			var cls:String = getQualifiedClassName(obj);
			
			return getType(cls);
		}
		
		public function getType(clsPath:String):Type
		{
			try
			{
				var cls:Class = AppDomainUtil.getClass(clsPath);
				var type:Type = ReflectionUtil.parseType(describeType(cls));
				return type;
			}
			catch(e:Error)
			{
			}
			return null;
		}
		
		public function createInstanceByType(type:Type):*
		{
			var cls:Class = AppDomainUtil.getClass(type.name);
			return new cls();
		}
		
		public function createInstance(clsPath:String):*
		{
			var cls:Class = AppDomainUtil.getClass(clsPath);
			return new cls();
		}
	}
}