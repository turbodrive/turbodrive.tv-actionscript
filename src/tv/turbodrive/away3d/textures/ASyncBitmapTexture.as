package tv.turbodrive.away3d.textures
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.textures.BitmapTexture;
	
	import tv.turbodrive.utils.workers.MessageType;
	
	use namespace arcane;
	
	public class ASyncBitmapTexture extends BitmapTexture
	{
		private var _mipMapUploaded:Boolean = false
		
		private var _tmpTexture:TextureBase
			
		private var mainToBack:MessageChannel;
		private var backToMain:MessageChannel;	
		
		private var _initStarted:Boolean = false;
		private var mipMapWorker:Worker;
		private var _workerIsRunning:Boolean = false;
		public static const MIPMAP_UPLOADED:String = "mipmapUploaded";

		private var info:Object;
		
		public function ASyncBitmapTexture(bitmapData:BitmapData, generateMipmaps:Boolean=true)
		{
			super(bitmapData, generateMipmaps);
		}
		
		public function hasUploadedMipMap():Boolean
		{
			return _mipMapUploaded
		}
		
		override public function getTextureForStage3D(stage3DProxy : Stage3DProxy) : TextureBase
		{
			if(!_mipMapUploaded){
				throw new Error("ASyncBitmapTexture [" + this.name + "] - MipMapped Bitmapdata not yet uploaded - Use uploadAsynchTexture()")
			}

			return _textures[stage3DProxy._stage3DIndex];
		}
		
		public function uploadAsynchTexture(stage3DProxy : Stage3DProxy):void
		{
			if(_mipMapUploaded) return
				
			var contextIndex : int = stage3DProxy._stage3DIndex;
			var tex : TextureBase = _textures[contextIndex];
			var context : Context3D = stage3DProxy._context3D;
			
			_textures[contextIndex] = tex = createTexture(context);
			_dirty[contextIndex] = context;
			uploadContent(tex);
		}
		
		override protected function uploadContent(texture : TextureBase) : void
		{
			if(_mipMapUploaded) return
			
			_tmpTexture = texture
			mipMapWorker = WorkerDomain.current.createWorker(Workers.tv_turbodrive_utils_workers_BgMipMapScaler);
			mipMapWorker.addEventListener(Event.WORKER_STATE,changeWorkerState);
			//Create message channel TO the worker
			mainToBack = Worker.current.createMessageChannel(mipMapWorker);
			
			//Create message channel FROM the worker, add a listener.
			backToMain = mipMapWorker.createMessageChannel(Worker.current);
			backToMain.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			
			mipMapWorker.setSharedProperty("backToMain", backToMain);
			mipMapWorker.setSharedProperty("mainToBack", mainToBack);
			
			mipMapWorker.start()
		}
		
		protected function onBackToMain(event:Event):void
		{
			//if(backToMain.messageAvailable){ // to low ?
				var msg:String = backToMain.receive();				
				switch(msg){
					case MessageType.INIT_STARTED :
						initStarted()
						break;
					case MessageType.BYTES_LOADED :
						sendInfo()
						break;
					case MessageType.MIPMAP_LEVEL_COMPLETE :
						mipMapLevelComplete()
						break;
					case MessageType.COMPLETE_MIPMAPPING :
						completeMipMapping()
						break;
				}
			//}
		}
		
		private function completeMipMapping():void
		{
			backToMain.removeEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			mipMapWorker.terminate();	
			
			_mipMapUploaded = true
			_tmpTexture = null					
			mainToBack = null
			backToMain = null
				
			mipMapWorker.setSharedProperty("backToMain", null);
			mipMapWorker.setSharedProperty("mainToBack", null);
				
			dispatchEvent(new Event(MIPMAP_UPLOADED))			
		}
		
		private function mipMapLevelComplete():void
		{
			var resultBytes:ByteArray = backToMain.receive();
			var info:Object = backToMain.receive();
			if(info.width < 1) info.width = 1
			if(info.height < 1) info.height = 1
			var newBData:BitmapData = new BitmapData(info.width, info.height, true, 0x0);
			newBData.setPixels(newBData.rect,resultBytes);
			Texture(_tmpTexture).uploadFromBitmapData(newBData, info.level);	
			newBData.dispose();
			resultBytes.clear();
		}
		
		protected function changeWorkerState(event:Event = null):void
		{
			if(mipMapWorker.state == WorkerState.RUNNING && _initStarted){
				_workerIsRunning = true
				mipMapWorker.removeEventListener(Event.WORKER_STATE,changeWorkerState);
				if(_tmpTexture && bitmapData){					
					var imageBytes:ByteArray = new ByteArray();
					info = {width:bitmapData.width, height:bitmapData.height}
					imageBytes.position = 0
					bitmapData.copyPixelsToByteArray(bitmapData.rect, imageBytes);					
					mainToBack.send(MessageType.BYTE_MIPMAPPING);
					mainToBack.send(imageBytes)
					imageBytes.clear()
				}
			}
		}
		
		private function sendInfo():void
		{
			mainToBack.send(MessageType.PROCESS_MIPMAPPING);
			mainToBack.send(info)
		}
		
		private function initStarted():void
		{
			if(_initStarted) return			
			_initStarted = true
			changeWorkerState()
		}		
	}
}