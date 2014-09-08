package tv.turbodrive.medias.video
{
	import flash.events.Event;
	
	import tv.turbodrive.medias.video.VideoDisplay
	/**
	 * ...
	 * @author Viseth Chum d'après Bourre (Framework Lowra)
	 */
	public class VideoDisplayEvent extends Event
	{
		static public const ON_PLAY_COMPLETE_EVENT:String = "onPlayCompleteEvent";
		public static const ON_PLAY_HEAD_TIME_CHANGE_EVENT:String = new String("onPlayHeadTimeChange");
		public static const ON_START_STREAM_EVENT:String = new String("onStartStream");
		public static const ON_STOP_STREAM_EVENT:String = new String("onStopStream");
		public static const ON_END_VIDEO_EVENT:String = new String("onEndVideo");
		public static const ON_META_DATA_EVENT:String = new String("onMetaData");
		public static const ON_BUFFER_EMPTY_EVENT:String = new String("onBufferEmpty");
		public static const ON_BUFFER_FULL_EVENT:String = new String("onBufferFull");
		public static const ON_RESIZE_EVENT:String = new String("onResize");
		public static const ON_CUE_POINT_EVENT:String = new String("onCuePoint");
		public static const ON_ERROR_EVENT:String = new String("onError");
		static public const ON_LOOP_EVENT:String = new String('onLoop');
		
		public static const ON_BUFFER_FLUSH:String = new String('onBufferFlush');
		
		public static const FAILED_EVENT:String = new String('failed');
		public static const STREAM_NOT_FOUND_EVENT:String = new String('streamNotFound');
		public static const INVALID_TIME_EVENT:String = new String('invalidTime');
		
		
		private var _videoDisplay:VideoDisplay = new VideoDisplay();
		
		public function VideoDisplayEvent(videoDisplay:VideoDisplay, type:String, bubbles:Boolean = true, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			
			_videoDisplay = videoDisplay;
		}
		
		public function getVideoURL():String
		{
			return _videoDisplay.getVideoURL();
		}
		
		public function getVideo():Object
		{
			return _videoDisplay.getVideo(); 
		}

		public function getDuration():Number
		{
			return _videoDisplay.getDuration();
		}
	
		public function getPlayHead():Number
		{
			return _videoDisplay.getPlayHead();
		}
		
		public function getBufferTime():Number
		{
			return _videoDisplay.getBufferTime();
		}
		
		public function getFramerate():Number
		{
			return _videoDisplay.getFramerate();
		}
		
		public function getIsLoaded():Boolean
		{
			return _videoDisplay.getIsLoaded();
		}
		
		public function getBufferLength():Number
		{
			return _videoDisplay.getBufferLength();
		}
		
		public function getBytesLoaded():Number
		{
			return _videoDisplay.getBytesLoaded();
		}
		
		public function getBytesTotal():Number
		{
			return _videoDisplay.getBytesTotal();
		}
	}
}