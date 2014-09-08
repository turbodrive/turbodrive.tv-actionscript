package tv.turbodrive.puremvc.proxy.data
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class ReelNetStream extends NetStream
	{
		public static const BUFFER_FULL:String = "bufferFull"
		public static const BUFFER_EMPTY:String = "bufferEmpty"
		public static const END_VIDEO:String = "endVideo"
		public static const SEEK_NOTIFY:String = "seekNotify"
		
		private var _nc:NetConnection = new NetConnection()
		private var _duration:Number = 0		
		public var timeOffset:Number = 0
			
		public static var META_DATA:String = "metadata";
		public function ReelNetStream()
		{
			_nc.connect(null)
			_nc.addEventListener(NetStatusEvent.NET_STATUS, ncStatus)
			this.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			super(_nc);
			this.client = this
			this.checkPolicyFile = true
			this.soundTransform = new SoundTransform(0);
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void
		{
			if(event.info.code == "NetStream.Buffer.Full") dispatchEvent(new Event(BUFFER_FULL));
			if(event.info.code == "NetStream.Buffer.Empty") dispatchEvent(new Event(BUFFER_EMPTY));			
			if(event.info.code == "NetStream.Play.Stop" && duration > timeWithOffset-1) dispatchEvent(new Event(END_VIDEO))
			if(event.info.code == "NetStream.SeekStart.Notify") dispatchEvent(new Event(SEEK_NOTIFY))
		}
		
		protected function ncStatus(event:NetStatusEvent):void
		{
			trace("[ReelNetStream] ncStatus : " + event.info.code)
		}
		
		public function onMetaData(info:Object):void {
			_duration = info.duration			
			trace("[ReelNetStream] onMetaData")
			dispatchEvent(new Event(META_DATA));
		}
		
		public function onPlayStatus(info:Object):void {
			trace("[ReelNetStream] onPlayStatus : " + info)
		}
		
		public function onXMPData(info:Object):void {
			
		}
		
		public function get timeWithOffset():Number
		{
			return (this.time + timeOffset);
		}		
		
		public function get duration():Number
		{
			return _duration+timeOffset
		}
		
		public function get progressPlay():Number
		{
			if(_duration == 0) return 0			
			return (time/_duration)
		}
	}
}