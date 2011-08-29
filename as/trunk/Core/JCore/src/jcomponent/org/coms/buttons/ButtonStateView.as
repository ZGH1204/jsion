package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jcomponent.org.basic.Component;
	
	import jutils.org.util.DisposeUtil;
	
	public class ButtonStateView extends Sprite implements IDispose
	{
		private var m_upImage:DisplayObject;
		
		private var m_overImage:DisplayObject;
		
		private var m_downImage:DisplayObject;
		
		private var m_disabledImage:DisplayObject;
		
		
		
		private var m_selectedImage:DisplayObject;
		
		private var m_overSelectedImage:DisplayObject;
		
		private var m_downSelectedImage:DisplayObject;
		
		private var m_disabledSelectedImage:DisplayObject;
		
		
		
		private var lastImage:DisplayObject;
		
		
		
		
		
		public var enabled:Boolean;
		
		public var downed:Boolean;
		
		public var overed:Boolean;
		
		public var selected:Boolean;
		
		private var m_freeBitmapData:Boolean;
		
		public function ButtonStateView(freeBitmapData:Boolean = false)
		{
			m_freeBitmapData = freeBitmapData;
			super();
		}
		
		public function update(size:IntDimension = null):void
		{
			var image:DisplayObject = m_upImage;
			
			var tmpImage:DisplayObject;
			
			if(!enabled)
			{
				if(selected && m_disabledSelectedImage)
				{
					tmpImage = m_disabledSelectedImage;
				}
				else
				{
					tmpImage = m_disabledImage;
				}
			}
			else if(downed)
			{
				if(selected && m_downSelectedImage)
				{
					tmpImage = m_downSelectedImage;
				}
				else
				{
					tmpImage = m_downImage;
				}
			}
			else if(overed)
			{
				if(selected && m_overSelectedImage)
				{
					tmpImage = m_overSelectedImage;
				}
				else
				{
					tmpImage = m_overImage;
				}
			}
			else if(selected)
			{
				tmpImage = m_selectedImage;
			}
			
			if(tmpImage != null)
			{
				image = tmpImage;
			}
			
			if(image != lastImage)
			{
				if(lastImage) lastImage.visible = false;
				
				if(image) image.visible = true;
				
				lastImage = image;
			}
			
			if(size != null && image)
			{
				image.width = size.width;
				image.height = size.height;
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			child.visible = false;
			
			return super.addChild(child);
		}
		
		public function setUpImage(image:DisplayObject):void
		{
			checkAsset(m_upImage);
			m_upImage = image;
			addChild(image);
		}
		
		public function setOverImage(image:DisplayObject):void
		{
			checkAsset(m_overImage);
			m_overImage = image;
			addChild(image);
		}
		
		public function setDownImage(image:DisplayObject):void
		{
			checkAsset(m_downImage);
			m_downImage = image;
			addChild(image);
		}
		
		public function setDisabledImage(image:DisplayObject):void
		{
			checkAsset(m_disabledImage);
			m_disabledImage = image;
			addChild(image);
		}
		
		
		
		public function setSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_selectedImage);
			m_selectedImage = image;
			addChild(image);
		}
		
		public function setOverSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_overSelectedImage);
			m_overSelectedImage = image;
			addChild(image);
		}
		
		public function setDownSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_downSelectedImage);
			m_downSelectedImage = image;
			addChild(image);
		}
		
		public function setDisabledSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_disabledSelectedImage);
			m_disabledSelectedImage = image;
			addChild(image);
		}
		
		protected function checkAsset(image:DisplayObject):void
		{
			if(image != null && contains(image))
			{
				throw new Error("You are set a already exists asset!");
			}
		}
		
		public function getPreferredSize(component:Component):IntDimension
		{
			return getSize();
		}
		
		public function getMinimumSize(component:Component):IntDimension
		{
			return getSize();
		}

		public function getMaximumSize(component:Component):IntDimension
		{
			return getSize();
		}
		
		protected function getSize():IntDimension
		{
			if(m_upImage)
			{
				return new IntDimension(m_upImage.width, m_upImage.height);
			}
			else if(m_overImage)
			{
				return new IntDimension(m_overImage.width, m_overImage.height);
			}
			else if(m_downImage)
			{
				return new IntDimension(m_downImage.width, m_downImage.height);
			}
			else if(m_disabledImage)
			{
				return new IntDimension(m_disabledImage.width, m_disabledImage.height);
			}
			else if(m_selectedImage)
			{
				return new IntDimension(m_selectedImage.width, m_selectedImage.height);
			}
			else if(m_overSelectedImage)
			{
				return new IntDimension(m_overSelectedImage.width, m_overSelectedImage.height);
			}
			else if(m_downSelectedImage)
			{
				return new IntDimension(m_downSelectedImage.width, m_downSelectedImage.height);
			}
			else if(m_disabledSelectedImage)
			{
				return new IntDimension(m_disabledSelectedImage.width, m_disabledSelectedImage.height);
			}
			
			return new IntDimension();
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_upImage, m_freeBitmapData);
			m_upImage = null;
			
			DisposeUtil.free(m_overImage, m_freeBitmapData);
			m_overImage = null;
			
			DisposeUtil.free(m_downImage, m_freeBitmapData);
			m_downImage = null;
			
			DisposeUtil.free(m_disabledImage, m_freeBitmapData);
			m_disabledImage = null;
			
			DisposeUtil.free(m_selectedImage, m_freeBitmapData);
			m_selectedImage = null;
			
			DisposeUtil.free(m_overSelectedImage, m_freeBitmapData);
			m_overSelectedImage = null;
			
			DisposeUtil.free(m_downSelectedImage, m_freeBitmapData);
			m_downSelectedImage = null;
			
			DisposeUtil.free(m_disabledSelectedImage, m_freeBitmapData);
			m_disabledSelectedImage = null;
			
			lastImage = null;
		}
	}
}