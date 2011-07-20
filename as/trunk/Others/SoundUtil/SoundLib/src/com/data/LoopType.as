package com.data
{
	/**
	 * 背景音乐播放类型
	 * @author Jsion
	 * 
	 */	
	public class LoopType
	{
		/**
		 * 随机播放
		 */		
		public static const RANDOM_PLAY:String = "randomPlay";
		/**
		 * 循环播放
		 */		
		public static const CIRCULATORY_PLAY:String = "circulatoryPlay";
		/**
		 * 单曲循环
		 */		
		public static const SINGLE_PLAY:String = "singlePlay";
		/**
		 * 战斗播放模式，配合LoopParam进入设置
		 */		
		public static const BATTLE_PLAY:String = "battlePlay";
		
		/**
		 * 是否是LoopType的值
		 * @param lp
		 * @return 
		 * 
		 */		
		public static function isLoopType(loopType:String):Boolean
		{
			if(	loopType != RANDOM_PLAY && 
				loopType != CIRCULATORY_PLAY && 
				loopType != SINGLE_PLAY && 
				loopType != BATTLE_PLAY)
				return false;
			return true;
		}
	}
}