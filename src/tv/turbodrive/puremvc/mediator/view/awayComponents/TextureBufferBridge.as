package tv.turbodrive.puremvc.mediator.view.awayComponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.core.View;
	
	import tv.turbodrive.events.NumberEvent;

	public class TextureBufferBridge extends EventDispatcher
	{
		public static var videoContainer:Sprite;
		private static var _instance:TextureBufferBridge;

		public static const BUFFER_READY:String = "bufferReady";
		public static const HIDE_PLAYER_2D:String = "hidePlayer2d";
		public static const SHOW_PLAYER_2D:String = "showPlayer2d";
		
		
		public function TextureBufferBridge(requires:SingletonEnforcer)
		{
			if (!requires) throw new Error("TextureBuffer is a singleton, use static instance.");
		}
		
		static public function get instance():TextureBufferBridge 
		{
			if (!_instance) _instance = new TextureBufferBridge(new SingletonEnforcer());
			return _instance;
		}
		
		public function isReady():Boolean
		{
			return videoContainer.stage
		}
		
		public function dispatchBufferReady():void
		{			
			trace("bufferREADY")
			dispatchEvent(new Event(BUFFER_READY));
		}
		
		public function dispatchHidePlayer2D():void
		{			
			dispatchEvent(new Event(HIDE_PLAYER_2D));
		}
		
		public function dispatchShowPlayer2D(duration:Number):void
		{			
			dispatchEvent(new NumberEvent(SHOW_PLAYER_2D,this,duration));
		}
		
	}
}

class SingletonEnforcer {}