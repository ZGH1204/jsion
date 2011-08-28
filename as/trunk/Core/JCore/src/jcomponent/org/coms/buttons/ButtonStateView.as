package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ButtonStateView extends Sprite
	{
		private var m_defaultImage:DisplayObject;
		
		private var m_upImage:DisplayObject;
		
		private var m_overImage:DisplayObject;
		
		private var m_downImage:DisplayObject;
		
		private var m_disabledImage:DisplayObject;
		
		
		
		private var m_selectedImage:DisplayObject;
		
		private var m_overSelectedImage:DisplayObject;
		
		private var m_downSelectedImage:DisplayObject;
		
		private var m_disabledSelectedImage:DisplayObject;
		
		private var lastImage:DisplayObject;
		
		
		
		
		public var defaulted:Boolean;
		
		public var enabled:Boolean;
		
		public var downed:Boolean;
		
		public var overed:Boolean;
		
		public var selected:Boolean;
		
		
		
		public function ButtonStateView()
		{
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
			else if(defaulted)
			{
				tmpImage = m_defaultImage;
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
		
		public function setDefaultImage(image:DisplayObject):void
		{
			checkAsset(m_defaultImage);
			m_defaultImage = image;
			addChild(image);
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
	}
}