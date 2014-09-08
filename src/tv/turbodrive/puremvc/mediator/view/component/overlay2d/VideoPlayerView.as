package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.medias.video.VideoDisplay;
	import tv.turbodrive.medias.video.VideoDisplayEvent;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.ClosePlayerButtonView;
	import tv.turbodrive.puremvc.mediator.view.component.FullscreenButtonView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Config;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	import uk.soulwire.utils.display.Alignment;
	import uk.soulwire.utils.display.DisplayUtils;
	
	public class VideoPlayerView extends SpriteDrivenBy3D
	{
		private var _video:Video = new Video(360,240)
		private var _vd:VideoDisplay
		private static var num:int = 0
		private var _introAnim:AnimatedScreen
		
		private var _isDestroying:Boolean = false 
		
		private var _timelineHeight:int = 10
		private var _timeoutVisible:Number;
		private var _page:Page;
		private var _paddingNormal:int = 5
		private var _paddingFs:int = 0
		private var _padding:int = _paddingNormal
			
		private var _noiseLoop:VideoNoiseLoop;		
		private var _closeButton:ClosePlayerButtonView;
		private var _fullscreenButton:FullscreenButtonView;

		private var _shade:ShadeButtonSkills;

		private var hideCloseButtonTimeOut:Number;
		public static const DELAY_MOREPROJECT_SHOW:Number = 1000
		private var _timeline:Sprite = new Sprite();
		private var _timelineProgress:Shape = new Shape();
		private var _timelineBg:Shape = new Shape();
		private var _isFullscreen:Boolean = false
		private var _shapeV:Shape = new Shape();
		private var _background:Shape = new Shape();
			
		private var _rect:RectangleRotation;
		private var _shadeFs:ShadeButtonSkills;

		private var _noFsParent:DisplayObjectContainer;

		private var _reelDuration:Number;
		private var _url:String;
		private var _timeOffset:Number;
		
		public function VideoPlayerView(overlay:Overlay2DView)
		{	
			
			num ++
			this.mouseChildren = false
			this.mouseEnabled = false
			visible = false	
			
			_shapeV.graphics.beginFill(0x000000)
			_shapeV.graphics.drawRect(0,0,1280,720);
			_shapeV.graphics.endFill();
			
			_background.graphics.beginFill(0x000000);
			_background.graphics.drawRect(0,0,1280,720);
			_background.graphics.endFill();
				
			_timelineBg.graphics.beginFill(0x222222,1);
			_timelineBg.graphics.drawRect(0,0,1280,_timelineHeight);
			_timelineBg.graphics.endFill()
			_timeline.addChild(_timelineBg)
				
			_timelineProgress.graphics.beginFill(Colors.VINTAGE_RED,1);
			_timelineProgress.graphics.drawRect(0,0,1280,_timelineHeight);
			_timelineProgress.graphics.endFill()
			_timeline.addChild(_timelineProgress)
				
			_introAnim = new AnimatedScreen();
			_introAnim.mouseChildren = false
			_introAnim.mouseEnabled = true
			_introAnim.gotoAndStop(1);
			_introAnim.onComplete = this.onCompleteAnim
			addChild(_introAnim)
			super(overlay);
			
		}		
		
		private function onCompleteAnim():void
		{
			_introAnim.onComplete = null
			play(_page.project.videoCapture);
			
			this.mouseChildren = true
			this.mouseEnabled = false
			this.buttonMode = true
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, true)
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, true)
			this.addEventListener(MouseEvent.CLICK, clickHandler, true);
				
			_noiseLoop = new VideoNoiseLoop();
			_noiseLoop.buttonMode = _noiseLoop.mouseChildren = _noiseLoop.mouseEnabled = false
			_noiseLoop.width = _video.width
			_noiseLoop.height = _video.height
			_noiseLoop.x = _video.x
			_noiseLoop.y = _video.y
				
			addChild(_noiseLoop)
			
			if(!_page.project.isSecondaryProject){
				_shade = new ShadeButtonSkills();
				_shade.mouseEnabled = _shade.mouseChildren = false
				_shade.alpha = 0
				addChild(_shade)
					
				// add Close Button
				_closeButton = new ClosePlayerButtonView();
				_closeButton.addEventListener(MouseEvent.CLICK, clickCloseHandler)
				_closeButton.visible = false
				_closeButton.alpha = 0
				
				_closeButton.panelRollOver()
				TweenMax.to(_closeButton,0.5, {autoAlpha:1});
				//hideCloseButtonTimeOut = setTimeout(_closeButton.panelRollOut, 1500)
			}
			
			_shadeFs = new ShadeButtonSkills();
			_shadeFs.mouseEnabled = _shadeFs.mouseChildren = false
			_shadeFs.alpha = 0
			addChild(_shadeFs)
			
			if(_closeButton) addChild(_closeButton);
			
			// add Close Button
			_fullscreenButton = new FullscreenButtonView();
			_fullscreenButton.addEventListener(MouseEvent.CLICK, switchFullScreen)
			_fullscreenButton.visible = false
			_fullscreenButton.alpha = 0
			addChild(_fullscreenButton);
			_fullscreenButton.panelRollOver()
			TweenMax.to(_fullscreenButton,0.5, {autoAlpha:1});
			hideCloseButtonTimeOut = setTimeout(hideControls, 1500)
			
			_timeline.addEventListener(MouseEvent.CLICK, clickTimelineHandler)
			_timeline.buttonMode = true
			_timeline.alpha = 0
			addChild(_timeline)
			TweenMax.to(_timeline,0.3, {alpha:1});

		}
		
		private function hideControls():void
		{
			if(_closeButton) _closeButton.panelRollOut()
			_fullscreenButton.panelRollOut()
			TweenMax.to(_timeline,0.5, {alpha:0});
		}
		
		protected function clickTimelineHandler(event:MouseEvent):void
		{
			var scaleTime:Number = (event.localX / 1280)
			seekVideo(_reelDuration*scaleTime)
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			
			if(!_closeButton || (_closeButton && event.target != _closeButton)){
				
				if(_vd && event.target != _fullscreenButton){
					if(_vd.getIsPlaying()){
						_vd.pauseVideo();
						TweenMax.to(_video, 0.2, {alpha:0.3})
					}else{
						_vd.resumeVideo();
						TweenMax.to(_video, 0.5, {alpha:1})
					}
				}
			}
		}
		
		private function switchFullScreen(e:Event):void
		{
			_isFullscreen = !_isFullscreen	
			if(_isFullscreen){
				_noFsParent = parent;
				addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
				Sprite(parent.parent.root).addChild(this);
				_fullscreenButton.changeState(true);				
				_padding = _paddingFs
				rotation = 0
				addChildAt(_background,0)
				resizeHandler();
			}else{
				
				_fullscreenButton.changeState(false);
				_padding = _paddingNormal
				removeChild(_background)
				_noFsParent.addChild(this)
			}
			
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler)
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler)
			resizeHandler();
		}
		
		protected function removedFromStageHandler(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeHandler)
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler)
		}
		
		protected function resizeHandler(event:Event = null):void
		{
			DisplayUtils.fitIntoRect(_shapeV,new Rectangle(0,0,stage.stageWidth, stage.stageHeight-_timelineHeight), false, Alignment.MIDDLE,true);
			
			_rect = new RectangleRotation(_shapeV.x,_shapeV.y,_shapeV.width,_shapeV.height);
			_background.height = stage.stageHeight
			_background.width = stage.stageWidth
			_background.x = -_shapeV.x
			_background.y = -_shapeV.y
			updateInternal()
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if(hideCloseButtonTimeOut )clearTimeout(hideCloseButtonTimeOut);
			if(_closeButton){
				if(event.target != _closeButton){
					_closeButton.panelRollOut()
					TweenMax.to(_shade, 0.3, {alpha:0})
				}else{
					_closeButton.rollOut()
					TweenMax.to(_shade, 0.3, {alpha:0})
				}
			}
			
			if(event.target != _fullscreenButton){
				_fullscreenButton.panelRollOut()
				TweenMax.to(_shadeFs, 0.3, {alpha:0})
			}else{
				_fullscreenButton.rollOut()
				TweenMax.to(_shadeFs, 0.3, {alpha:0})
			}
			
			TweenMax.to(_timeline, 0.3, {alpha : 0})
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(hideCloseButtonTimeOut )clearTimeout(hideCloseButtonTimeOut);
			if(_closeButton){
				if(event.target == _closeButton){
					_closeButton.rollOver()
					TweenMax.to(_shade, 0.1, {alpha:0.5})
				}else{
					_closeButton.panelRollOver();
					TweenMax.to(_shade, 0.3, {alpha:0})
				}
			}
			
			if(event.target == _fullscreenButton){
				_fullscreenButton.rollOver()
				TweenMax.to(_shadeFs, 0.1, {alpha:0.5})
			}else{
				_fullscreenButton.panelRollOver()
				TweenMax.to(_shadeFs, 0.3, {alpha:0})
			}
			
			if(event.target == _timeline){
				TweenMax.to(_timeline, 0.3, {alpha : 1})
			}else{
				TweenMax.to(_timeline, 0.3, {alpha : 0.65})
			}
		}
		
		override public function buildContent(page:Page):void
		{
			if(_isDestroying){
				return
			}
			_page = page
			var timeAppear:int = page.project.isSecondaryProject ? DELAY_MOREPROJECT_SHOW : 0
			_timeoutVisible = setTimeout(switchVisible,timeAppear)			
		}
		
		protected function clickCloseHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Overlay2DView.NAVIGATE_TO_SUBPAGE, this, SubPageNames.MAIN))
		}
		
		public function switchVisible():void
		{
			visible = true
			_introAnim.play();
		}
		
		public function play(url:String):void
		{
			if(!_vd){
				_vd = new VideoDisplay(_video, true, false);
				_vd.addEventListener(VideoDisplayEvent.ON_PLAY_HEAD_TIME_CHANGE_EVENT, enterFrameVideoHandler)
				_vd.addEventListener(VideoDisplayEvent.ON_META_DATA_EVENT, onMetaDataHandler)
				_vd.addEventListener(VideoDisplayEvent.ON_START_STREAM_EVENT, startStreamHandler)
				_vd.addEventListener(VideoDisplayEvent.ON_BUFFER_EMPTY_EVENT, bufferEmptyHandler)
				_vd.addEventListener(VideoDisplayEvent.ON_BUFFER_FULL_EVENT, bufferFullHandler)
			}
			if(!contains(_video)){
				addChildAt(_video,1)
			}
			
			_url = url
			_video.x = _video.y = _padding
			_timeOffset = 0
			_vd.load(url)
			_vd.setVolume(Config.GLOBAL_VOLUME)
			_vd.setBufferTime(5);
		}
		
		protected function onMetaDataHandler(event:Event):void
		{
			_vd.removeEventListener(VideoDisplayEvent.ON_META_DATA_EVENT, onMetaDataHandler)
			_reelDuration = _vd.getDuration();
		}
		
		public function seekVideo(time:Number):void
		{
			time = int(time)
			
			if(Config.SEEK_SERVER){
				_timeOffset = time
				bufferEmptyHandler(null)
				_vd.load(_url + "?start=" + String(time))
			}else{
				_timeOffset = 0
				_vd.setPlayHead(time)
			}
			TweenMax.to(_video, 0.5, {alpha:1})
		}
		
		protected function enterFrameVideoHandler(event:Event):void
		{			
			_timelineProgress.scaleX = (_vd.getPlayHead()+_timeOffset)/_reelDuration
		}
		
		protected function bufferFullHandler(event:Event):void
		{
			if(_noiseLoop) _noiseLoop.stop()
			if(contains(_noiseLoop)) removeChild(_noiseLoop)
		}
		
		protected function bufferEmptyHandler(event:Event):void
		{
			if(_noiseLoop) _noiseLoop.gotoAndPlay(1)
			if(!contains(_noiseLoop)){
				var targetDepth:int = numChildren-1
				if(_closeButton){
					targetDepth = getChildIndex(_closeButton)
				}else if(_timeline){
					targetDepth = getChildIndex(_timeline)-1
				}
				addChildAt(_noiseLoop,targetDepth)
			}
		}
		
		protected function startStreamHandler(event:Event):void
		{
			//TweenMax.to(_timeline,0.3, {alpha:1});
			bufferFullHandler(event);
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{
			if(_destroyed) return
			if(_isFullscreen) return
			_rect = rect			
			
			updateInternal()
			rotation = extraRotation//rect.rotation
		}
		
		private function updateInternal():void
		{			
			x = _rect.x
			y = _rect.y
			
			var scaleAnimX:Number = (_rect.width/704)
			var scaleAnimY:Number = (_rect.height/396)
			_introAnim.scaleX = scaleAnimX
			_introAnim.scaleY = scaleAnimY
			
			if(_closeButton){
				if(_isFullscreen){
					_closeButton.x = stage.stageWidth-x-_closeButton.width
				}else{
					_closeButton.x = _rect.width-_closeButton.width					
				}
				_shade.x = _closeButton.x
			}
			
			_video.width = _rect.width-(_padding*2)
			_video.height = _rect.height-(_padding*2)
			if(_noiseLoop){
				_noiseLoop.width = _video.width
				_noiseLoop.height = _video.height
				_noiseLoop.x = _video.x
				_noiseLoop.y = _video.y
			}
			
			if(_fullscreenButton){
				if(_isFullscreen){
					_fullscreenButton.x = stage.stageWidth-x - _fullscreenButton.width
					_fullscreenButton.y = stage.stageHeight-y - _fullscreenButton.height - _timelineHeight
				}else{
					_fullscreenButton.x = _rect.width - _fullscreenButton.width
					_fullscreenButton.y = _video.height - _fullscreenButton.height - _timelineHeight				
				}				
				_shadeFs.x = _fullscreenButton.x
				_shadeFs.y = _fullscreenButton.y
			}
			
			if(_timeline){
				if(!_isFullscreen){
					_timeline.y = (_video.height+_padding*2) - _timeline.height
					_timeline.width = _video.width+_padding*2
					_timeline.x = 0
				}else{
					_timeline.y = stage.stageHeight - _timelineHeight
					_timeline.x = -x
					_timeline.width = stage.stageWidth
				}
			}
		}	
		
		private function stop():void
		{
			if(!_vd) return
			_vd.pauseVideo();
		}
		
		override public function resume():void
		{
			if(_introAnim.onComplete) _introAnim.play()
			
			if(!_vd) return
			_vd.resumeVideo();
		}
		
		override public function pause():void{
			_introAnim.stop()
			if(!_vd) return
			_vd.pauseVideo();
		}
		
		override public function hideAndRemove():Boolean
		{
			clearTimeout(_timeoutVisible)
			_timeoutVisible = NaN
			if(_isDestroying) return true
			
			_introAnim.stop();
			if(contains(_introAnim)){
				removeChild(_introAnim)
			}
				
			_isDestroying = true
			TweenMax.to(this,0.1, {alpha:0, onComplete:destroy})
			stop();
			return true
		}
		
		override public function destroy():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler, true)
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler, true)
			this.removeEventListener(MouseEvent.CLICK, clickHandler, true)
			
			//_fullscreenButton.removeEventListener(MouseEvent.CLICK, clickCloseHandler)
			if(_closeButton) _closeButton.removeEventListener(MouseEvent.CLICK, clickCloseHandler)
			
			_timeline.removeEventListener(MouseEvent.CLICK, clickTimelineHandler)
			_destroyed = true
			if(_noiseLoop){
				_noiseLoop.stop();
				if(contains(_noiseLoop)) removeChild(_noiseLoop)
				_noiseLoop = null
			}
				
			if(_vd){
				_vd.removeEventListener(VideoDisplayEvent.ON_START_STREAM_EVENT, startStreamHandler)
				_vd.removeEventListener(VideoDisplayEvent.ON_BUFFER_EMPTY_EVENT, bufferEmptyHandler)
				_vd.removeEventListener(VideoDisplayEvent.ON_BUFFER_FULL_EVENT, bufferFullHandler)
				_vd.release();
				_vd = null
			}	
			
			_introAnim = null
			
			stop();			
			visible = false
			super.destroy()
		}
	}
}