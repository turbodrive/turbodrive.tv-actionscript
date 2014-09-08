package tv.turbodrive.utils.workers
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import tv.turbodrive.away3d.utils.MaterialBuilder;
	
	public class BgDrawWorker extends Sprite
	{
		private var mainToBack:MessageChannel;
		private var backToMain:MessageChannel;
		
		public function BgDrawWorker()
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
			if(mainToBack.messageAvailable){
				var msg:String = mainToBack.receive();			
				switch(msg){
					case MessageType.START_FRAME_SPRITESHEET :
						startFrameSpriteSheet()
						break;
				}
			}
		}
		
		private function startFrameSpriteSheet():void
		{
			var imageBytes:ByteArray = mainToBack.receive() as ByteArray;
			var rectObj:Object = mainToBack.receive()
			var area:Rectangle = new Rectangle(rectObj.x, rectObj.y, rectObj.width, rectObj.height);
			var options:Object = mainToBack.receive() as Object;
			
			var imageData:BitmapData = new BitmapData(options.initWidth, options.initHeight, true, 0x0);
			imageData.setPixels(imageData.rect, imageBytes);
			imageBytes.length = 0
			imageBytes.position = 0
			var result:BitmapData = MaterialBuilder.getATMaterialFromFrameSpriteSheet(imageData,area,options)
			result.copyPixelsToByteArray(result.rect, imageBytes);
				
			backToMain.send(MessageType.COMPLETE_FRAME_SPRITESHEET)
			backToMain.send(imageBytes);
			backToMain.send({width:result.width, height:result.height});
		}
	}
}