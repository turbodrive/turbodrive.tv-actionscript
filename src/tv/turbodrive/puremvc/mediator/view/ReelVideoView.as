package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.mediator.view.awayComponents.TextureBufferBridge;
	import tv.turbodrive.puremvc.proxy.data.ReelNetStream;
	import tv.turbodrive.utils.Config;
	
	import uk.soulwire.utils.display.Alignment;
	import uk.soulwire.utils.display.DisplayUtils;

	public class ReelVideoView extends Sprite
	{	
		
		static public const CLICK_REEL:String = "ClickReel"
		
		private var _tryStageVideo:Boolean = false
		
		private var _video:Video
		
		private var _ns:ReelNetStream;
		private var _sv:StageVideo;
		private var _shapeV:Shape = new Shape();		
		private var _background:Shape = new Shape();
		private var _globalVisibility:Boolean = true
		
		private var _clickEnabled:Boolean = false;
		public var flashWhiteEnabled:Boolean = false;
	
		public function ReelVideoView()
		{			
			TweenPlugin.activate([SoundTransformPlugin]);
			
			updateStream()
			_shapeV.graphics.beginFill(0x000000)
			_shapeV.graphics.drawRect(0,0,1280,720);
			_shapeV.graphics.endFill();
			
			_background.graphics.beginFill(0x000000);
			_background.graphics.drawRect(0,0,1280,720);
			_background.graphics.endFill();
			//_background.visible = false		
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		public function get clickEnabled():Boolean
		{
			return _clickEnabled;
		}

		private function checkClickEnabled():void
		{
			if(parent && _clickEnabled){
				this.addEventListener(MouseEvent.CLICK, clickVideoHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				this.buttonMode = true;
			}else{
				this.removeEventListener(MouseEvent.CLICK, clickVideoHandler);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				this.buttonMode = false;
			}
		}
		
		public function set clickEnabled(value:Boolean):void
		{
			_clickEnabled = value;
			checkClickEnabled();
		}

		public function get globalVisibility():Boolean
		{
			return _globalVisibility
		}

		public function set globalVisibility(value:Boolean):void
		{
			_globalVisibility = visible = value;
			if(_background) _background.visible = value
		}

		public function updateStream():void
		{
			_ns = ReelVideoPlayer.instance.stream
		}
		
		protected function addedToStageHandler(event:Event):void
		{					

			//if(_ns){
				// remet le volume normal
				_ns.soundTransform = new SoundTransform(Config.GLOBAL_VOLUME)
				//stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailableHandler)
				onStageVideoAvailableHandler(null)
				_ns.resume()
			//}
			
			TextureBufferBridge.videoContainer = this
			TextureBufferBridge.instance.addEventListener(TextureBufferBridge.HIDE_PLAYER_2D, hideVideo)
			TextureBufferBridge.instance.addEventListener(TextureBufferBridge.SHOW_PLAYER_2D, showVideo)
			
			parent.addChildAt(_background,0);			
			this.mouseEnabled = true;
			this.mouseChildren = false;			
			parent.mouseEnabled = false;
			if(!Config.IS_ONLINE) _clickEnabled = true
			checkClickEnabled()
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);	
			//this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}		
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if(flashWhiteEnabled) TweenMax.to(this, 0.1, {colorTransform:{exposure:1.4}});
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			TweenMax.to(this, 0.5, {colorTransform:{exposure:1}, ease:Quart.easeOut});
		}
		
		protected function clickVideoHandler(event:MouseEvent):void
		{	
			//TweenMax.to(this,0.5,{removeTint:true,ease:Quart.easeOut});
			dispatchEvent(new Event(CLICK_REEL));
		}
		
		public function hideVideo(e:Event):void
		{		
			TweenMax.to(this,0.5,{delay:0.3, autoAlpha:0});
			TweenMax.to(_background,0.3,{delay:0.2, autoAlpha:0});
			TweenMax.to(_ns,0.5,{delay:0.3, soundTransform:{volume:0}})
			// TODO // Gérer ajout/retirement de la vidéo sur le stage >> Pas mal de soucis à ce niveau.
			setTimeout(removePlayerFromStage,1500)
		}
		
		public function removePlayerFromStage():void
		{
			ReelVideoPlayer.instance.pause();
			//if(parent) parent.removeChild(this);
		}
		
		protected function showVideo(event:NumberEvent):void
		{			
			var duration:Number = event.getNumber();
			var showDelay:Number = duration-0.1
			
			TweenMax.to(this,0.1,{delay:duration, autoAlpha:1});
			TweenMax.to(_background,0.1,{delay:duration, autoAlpha:1});
			TweenMax.to(_ns,duration,{soundTransform:{volume:Config.GLOBAL_VOLUME}, ease:Quad.easeIn})
			//resizeHandler(null);
		}	
		
		protected function onStageVideoAvailableHandler(event:StageVideoAvailabilityEvent):void
		{
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailableHandler)
			/*if (event.availability == StageVideoAvailability.AVAILABLE && _tryStageVideo) {
				// Au moins un StageVideo est disponible dans le Vector stageVideos
				_sv = stage.stageVideos[0];
				_sv.attachNetStream(_ns);
			}else {*/
				_video = new Video();
				_video.smoothing = true;
				_video.attachNetStream(_ns);
				_video.width = 1280;
				_video.height = 720;
				addChild(_video);
				// ?? ne marche pas si on ne seek pas ??
				if(!Config.IS_ONLINE) _ns.seek(0)
		//	}
			
			resize();
		}
		
		private function switchNetStream():void
		{
			if(!_video){
				_video = new Video()
				_video.attachNetStream(_ns);
				_video.width = 1280
				_video.height = 720
				addChild(_video)
				setTimeout(switchNetStream,5000);
				resize();
			}else{
				_video.clear();
				_sv.attachNetStream(_ns)
			}			
		}
		
		protected function resizeHandler(event:Event):void
		{
			resize();
		}
		
		protected function removeFromStageHandler(event:Event):void
		{	
			TextureBufferBridge.videoContainer = null
			TextureBufferBridge.instance.removeEventListener(TextureBufferBridge.HIDE_PLAYER_2D, hideVideo)
			TextureBufferBridge.instance.removeEventListener(TextureBufferBridge.SHOW_PLAYER_2D, showVideo)
			
			if(_background && _background.parent) _background.parent.removeChild(_background)
			stage.removeEventListener(Event.RESIZE, resizeHandler);
			checkClickEnabled()
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}	
		
		private function resize():void
		{
			var matrix:Matrix = DisplayUtils.fitIntoRect(_shapeV,new Rectangle(0,0,stage.stageWidth, stage.stageHeight-4), false, Alignment.MIDDLE,true);
			
			if(_video){
				this.transform.matrix = matrix;
			}
			_background.width = stage.stageWidth
			_background.height = stage.stageHeight			
		}	
	}
}