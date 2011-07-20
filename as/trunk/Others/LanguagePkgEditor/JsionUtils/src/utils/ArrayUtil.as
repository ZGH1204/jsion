package utils
{
	public class ArrayUtil
	{
		/* 将任意个数组连接，并过滤掉重复项，返回新数组(仅适合引用对象) */
		public static function contact(...args):Array
		{
			if(args == null || args.length == 0)
				return null;
			
			var result:Array = [];
			
			for(var i:uint = 0; i < args.length; i++)
			{
				if(args[i] is Array)
				{
					for(var j:uint = 0; j < args[i].length; j++)
					{
						if(result.indexOf(args[i][j]) == -1)
							result.push(args[i][j]);
					}
				}
				else
				{
					if(result.indexOf(args[i] == -1))
						result.push(args[i]);
				}
			}
			
			return result;
		}
		
		public static function containts(sourceArray:Array, obj:Object):Boolean
		{
			return (sourceArray.indexOf(obj) != -1);
		}
	}
}