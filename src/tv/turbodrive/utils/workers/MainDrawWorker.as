package tv.turbodrive.utils.workers
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	
	import tv.turbodrive.events.ObjectEvent;

	public class MainDrawWorker extends EventDispatcher
	{		
		public static const IS_RUNNING:String = "isRunning"
		public static const FRAME_SPRITESHEET_COMPLETE:String = "frameSpriteSheetComplete"
		
		private var worker:Worker;
		private var mainToBack:MessageChannel;
		private var backToMain:MessageChannel;
		//private var imageBytes:ByteArray;		
		private var _isRunning:Boolean = false;
		private var _initStarted:Boolean = false;
		
		public function MainDrawWorker()
		{		
			initWorker();
		}
		
		protected function initWorker():void {
			//Create worker from the main swf 
			worker = WorkerDomain.current.createWorker(Workers.tv_turbodrive_utils_workers_BgDrawWorker);
			worker.addEventListener(Event.WORKER_STATE,changeWorkerState);
			
			//Create message channel TO the worker
			mainToBack = Worker.current.createMessageChannel(worker);
			
			//Create message channel FROM the worker, add a listener.
			backToMain = worker.createMessageChannel(Worker.current);
			backToMain.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			
			//Now that we have our two channels, inject them into the worker as shared properties.
			//This way, the worker can see them on the other side.
			worker.setSharedProperty("backToMain", backToMain);
			worker.setSharedProperty("mainToBack", mainToBack);
			
			worker.start();
			
		}
		
		public function process(source:BitmapData, area:Rectangle, options:Object):void
		{
			if(!isRunning()) return
			
			//Convert image data to (shareable) byteArray, and share it with the worker.
			var imageBytes:ByteArray = new ByteArray();
			imageBytes.position = 0
			source.copyPixelsToByteArray(source.rect, imageBytes);
			//worker.setSharedProperty("imageBytes", imageBytes);
			
			mainToBack.send(MessageType.START_FRAME_SPRITESHEET)
			mainToBack.send(imageBytes);
			mainToBack.send({x:area.x, y:area.y, width:area.width, height:area.height});
			mainToBack.send(options);
		}			
		
		public function isRunning():Boolean
		{
			return _isRunning && _initStarted
		}
		
		protected function changeWorkerState(event:Event = null):void
		{
			if(worker.state == WorkerState.RUNNING && _initStarted){
				_isRunning = true
				dispatchEvent(new Event(IS_RUNNING));
			}
		}
		
		private function initStarted():void
		{
			if(_initStarted) return
			
			_initStarted = true
			changeWorkerState()
		}
		
		protected function onBackToMain(event:Event):void
		{			
			if(backToMain.messageAvailable){
				var msg:String = backToMain.receive();
				switch(msg){
					case MessageType.INIT_STARTED :
						initStarted()
						break;
					case MessageType.COMPLETE_FRAME_SPRITESHEET :
						completeFrameSpriteSheet()
						break;
				}
			}
		}
		
		
		
		private function completeFrameSpriteSheet():void
		{			
			var resultBytes:ByteArray = backToMain.receive();
			var info:Object = backToMain.receive();
			var newBData:BitmapData = new BitmapData(info.width, info.height, true, 0x0);
			newBData.setPixels(newBData.rect,resultBytes);
			dispatchEvent(new ObjectEvent(FRAME_SPRITESHEET_COMPLETE, this, newBData));
			worker.terminate();
		}
	}
}