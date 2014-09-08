package tv.turbodrive.loader
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.Main;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.ReelNetStream;
	import tv.turbodrive.utils.Config;
	import tv.turbodrive.utils.Path;
	import tv.turbodrive.utils.tick.TickDispatcher;
	import tv.turbodrive.utils.tick.TickListener;

	public class ReelVideoPlayer extends EventDispatcher implements TickListener
	{			
		static public const SHOW_2D_VIDEO:String = "reelReadyToPlay";
		static public const TICK_STREAM:String = "tickStream";
		static public const CHANGE_PAGE_PLAYING:String = "changePagePlaying";
		static public const STREAM_READY_FOR_NEXT_PAGE:String = "streamReady"
		static public const LIGHT_HEADER:String = "lightHeader";
		static public const LIGHT_TIMELINE:String = "lightTimeline";
		static public const LIGHT_TIMELINE2:String = "lightTimeline2";
		static public const GMD_APPEARING:String = "gmdAppear";
		static public const GMD_PAUSE:String = "gmdPause";
		static public const GMD_RESUME:String = "gmdResume";
		static public const GMD_HIDE:String = "gmdHide";
		static public const END_OF_VIDEO:String = "endOfVideo";
		
		//static public const STREAM_PAUSE_EMPTYBUFFER:String = "streamPauseBufferEmpty"
		//static public const STREAM_RESUME_FULLBUFFER:String = "streamResumeBufferFull"
				
		static private const DEBUG:Boolean = false
		
		private var _rns:ReelNetStream;		
		private var _currentPage:Page		
		private var _pagesReel:Vector.<Page>;			
		private var _startTimeStream:Number = 0
		
		private var _dispatchedOpenTimeline:Boolean = false
		private var _dispatchedAboutLight:Boolean = false	
		private var _dispatchedOpenTimeline2:Boolean = false		
		private var showGMD:Number = 28.5
		private var _dispatchedShowGMD:Boolean = false
		private var openTimelineTime:Number = 32
		private var openTimelineTime2:Number = 173
		private var aboutLightTime:Number = 175
		
		private var _isPaused:Boolean = false;
		private var _bufferFull:Boolean = false
		private var _isInitialized:Boolean = false
		private var _metaDataLoaded:Boolean = false
		private var _readyForNextPage:Boolean = false
		private var _pauseWhenBufferFull:Boolean = false;
		
		public var switchTmpPage:Page
		public var switchInProgress:Boolean = false
		private var _dispatchStreamReady:Boolean;
		
		private static var  _instance:ReelVideoPlayer		
	
		private var limitTimeSwitchLowerBwVideo:Number = 3000;
		
		private var _buffertimeout:int;
		private var _timeBw:uint;
		private var _bufferLevel:Number = 0

		private var _currentBytesLoaded:Number;

		private var _smoothBW:Number = 0;
		private var _smoothingFactor:Number = 1-0.9
		private var _currentQualityVideo:int = 0
		private var _videoUrl:String;
		private var _checkFillingBufferDuration:Number;
		
		public function init(pagesReel:Vector.<Page> = null):void
		{	
			if(_isInitialized) return
			_isInitialized = true
				
			_pagesReel = pagesReel				
			_rns = new ReelNetStream();
			_rns.addEventListener(ReelNetStream.META_DATA, metaDataHandler)			
			_rns.addEventListener(ReelNetStream.END_VIDEO, endVideoHandler)
			_rns.checkPolicyFile = true
			_rns.bufferTime = 2.5
			_videoUrl = Path.VIDEO_REEL
		}		
		
		public function ReelVideoPlayer(requires:SingletonEnforcer)
		{
			if (!requires) throw new Error("AssetsManager is a singleton, use static instance.");
		}
		
		static public function get instance():ReelVideoPlayer 
		{
			if (!_instance) _instance = new ReelVideoPlayer(new SingletonEnforcer());
			return _instance;
		}
		
		public function get stream():ReelNetStream
		{
			return _rns
		}
		
		public function movePlayHead(seekTime:Number, startPlaying:Boolean = false):void
		{	
			_pauseWhenBufferFull = !startPlaying
			if(DEBUG) trace("1. _pauseWhenBufferFull >> " + _pauseWhenBufferFull)
			_readyForNextPage = false
			_dispatchStreamReady = true
			seekOrPlay(seekTime)
		}
		
		public function resetFlags():void
		{
			_readyForNextPage = false
			_dispatchStreamReady = false
		}
		
		private function addListeners():void
		{
			if(!_rns.hasEventListener(ReelNetStream.BUFFER_EMPTY)){
				_rns.addEventListener(ReelNetStream.BUFFER_EMPTY, bufferEmptyHandler)
				_rns.addEventListener(ReelNetStream.BUFFER_FULL, bufferFullHandler)
			}
		}
		
		private function removeListeners():void
		{
			clearTimeout(_checkFillingBufferDuration);
			Main.INSTANCE.dispatchEvent(new Event(BridgeLoaderEvent.BUFFER_FULL))
			if(_rns.hasEventListener(ReelNetStream.BUFFER_EMPTY)){
				_rns.removeEventListener(ReelNetStream.BUFFER_EMPTY, bufferEmptyHandler)
				_rns.removeEventListener(ReelNetStream.BUFFER_FULL, bufferFullHandler)
			}
		}
		
		protected function endVideoHandler(event:Event):void
		{
			//seekOrPlay(0);
			
			dispatchEvent(new Event(END_OF_VIDEO))			
			removeListeners()
			
		}
		
		protected function bufferFullHandler(event:Event):void
		{
			_bufferFull = true
			clearTimeout(_checkFillingBufferDuration)
			
			Main.INSTANCE.dispatchEvent(new Event(BridgeLoaderEvent.BUFFER_FULL))
			trace("HIDE BUFFER_LOADING")
			
			if(DEBUG) trace("Buffer FULL - 2. _pauseWhenBufferFull >> " + _pauseWhenBufferFull)
			if(_pauseWhenBufferFull) pause()
			checkNetStreamReady()
			dispatchEvent(new Event(GMD_RESUME))
		}
		
		protected function bufferEmptyHandler(event:Event):void
		{
			if(DEBUG) trace(" BUFFER EMPTY >> ")
			_bufferFull = false
			Main.INSTANCE.dispatchEvent(new Event(BridgeLoaderEvent.BUFFER_EMPTY))
			trace("SHOW BUFFER_LOADING")
			dispatchEvent(new Event(GMD_PAUSE))
			
			_checkFillingBufferDuration = setTimeout(loadLowerBwVideo,limitTimeSwitchLowerBwVideo)
		}
		
		protected function udpateBufferLevel():void
		{
			_bufferLevel = _rns.bufferLength / _rns.bufferTime
			if(DEBUG) trace("buffer level : " + int((_bufferLevel)*100) + "%")
		}
		
		protected function checkBandWidth():void
		{
			if(_timeBw) clearTimeout(_timeBw)
			_timeBw = setTimeout(processBw, 1000)
			_currentBytesLoaded = _rns.bytesLoaded
		}
		
		private function processBw():void
		{
			var bytesLoadedInSec:Number = (_rns.bytesLoaded-_currentBytesLoaded)/1000
			if(_smoothBW == 0) _smoothBW = 	bytesLoadedInSec
			_smoothBW = (bytesLoadedInSec*_smoothingFactor) + ( _smoothBW * ( 1.0 - _smoothingFactor))	

			trace("global average >> " + int((_rns.bytesLoaded/1000)/_rns.time) + " kb/s - Smooth : " + int(_smoothBW) + " kb/s - bufferLength >> " + _rns.bufferLength + " sec")
			checkBandWidth()
		}
		
		public function isInitialized():Boolean
		{
			return _isInitialized
		}		
		
		public function onTick( event : Event = null ) : void
		{
			checkPageForTime();
			dispatchEvent(new ObjectEvent(TICK_STREAM,this,_rns));
			
			if(!_bufferFull) udpateBufferLevel()
			
			if(_rns.timeWithOffset > aboutLightTime && _rns.timeWithOffset < aboutLightTime+2)
			{				
				if(!_dispatchedAboutLight){
					dispatchEvent(new Event(LIGHT_HEADER));
					_dispatchedAboutLight = true
				}
			}
			
			if(_rns.timeWithOffset > openTimelineTime && _rns.timeWithOffset < openTimelineTime+2){
				if(!_dispatchedOpenTimeline){
					dispatchEvent(new Event(LIGHT_TIMELINE));
					_dispatchedOpenTimeline = true
				}
			}
			
			if(_rns.timeWithOffset > openTimelineTime2 && _rns.timeWithOffset < openTimelineTime2+2){
				if(!_dispatchedOpenTimeline2){
					dispatchEvent(new Event(LIGHT_TIMELINE2));
					_dispatchedOpenTimeline2 = true
				}
			}
			
			if(_rns.timeWithOffset > showGMD && _rns.timeWithOffset < showGMD+2){
				if(!_dispatchedShowGMD){
					dispatchEvent(new NumberEvent(GMD_APPEARING,this,0));
					_dispatchedShowGMD = true
				}
			}
		}	
		
		private function checkPageForTime():void
		{			
			if(switchInProgress || _isPaused) return
			for(var i:int = 0; i< _pagesReel.length; i++ ){
				var p:Page = _pagesReel[i] as Page
				var range:Array = p.rangeTime as Array
				if(_rns.timeWithOffset >= range[0] && _rns.timeWithOffset < range[1] && (_currentPage == null || p!= _currentPage)){
					_currentPage = p
					if(DEBUG) trace("[RPP] >> TimeOffset CHANGE PAGE > " + _currentPage)				
						
					if((switchTmpPage && switchTmpPage.environment == PagesName.REEL) || (_currentPage.environment == PagesName.REEL)){
						dispatchEvent(new PageEvent(CHANGE_PAGE_PLAYING,_currentPage))
						dispatchEvent(new Event(GMD_HIDE));
						
						//trace("••••• _currentPage.name " + _currentPage.name + "gmd >> " + _currentPage.gmd )
						if(_currentPage.gmd){
							dispatchEvent(new NumberEvent(GMD_APPEARING,this,5.1))
						}
					}
				}
			}			
		}	
				
		/*** METADATA **/
		
		private function sortByCuepoint(p1:Page, p2:Page):int
		{
			if(p1.cuepoint < p2.cuepoint) return -1
			if(p2.cuepoint < p1.cuepoint) return 1
			return 0
		}
		
		protected function metaDataHandler(event:Event):void
		{			
			_rns.removeEventListener(ReelNetStream.META_DATA, metaDataHandler);
			_pagesReel.sort(sortByCuepoint);
			
			for(var i:int = 0; i< _pagesReel.length; i++ ){
				var page:Page = Page(_pagesReel[i])
				if(i<_pagesReel.length-1){
					page.endTime = _pagesReel[i+1].cuepoint
				}else{
					page.endTime = _rns.duration
				}
			}
			_metaDataLoaded = true
			checkNetStreamReady()
		}
		
		/***************/
		
		private function checkNetStreamReady():void
		{	
			if(_metaDataLoaded && _bufferFull && _dispatchStreamReady){	
				TickDispatcher.getInstance().addTickListener(this);			
				if(DEBUG) trace("STREAM_READY_FOR_NEXT_PAGE");
				_dispatchStreamReady = false
				_readyForNextPage = true
				dispatchEvent(new Event(STREAM_READY_FOR_NEXT_PAGE));
				
				if(_readyForNextPage){
					if(_currentPage && _currentPage.gmd){
						dispatchEvent(new NumberEvent(GMD_APPEARING,this,5.1))
					}
				}				
			}			
		}
		
		public function isReadyToResumeForNextPage():Boolean
		{
			return _readyForNextPage
		}
		
		public function resume(unlock:Boolean):void
		{	
			dispatchEvent(new Event(GMD_RESUME))			
			if(unlock && _pauseWhenBufferFull){
				_pauseWhenBufferFull = false
				_readyForNextPage = false
			}
			_isPaused = false			
			_rns.resume();
			TickDispatcher.getInstance().addTickListener(this);
			if(DEBUG) trace("------------ RESUME VIDEO")
			//_rns.soundTransform.volume = 0
		}	
		
		public function pause():void
		{	
			//_rns.soundTransform.volume = 0
			_isPaused = true
			_rns.pause();
			dispatchEvent(new Event(GMD_PAUSE))
			TickDispatcher.getInstance().removeTickListener(this);
			if(DEBUG) trace("------------ PAUSE VIDEO")
		}	
				
		public function seek(targetPage:Page, offsetSeek:Number = 0):Boolean
		{			
			if(DEBUG) trace("[from TransitionProxy] seek to page" + targetPage.id)
			if(targetPage.name == PagesName.OUTRO){
				_dispatchedAboutLight = _dispatchedOpenTimeline2 = false
			}
			if(targetPage.name == PagesName.INTRO || targetPage.name == PagesName.REEL){
				_dispatchedShowGMD = false
			}
			if(!_currentPage || targetPage.id != _currentPage.id){
				dispatchEvent(new Event(GMD_HIDE))
				movePlayHead(targetPage.cuepoint+offsetSeek, true)
				_currentPage = targetPage					
				return false
			}else{
				return true
			}			
		}
		
		private function seekOrPlay(time:Number):void
		{
			if(DEBUG) trace("isAbleToSeek ? " + isAbleToSeek(time))
			if(isAbleToSeek(time)){
				if(DEBUG) trace("> seek >> " + time)		
				_rns.seek(time);
			}else{
				if(DEBUG) trace("> play >> " + time)
				play(time)	
			}			
		}
		
		private function play(startTime:Number = 0):void
		{
			_bufferFull = false
			_startTimeStream = _rns.timeOffset = startTime
			trace("PLAY - VIDEO QUALITY >> " + Path.VIDEO_RATES[_currentQualityVideo])
			addListeners()
			if(startTime > 0 && Config.SEEK_SERVER){
				_rns.play(_videoUrl + "?start=" + String(startTime))
			}else{
				_rns.play(_videoUrl)
			}
			//checkBandWidth()
			clearTimeout(_checkFillingBufferDuration);
			_checkFillingBufferDuration = setTimeout(loadLowerBwVideo,5000)
		}
		
		
		private function loadLowerBwVideo(checkBufferLevel:Boolean = true):void
		{
			if(!Config.USE_FALLBACK_VIDEO) return
				
			udpateBufferLevel()
			if(_bufferLevel > 0.7){
				clearTimeout(_checkFillingBufferDuration);
				trace("_bufferLevel HIGH ENOUGH - " + Path.VIDEO_RATES[_currentQualityVideo])
				return
			}
			if(Config.IS_ONLINE || Config.USE_ONLINEVIDEO){	
				_currentQualityVideo++
				if(_currentQualityVideo < Path.VIDEO_QUALITIES.length){
					_videoUrl = Path.VIDEO_QUALITIES[_currentQualityVideo]
					play(_rns.timeWithOffset)
				}
			}
		}
		
		private function isAbleToSeek(time:int):Boolean
		{	
			if(!_metaDataLoaded) return false
			if(!Config.SEEK_SERVER)	return true			
			if(time < _startTimeStream) return false		
			if((_rns.timeWithOffset + _rns.bufferLength) < time) return false
			return true
		}
		
	}
}


class SingletonEnforcer {}