package tv.turbodrive.medias.video
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;	
	import flash.events.NetStatusEvent
	
	import tv.turbodrive.utils.tick.TickListener;
	import tv.turbodrive.utils.tick.TickDispatcher;	
	import tv.turbodrive.medias.video.VideoDisplayEvent;
	
	/**
	 * ...
	 * @author Viseth Chum d'après Bourre (Framework Lowra)
	 */
	public class VideoDisplay extends EventDispatcher implements TickListener
	{
		//Attributs
		private var _connection:NetConnection;
		private var _flux:NetStream;
		private var _videoSound:SoundTransform;
		private var _videoURL:String = new String();
		private var _video:Video;
		
		private var _isFirstPlaying:Boolean;
		private var _clientFlux:Object;
		
		private var _autoPlay:Boolean;
		private var _autoSize:Boolean;
		private var _bufferTime:Number;
		private var _loopPlayBack:Boolean;
		
		private var _bufferLength:Number;
		
		private var _bytesTotal:Number;
		private var _bytesLoaded:Number;
		
		private var _isPlaying:Boolean = new Boolean(false);
		private var _isLoaded:Boolean;
		
		private var _onCompleteBackToFirstFrame:Boolean = true;
		
		private var _width:Number;
		private var _height:Number;
		private var _duration:Number;
		private var _framerate:Number;
		
		private var _currentVolume:Number;
		private var _playHead:Number;
		private var _tickDispatcher:TickDispatcher;
		private var _loopPosition:Number = new Number(0);
		
		private var _falseDuration:Number = new Number();
		
		//Constructeur
		public function VideoDisplay(video:Video = null, autoPlay:Boolean = true, autoSize:Boolean = true, bufferTime:Number = 2) 
		{		
			if (video != null) _video = video;
			else _video = new Video();
			
			_autoPlay = autoPlay;
			_autoSize = autoSize;
			_bufferTime = bufferTime;
			
			_loopPlayBack = new Boolean(false);
			_isLoaded = new Boolean(false);
			
			_isPlaying = new Boolean(false);
			
			_tickDispatcher = TickDispatcher.getInstance();
		}
		
		//Méthodes
		public function setVolume(value:Number):void
		{
			if (value > 1) value = 1;
			else if (value < 0) value = 0;
			
			_currentVolume = value;
			
			_videoSound.volume = value;
			_flux.soundTransform = _videoSound;
		}
		
		public function muteVolume():void
		{
			_videoSound.volume = 0;
			_flux.soundTransform = _videoSound;
		}
		
		public function resumeVolume():void
		{
			_videoSound.volume = _currentVolume;
			_flux.soundTransform = _videoSound;
		}
		
		public function playVideo():void
		{
			setPlaying(true);
			
			if (_isFirstPlaying)
			{
				_isFirstPlaying = false;
				
				_flux.play(_videoURL);
					
				if (!_autoPlay) stopVideo();
			}
			else
			{
				resumeVideo();
			}
		}
		
		public function pauseVideo():void
		{
			setPlaying(false);
			
			_flux.pause();
		}
		
		public function resumeVideo():void
		{
			setPlaying(true);
			_flux.resume();
		}
		
		public function stopVideo():void
		{
			setPlaying(false);
			
			_flux.pause();
			if(_onCompleteBackToFirstFrame)
				_flux.seek(0);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_autoSize = false;
			
			_video.width = width;
			_video.height = height;
		}
		
		
		public function load(videoURL:String):void
		{
			_connection = new NetConnection();
			_connection.connect(null);
			
			_flux = new NetStream(_connection);
			_flux.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
			_flux.bufferTime = _bufferTime;
			
			_videoSound = new SoundTransform();
			_videoSound = _flux.soundTransform;
			
			_currentVolume = new Number(1);
			
			_videoURL = videoURL;
			
			_video.attachNetStream(_flux);
			_video.smoothing = true;
			
			_isFirstPlaying = new Boolean(true);
		
			_playHead = new Number(0);
			
			//Ajout des écouteurs
			_clientFlux = new Object();
			_clientFlux.onCuePoint = onCuePointHandler;
			_clientFlux.onImageData = onImageDataHandler;
			_clientFlux.onMetaData = onMetaDataHandler;
			_clientFlux.onPlayStatus = onPlayStatusHandler;
			_clientFlux.onTextData = onTextDataHandler;
			_clientFlux.onXMPData = onXMPDataHandler;
			_flux.client = _clientFlux;
			
			playVideo();
		}
		
		public function backPlay(value:Number):void
		{
			_flux.seek(_flux.time + value);
			_playHead = _flux.time;
		}
		
		public function forwardPlay(value:Number):void
		{
			_flux.seek(_flux.time - value);
			_playHead = _flux.time;
		}
		
		public function release():void
		{
			setPlaying(false);
			
			_flux.close();
			_connection.close();
			_video.clear();
		}
		
		public function close():void
		{
			
			_connection.close();
			
		}
		
		public function setLoopPlayback(value:Boolean, position:Number = 0):void
		{
			if (_loopPlayBack != value)
			{
				_loopPlayBack = value;
				_loopPosition = position;
			}
		}
		
		public function onTick(event:Event = null ):void
		{
			//trace('ON TICK');
			onPlayHeadTimeChanged();
		}
		
		protected function setPlaying(value:Boolean):void
		{
			if (value != _isPlaying)
			{
				_isPlaying = value;
				
				if (_isPlaying) {
					_tickDispatcher.addTickListener(this);
				}
				else {
					_tickDispatcher.removeTickListener(this);
				}
			}
		}
		
		protected function onPlayHeadTimeChanged():void
		{
			fireEventType(VideoDisplayEvent.ON_PLAY_HEAD_TIME_CHANGE_EVENT);
		}
		
		private function loopVideo(position:Number):void
		{
			fireEventType(VideoDisplayEvent.ON_LOOP_EVENT);
			setPlaying(true);
			_flux.seek(position);
			
		}
		
		/* **** Méthodes NetStream**** */
		//onCuePoint(), onImageData(), onMetaData(), onPlayStatus(), onTextData() et onXMPData()
		
		private function onCuePointHandler(info:Object):void
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		private function onImageDataHandler(info:Object):void
		{
              trace("imageData length: " + info.data.length);
		}
		
		private function onMetaDataHandler(info:Object):void
		{
			//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			_duration = info.duration;
			_width = info.width;
			_height = info.height;
			
			//_framerate = info.framerate ? info.framerate : 25;
			if (info.framerate) {
				_framerate = info.framerate
			}else {
				_framerate = 25
			}
			
			_falseDuration = _duration - (2 / _framerate);
			//_falseDuration = (Math.round(_falseDuration * 100)) / 100;
					
			if (_autoSize)
			{
				_video.width = info.width;
				_video.height = info.height;
			}
			
			fireEventType(VideoDisplayEvent.ON_META_DATA_EVENT);
		}
		
		private function onPlayStatusHandler(info:Object):void
		{
			trace("************************ onPlayStatusHandler + " +  info)
			
			switch ( info.code ) 
			{
				case 'NetStream.Play.Complete' :
					//trace('**** START ****');
					fireEventType(VideoDisplayEvent.ON_PLAY_COMPLETE_EVENT);
				break;
			}
		}
		
	
		
		protected function netStatusHandler ( event : NetStatusEvent ) : void
		{				
				//trace(event.info.code);
				//Logger.DEBUG("netStatusHandler " + event.info.code)
			
				switch ( event.info.code ) 
				{
					case 'NetStream.Play.Start' :
						//trace('**** START ****');
						fireEventType(VideoDisplayEvent.ON_START_STREAM_EVENT);
					break;
							
					case 'NetStream.Play.Stop' :
						//trace('**** STOP ****');
						fireEventType(VideoDisplayEvent.ON_STOP_STREAM_EVENT);
						
						setPlaying(false);
						
						if ((_isLoaded) && (_flux.time > _falseDuration))
						{
							fireEventType(VideoDisplayEvent.ON_END_VIDEO_EVENT);
						
							if (_loopPlayBack)
							{
								loopVideo(_loopPosition);
							}
							else
							{
								stopVideo();
							}
						}
					break;
					
					case 'NetStream.Play.Failed' :
						fireEventType(VideoDisplayEvent.FAILED_EVENT);
					break;
						
					case 'NetStream.Play.StreamNotFound' :
						trace("stream not found : "+_videoURL);
						fireEventType(VideoDisplayEvent.STREAM_NOT_FOUND_EVENT);
					break;
							
					case 'NetStream.Seek.InvalidTime' :
						fireEventType(VideoDisplayEvent.INVALID_TIME_EVENT);
					break;
						
					case 'NetStream.Buffer.Full' :
						_isLoaded = true;
						//trace('******* FULL *********');
						fireEventType(VideoDisplayEvent.ON_BUFFER_FULL_EVENT);
					break;
						
					case 'NetStream.Buffer.Empty' :
						fireEventType(VideoDisplayEvent.ON_BUFFER_EMPTY_EVENT);
					break;
					
					case 'NetStream.Buffer.Flush' :
						fireEventType(VideoDisplayEvent.ON_BUFFER_FLUSH);
					break;
				}
		}
		
		private function fireEventType(eventName:String):void
		{
			try 
			{
				dispatchEvent(new VideoDisplayEvent(this, eventName));
			}
			catch(e:Error)
			{
				
			}
		}
		
		private function onTextDataHandler(info:Object):void
		{
			//trace('textData : ' + info);
			
			var key:String;

			for (key in info)
			{
				trace(key + ": " + info[key]);
			}

		}
		
		private function onXMPDataHandler(info:Object):void
		{
			//trace('XMPData : ' + info);
		}
		
		//Getters
		public function getVideoURL():String { return _videoURL; }
		public function getAutoPlay():Boolean { return _autoPlay; }
		public function getAutoSize():Boolean { return _autoSize; }
		public function getBufferTime():Number { return _bufferTime; }
		public function getIsPlaying():Boolean { return _isPlaying; }
		public function getWidth():Number { return _width; }
		public function getHeight():Number { return _height; }
		public function getDuration():Number { return _duration; }
		public function getFramerate():Number { return _framerate; }
		public function getIsLoaded():Boolean { return _isLoaded; }
		public function getVideo():Video { return _video; }
		public function getLoopPlayBack():Boolean { return _loopPlayBack; }
		public function getFalseDuration():Number { return _falseDuration; }
		
		public function getPlayHead():Number
		{ 
			if (_flux) return _flux.time;
			else return 0;
		}
		
		public function getPercentage():Number
		{
			var percentage:Number = new Number();
			percentage = (getPlayHead() / _duration) * 100;
			percentage = (Math.round(percentage * 100)) / 100;
			
			return percentage;
		}
		
		//Setters
		public function setVideoURL(value:String):void 
		{
			_videoURL = value;
		}
		
		public function setAutoPlay(value:Boolean):void 
		{
			_autoPlay = value;
		}
		
		public function setAutoSize(value:Boolean):void 
		{
			_autoSize = value;
		}
		
		public function setBufferTime(value:Number):void 
		{
			_bufferTime = value;
		}
		
		public function setPlayHead(value:Number):void 
		{
			_playHead = value;
			_flux.seek(value);
		}
		
		public function set onCompleteBackToFirstFrame(value:Boolean):void
		{
			_onCompleteBackToFirstFrame = value;
		}
		
		public function get bufferTime():Number { return _flux.bufferTime; }
		
		public function getBytesTotal():Number {
			if(!_flux) return 0
			return _flux.bytesTotal;
		}
		
		public function getBytesLoaded():Number {
			if(!_flux) return 0
			return _flux.bytesLoaded;
		}
		
		public function getBufferLength():Number { return _flux.bufferLength; }
		
		
	}

}