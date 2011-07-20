package vo
{
	import com.interfaces.ITerator;
	import com.managers.ModuleManager;
	import com.utils.ArrayHelper;
	import com.utils.StringHelper;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	import vo.data.DirectionEnum;
	import vo.data.MenuConfig;
	import vo.data.MenuItemConfig;
	
	public class MenuContaint extends Sprite
	{
		private var config:MenuConfig;
		private var bg:DisplayObject;
		private var logo:DisplayObject;
		private var itemViewList:Array;
		private var splitViewList:Array;
		
		public function MenuContaint()
		{
			itemViewList = [];
			splitViewList = [];
		}
		
		public function buildMenu(config:MenuConfig):void
		{
			this.config = config;
			buildBackground();
			buildLogo();
			buildItemList();
			
			setGrey();
			setEnable();
		}
		
		private function buildBackground():void
		{
			if(StringHelper.isNullOrEmpty(config.backgroundCls) ||
				ModuleManager.getInstance().hasDefinition(config.backgroundCls) == false) return;
			
			bg = ModuleManager.getInstance().create(config.backgroundCls) as DisplayObject;
			
			bg.x = config.backgroundX;
			bg.y = config.backgroundY;
			
			addChild(bg);
		}
		
		private function buildLogo():void
		{
			if(StringHelper.isNullOrEmpty(config.logoCls) ||
				ModuleManager.getInstance().hasDefinition(config.logoCls) == false) return;
			
			logo = ModuleManager.getInstance().create(config.logoCls) as DisplayObject;
			
			logo.x = config.logoX;
			logo.y = config.logoY;
			
			addChild(logo);
		}
		
		private function buildItemList():void
		{
			var iterator:ITerator = ArrayHelper.createIterator(config.itemList);
			
			while(iterator.hasNext())
			{
				var mic:MenuItemConfig = iterator.next() as MenuItemConfig;
				var miv:MenuItemView = buildItem(mic);
				
				if(itemViewList.length != 0)
				{
					var split:Sprite = buildSplit();
					setSplitPos(split);
					addChild(split);
					splitViewList.push(split);
				}
				
				setItemPos(miv);
				addChild(miv);
				
				itemViewList.push(miv);
			}
		}
		
		private function buildItem(mi:MenuItemConfig):MenuItemView
		{
			var miv:MenuItemView = new MenuItemView();
			miv.itemCls = config.itemCls;
			miv.overCls = config.overCls;
			miv.downCls = config.downCls;
			miv.width = config.itemWidth;
			miv.height = config.itemHeight;
			miv.build(mi);
			return miv;
		}
		
		private function buildSplit():Sprite
		{
			var view:Sprite = new Sprite();
			
			if(StringHelper.isNullOrEmpty(config.splitCls) == false)
				view.addChild(ModuleManager.getInstance().create(config.splitCls) as DisplayObject);
			
			return view;
		}
		
		private function setItemPos(itemView:MenuItemView):void
		{
			if(itemViewList.length == 0)
			{
				itemView.x = config.itemStartX;
				itemView.y = config.itemStartY;
				return;
			}
			
			var lastSplitView:Sprite = splitViewList[splitViewList.length - 1] as Sprite;
			
			switch (config.direction)
			{
				case DirectionEnum.VERTICAL:
				{
					itemView.x = lastSplitView.x;
					itemView.y = lastSplitView.y + lastSplitView.height;
					break;
				}
				case DirectionEnum.HORIZONTAL:
				default:
				{
					itemView.x = lastSplitView.x + lastSplitView.width;
					itemView.y = lastSplitView.y;
					break;
				}
			}
		}
		
		private function setSplitPos(split:Sprite):void
		{
			if(itemViewList == null || itemViewList.length == 0) return;
			
			var lastItemView:MenuItemView = itemViewList[itemViewList.length - 1] as MenuItemView;
			
			switch (config.direction)
			{
				case DirectionEnum.VERTICAL:
				{
					split.x = lastItemView.x;
					split.y = lastItemView.y + lastItemView.height;
					break;
				}
				case DirectionEnum.HORIZONTAL:
				default:
				{
					split.x = lastItemView.x + lastItemView.width;
					split.y = lastItemView.y;
					break;
				}
			}
			
		}
		
		private function setGrey():void
		{
			if(config.grey)
			{
				var matrix:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
				
				filters = [new ColorMatrixFilter(matrix)];
			}
		}
		
		private function setEnable():void
		{
			this.mouseEnabled = config.enable;
			this.mouseChildren = config.enable;
		}
	}
}