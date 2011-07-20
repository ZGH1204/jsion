package jutils.org.util
{
	import flash.net.*;
	import flash.utils.*;
	
	/**
	 * 对象工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class ObjectUtil
	{
		/**
		 * 深度复制对象,无法复制显示对象.
		 * @param source 要复制的对象
		 * @return 复制后的新对象
		 * 
		 */		
		public static function deepClone(source:*):*
		{
			var typeName:String = getQualifiedClassName(source);
			var packageName:String = typeName.split("::")[1];
			var type:Class = Class(getDefinitionByName(typeName));
			
			registerClassAlias(packageName, type);
			
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
		}
		
		/**
		 * 返回指定对象的所有可读写属性名称列表(动态属性无法获取)
		 * @param obj 要获取属性列表的对象
		 * @return 属性名称列表
		 * 
		 */		
		public static function getPropertyName(obj:Object):Array
		{
			var describe:XML = describeType(obj);
			
			var accessorList:XMLList = describe..accessor;
			var variableList:XMLList = describe..variable;
			
			var rlt:Array = [];
			
			var i:int = 0;
			
			for(i = 0; i < accessorList.length(); i++)
			{
				if(accessorList[i].@access == "readwrite")
				{
					rlt.push(accessorList[i].@name.toXMLString());
				}
			}
			
			for(i = 0; i < variableList.length(); i++)
			{
				rlt.push(variableList[i].@name.toXMLString());
			}
			
			return rlt;
		}
		
		/**
		 * 将指定源对象的属性值赋值给目标对象的对应属性值，以 target 参数的属性列表进行赋值，source 参数对象中无对应属性值时不进行赋值。(describeType方式，动态属性无法复制。)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的目标对象
		 * 
		 */		
		public static function copyToTarget(source:Object, target:Object):Object
		{
			if(source && target)
			{
				var names:Array = getPropertyName(target);
				
				for(var i:int = 0; i<names.length;i++)
				{
					if(source.hasOwnProperty(names[i]))
						target[names[i]] = source[names[i]];
				}
			}
			
			return target;
		}
		
		/**
		 * 将指定源对象的属性值赋值给目标对象的对应属性值，以 source 参数的属性列表进行赋值，target 参数对象中无对应属性时强制进行赋值。(describeType方式，动态属性无法复制。)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的目标对象
		 * 
		 */		
		public static function copyToTarget2(source:Object, target:Object):Object
		{
			if(source && target)
			{
				var names:Array = getPropertyName(source);
				
				for(var i:int = 0; i<names.length;i++)
				{
					try
					{
						target[names[i]] = source[names[i]];
					}
					catch(e:Error){}
				}
			}
			
			return target;
		}
		
		/**
		 * 将指定目标对象的属性值赋值给源对象的对应属性值，以 source 参数的属性列表进行赋值，target 参数对象中无对应属性值时不进行赋值。(describeType方式，动态属性无法复制。)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的源对象
		 * 
		 */		
		public static function copyToSource(source:Object, target:Object):Object
		{
			return copyToTarget(target, source);
		}
		
		/**
		 * 将指定目标对象的属性值赋值给源对象的对应属性值，以 target 参数的属性列表进行赋值，source 参数对象中无对应属性时强制进行赋值。(describeType方式，动态属性无法复制。)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的源对象
		 * 
		 */		
		public static function copyToSource2(source:Object, target:Object):Object
		{
			return copyToTarget2(target, source);
		}
		
		/**
		 * 将指定源对象的属性值赋值给目标对象的对应属性值，以 target 参数的属性列表进行赋值，source 参数对象中无对应属性值时不进行赋值。(for in方式)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的目标对象
		 * 
		 */		
		public static function copyDynamicToTarget(source:Object, target:Object):Object
		{
			for(var key:* in target)
			{
				if(source.hasOwnProperty(key))
					target[key] = source[key];
			}
			
			return target;
		}
		
		/**
		 * 将指定源对象的属性值赋值给目标对象的对应属性值，以 source 参数的属性列表进行赋值，target 参数对象中无对应属性时强制进行赋值。(for in方式)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的目标对象
		 * 
		 */		
		public static function copyDynamicToTarget2(source:Object, target:Object):Object
		{
			for(var key:* in source)
			{
				target[key] = source[key];
			}
			
			return target;
		}
		
		/**
		 * 将指定目标对象的属性值赋值给源对象的对应属性值，以 source 参数的属性列表进行赋值，target 参数对象中无对应属性值时不进行赋值。(for in方式)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的源对象
		 * 
		 */		
		public static function copyDynamicToSource(source:Object, target:Object):Object
		{
			return copyDynamicToTarget(target, source);
		}
		
		/**
		 * 将指定目标对象的属性值赋值给源对象的对应属性值，以 target 参数的属性列表进行赋值，source 参数对象中无对应属性时强制进行赋值。(for in方式)
		 * @param source 源对象
		 * @param target 目标对象
		 * @return 赋值后的源对象
		 * 
		 */		
		public static function copyDynamicToSource2(source:Object, target:Object):Object
		{
			return copyDynamicToTarget2(target, source);
		}
	}
}