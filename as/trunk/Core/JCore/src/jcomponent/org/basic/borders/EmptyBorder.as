package jcomponent.org.basic.borders
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultRes;
	import jcomponent.org.basic.IComponentUI;

	import jutils.org.util.DisposeUtil;

	public class EmptyBorder implements IBorder
	{
		/**
		 * 当前边框的内部嵌套边框
		 */		
		private var m_interior:IBorder;
		private var m_disContainer:Sprite;

		private var m_autoFreeInterior:Boolean;

		public function EmptyBorder(interior:IBorder = null, autoFreeInterior:Boolean = true)
		{
			m_interior = interior;
			autoFreeInterior = autoFreeInterior;
		}

		public function get interior():IBorder
		{
			return m_interior;
		}

		public function set interior(value:IBorder):void
		{
			m_interior = value;
		}

		final public function updateBorder(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
			updateBorderImp(component, ui, bounds);

			if(interior != null)
			{
				var interiorBounds:IntRectangle = getBorderInsetsImp(component, bounds).getInsideBounds(bounds);
				interior.updateBorder(component, ui, interiorBounds);
			}
		}

		public function updateBorderImp(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{

		}

		final public function getBorderInsets(component:Component, bounds:IntRectangle):Insets
		{
			var insets:Insets = getBorderInsetsImp(component, bounds);

			if(interior != null)
			{
				var interiorBounds:IntRectangle = insets.getInsideBounds(bounds);
				insets.addInsets(interior.getBorderInsets(component, interiorBounds));
			}

			return insets;
		}

		public function getBorderInsetsImp(component:Component, bounds:IntRectangle):Insets
		{
			return new Insets();
		}

		final public function getDisplay(component:Component):DisplayObject
		{
			var inter:IBorder = interior;

			if(inter != null)
			{
				var interDis:DisplayObject = inter.getDisplay(component);

				var selfDis:DisplayObject = getDisplayImp();

				if(interDis == null)
				{
					return selfDis;
				}
				else if(selfDis == null)
				{
					return interDis;
				}
				else
				{
					if(m_disContainer == null)
					{
						m_disContainer = new Sprite();
						m_disContainer.mouseEnabled = false;
						m_disContainer.addChild(selfDis);
						m_disContainer.addChild(interDis);
					}

					return m_disContainer;
				}
			}
			else
			{
				return getDisplayImp();
			}

			return null;
		}

		public function getDisplayImp():DisplayObject
		{
			return null;
		}

		public function dispose():void
		{
			if(this == DefaultRes.DEFAULT_BORDER) return;

			if(m_autoFreeInterior) DisposeUtil.free(m_interior);
			m_interior = null;

			DisposeUtil.freeChildren(m_disContainer);
			DisposeUtil.free(m_disContainer);
			m_disContainer = null;
		}
	}
}

