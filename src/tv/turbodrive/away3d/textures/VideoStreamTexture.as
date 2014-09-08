package tv.turbodrive.away3d.textures
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import away3d.textures.BitmapTexture;
	
	import tv.turbodrive.puremvc.mediator.view.awayComponents.TextureBufferBridge;
	
	public class VideoStreamTexture extends BitmapTexture
	{
		public static const TEXTURE_SIZE:int = 512
		
		private var _videoContainer:Sprite;		
		public function VideoStreamTexture()
		{
			super(new BitmapData(TEXTURE_SIZE, TEXTURE_SIZE>>1, false, 0x00000000));
			_videoContainer = TextureBufferBridge.videoContainer
			/*_videoContainer.graphics.beginFill(0xFF0000);
			_videoContainer.graphics.drawRect(250,250,25,25);
			_videoContainer.graphics.endFill();*/
		}
		
		public function update() : void
		{
				//bitmapData.lock();
				//_videoContainer.transform.matrix.scale(2,2);
				//_videoContainer.scaleX = _videoContainer.scaleY = 0.5
				var m:Matrix = _videoContainer.transform.matrix.clone()
				m.scale(.25,.25);
				bitmapData.draw(_videoContainer, m, null, null, null, true);
				invalidateContent();
		}
		
		override public function dispose():void
		{
			_videoContainer = null
			super.dispose();
		}
	}
}