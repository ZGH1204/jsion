package jsion
{
	/**
	 * 栈接口
	 * @author Jsion
	 * 
	 */	
	public interface IStack extends IList
	{
		/**
		 * 返回栈顶对象,但不从栈中删除此对象
		 * @return 
		 * 
		 */		
		function peek():*
		
		/**
		 * 删除并返回列表中的最后一个对象(出栈)
		 * @return 列表中的最后一个对象
		 */		
		function pop():*;
		
		/**
		 * 将指定对象压入到列表的第一个索引位置,列表中原有对象的索引位置依次后称一个位置(入栈)
		 */		
		function push(element:*):void;
		
		/**
		 * 查找指定对象相对于栈顶的索引位置
		 * @param o 指定对象
		 * @return 相对于栈顶的索引位置(栈顶索引位置为0)
		 * 
		 */		
		function search(o:*):int;
	}
}