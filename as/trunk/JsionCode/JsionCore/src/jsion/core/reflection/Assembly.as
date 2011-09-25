package jsion.core.reflection
{
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import jsion.utils.*;

	public class Assembly extends EventDispatcher
	{
		public var clsList:Vector.<String>;
		protected var callback:Function;
		
		protected var typeList:Vector.<Type>;
		
		public function Assembly(clsList:Vector.<String> = null)
		{
			this.clsList = clsList;
			
			//typeList = getTypes();
		}
		
		internal function getIsImplInterface(interfaceStr:String):Type
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
			var list:Vector.<Type> = getTypes();
			
			for each(var type:Type in list)
			{
				if(type.getIsImplInterfaceByInterface(interfaceCls))
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function getIsFirstExtendsClass(cls:Class):Type
		{
			var list:Vector.<Type> = getTypes();
			
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			for each(var type:Type in list)
			{
				if(type.getIsFirstExtendsClassByString(clsPath))
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function getIsExtendsClass(cls:Class):Type
		{
			var list:Vector.<Type> = getTypes();
			
			var clsPath:String = ReflectionUtil.getClassPath(cls);
			
			for each(var type:Type in list)
			{
				if(type.getIsExtendsClassByString(clsPath))
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function getTypes():Vector.<Type>
		{
			if(typeList) return typeList;
			
			var tList:Vector.<Type> = new Vector.<Type>();
			for each(var item:String in clsList)
			{
				var type:Type = getType(item);
				if(type) tList.push(type);
			}
			typeList = tList;
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