package jsion.core.reflection
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import jsion.utils.*;

	/**
	 * 类库程序集
	 * @author Jsion
	 * 
	 */	
	public class Assembly
	{
		public var clsList:Array;
		
		/** @private */
		protected var callback:Function;
		
		/** @private */
		protected var typeList:Vector.<Type>;
		
		public function Assembly(clsList:Array = null)
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
		
		public function getTypesByInterface(iCls:Class):Vector.<Type>
		{
			var tList:Vector.<Type> = new Vector.<Type>();
			
			var str:String = ReflectionUtil.getClassPath(iCls);
			
			for each(var clsPath:String in clsList)
			{
				var cls:Class = AppDomainUtil.getClass(clsPath);
				if(cls == null) continue;
				var type:Type = ReflectionUtil.parseTypeWithInterface(describeType(cls));
				
				if(type && type.interfaces.indexOf(str) != -1)
					tList.push(type);
			}
			
			return tList;
		}
		
		public function getTypesByMetaData(meta:String):Vector.<Type>
		{
			var tList:Vector.<Type> = new Vector.<Type>();
			
			for each(var clsPath:String in clsList)
			{
				var cls:Class = AppDomainUtil.getClass(clsPath);
				if(cls == null) continue;
				var type:Type = ReflectionUtil.parseTypeWithMetaData(describeType(cls));
				
				if(type && type.getCustomMetadatas(meta))
					tList.push(type);
			}
			
			return tList;
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