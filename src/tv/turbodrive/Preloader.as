package tv.turbodrive
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import tv.turbodrive.loader.BridgeLoaderEvent;
	
	import uk.soulwire.utils.display.DisplayUtils;
	
	[SWF(width='1280', height='720', backgroundColor='#000000', frameRate='25')]
	
	public class Preloader extends MovieClip
	{
		private var _mainComplete:Boolean = false
		private var _currentComplete:Boolean = false
			
		private var _noiseLoop:VideoNoiseLoop;
		private var _bgVideo:Shape
		private var _hiddenContent:Shape;
		private var _stretchLoader_16_9:Boolean = false
		
		private var _mainLoader:Loader;
		public static var TRACKER:AnalyticsTracker;
		
		public function Preloader()
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			_noiseLoop = new VideoNoiseLoop();
			TRACKER = new GATracker(this,"UA-36681977-3", "AS3", false);
			track("_preloader")
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT				
			
			_mainLoader = new Loader()
			_mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler)			
				
			_bgVideo = new Shape()
			_bgVideo.graphics.beginFill(0x000000,1)
			_bgVideo.graphics.drawRect(0,0,1280,720)
			_bgVideo.graphics.endFill();
			
			_hiddenContent = new Shape()
			_hiddenContent.graphics.beginFill(0x000000,1)
			_hiddenContent.graphics.drawRect(0,0,1280,720)
			_hiddenContent.graphics.endFill();

			SWFAddress.addEventListener(SWFAddressEvent.INIT, initSwfAddressHandler)
		}		
		
		public static function track(url:String):void
		{
			///trace(">>>> TRACK >>>> " + url)
			if(TRACKER){
				TRACKER.trackPageview(url)
			}
		}
		
		private function initSwfAddressHandler(e:Event):void
		{
			var currentDeeplink:String = SWFAddress.getValue();
			_stretchLoader_16_9 = !(currentDeeplink == "/" || currentDeeplink == "/reel/" || currentDeeplink == "/reel" || currentDeeplink == "/reel/intro/" || currentDeeplink == "/reel/intro")
			
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			_mainLoader.load(new URLRequest("Main.swf"),context)
			
			addChild(_hiddenContent)
			addChild(_noiseLoop);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(null);
		}
		
		
		protected function checkFrame(event:Event):void
		{			
			if(this.framesLoaded >= this.totalFrames){
				_currentComplete = true
				startup();
				removeEventListener(Event.ENTER_FRAME,checkFrame);
				stop();
			}
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			_mainComplete = true
			_mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler)
			startup();
			
		}				
		
		private function resizeHandler(e:Event):void
		{
			
			DisplayUtils.fitIntoRect(_bgVideo,new Rectangle(0,0,stage.stageWidth, stage.stageHeight),false);
			DisplayUtils.fitIntoRect(_hiddenContent,new Rectangle(0,0,stage.stageWidth, stage.stageHeight),true);
			
			
			if(_stretchLoader_16_9){
				_noiseLoop.width = _bgVideo.width
				_noiseLoop.x = _bgVideo.x
				_noiseLoop.y = _bgVideo.y
				_noiseLoop.height = _bgVideo.height
			}else{
				DisplayUtils.fitIntoRect(_noiseLoop,new Rectangle(_bgVideo.x,_bgVideo.y,_bgVideo.width, _bgVideo.height),false);
			}
		}
		
		public function startup():void 
		{
			if(_currentComplete && _mainComplete){
				// hide loader
				
				var mainDisplayObject:DisplayObject = _mainLoader.contentLoaderInfo.content as DisplayObject
				mainDisplayObject.addEventListener(BridgeLoaderEvent.MAIN_CONTENT_READY, mainContentReadyHandler);
				mainDisplayObject.addEventListener(BridgeLoaderEvent.BUFFER_EMPTY, bufferEmptyHandler);
				mainDisplayObject.addEventListener(BridgeLoaderEvent.BUFFER_FULL, bufferFullHandler);
				
				addChildAt(mainDisplayObject,0);
			}
		}
		
		protected function bufferFullHandler(event:Event):void
		{
			hideNoiseLoop();
		}
		
		protected function bufferEmptyHandler(event:Event):void
		{
			showNoiseLoop();
		}
		
		private function showNoiseLoop():void
		{
			var currentDeeplink:String = SWFAddress.getValue();
			_stretchLoader_16_9 = !(currentDeeplink == "/" || currentDeeplink == "/reel/" || currentDeeplink == "/reel" || currentDeeplink == "/reel/intro/" || currentDeeplink == "/reel/intro")
			resizeHandler(null);
			
			
			if(_noiseLoop) _noiseLoop.gotoAndPlay(1)
			if(!contains(_hiddenContent)) addChild(_hiddenContent)
			if(!contains(_noiseLoop)) addChild(_noiseLoop)
		}
		
		private function hideNoiseLoop():void
		{
			if(_noiseLoop) _noiseLoop.stop();
			if(contains(_hiddenContent)) removeChild(_hiddenContent)
			if(contains(_noiseLoop)) removeChild(_noiseLoop)
		}		
		
		protected function mainContentReadyHandler(event:Event):void
		{
			hideNoiseLoop();
		}
	}
}