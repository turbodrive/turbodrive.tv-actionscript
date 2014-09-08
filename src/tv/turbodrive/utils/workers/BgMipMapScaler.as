package tv.turbodrive.utils.workers
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	public class BgMipMapScaler extends Sprite
	{
		private var mainToBack:MessageChannel;
		private var backToMain:MessageChannel;
		
		private static var _matrix : Matrix = new Matrix();
		private static var _rect : Rectangle = new Rectangle();

		private var imgBytes:ByteArray;
		
		public function BgMipMapScaler()
		{
			var worker:Worker = Worker.current;			
			//Listen on mainToBack for SHARPEN events
			mainToBack = worker.getSharedProperty("mainToBack") as MessageChannel;
			mainToBack.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
			backToMain = worker.getSharedProperty("backToMain") as MessageChannel;			
			
			backToMain.send(MessageType.INIT_STARTED);
		}
		
		protected function onMainToBack(event:Event):void
		{
			//if(mainToBack.messageAvailable){
				var msg:String = mainToBack.receive();			
				switch(msg){
					case MessageType.BYTE_MIPMAPPING :
						imgBytes = mainToBack.receive() as ByteArray
						backToMain.send(MessageType.BYTES_LOADED)
						break;
					case MessageType.PROCESS_MIPMAPPING :
						process();
						break;
				}
			//}
		}
		
		private function process():void
		{
			//imgBytes = mainToBack.receive() as ByteArray
			var infos:Object = mainToBack.receive() as Object			
			
			if(infos == null) {
				trace("No INfos, retry...")
				backToMain.send(MessageType.BYTES_LOADED)
				return
			}
				
			var w : uint = infos.width;
			var	h : uint = infos.height;
			var i : uint = 0;
			
			var mipmap:BitmapData = new BitmapData(w, h, true);
			var source:BitmapData = new BitmapData(w, h, true);
			source.setPixels(new Rectangle(0,0,w,h),imgBytes);	
			
			_rect.width = w;
			_rect.height = h;
			
			var scaleTransform:Matrix = new Matrix();
			
			while (w >= 1 || h >= 1) {
				mipmap.fillRect(_rect, 0);
				
				_matrix.a = _rect.width/source.width;
				_matrix.d = _rect.height/source.height;
				
				mipmap.draw(source, _matrix, null, null, null, true);

				imgBytes.clear()
				mipmap.copyPixelsToByteArray(_rect,imgBytes);
				
				backToMain.send(MessageType.MIPMAP_LEVEL_COMPLETE)
				backToMain.send(imgBytes)
				backToMain.send({width:w, height:h, level:i++})
					
				w >>= 1;
				h >>= 1;
				
				_rect.width = w > 1? w : 1;
				_rect.height = h > 1? h : 1;				
			}
			
			mipmap.dispose();
			source.dispose();
			imgBytes.clear()
			mainToBack.removeEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
			backToMain.send(MessageType.COMPLETE_MIPMAPPING)
			backToMain = null
			mainToBack = null
		}
	}
}