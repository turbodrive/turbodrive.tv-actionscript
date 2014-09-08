package tv.turbodrive.events
{
	import flash.events.Event;
	
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class TransitionEvent extends Event
	{
		static public const TRANSITION_STARTS:String  = "transitionStarts";
		static public const TRANSITION_COMPLETE:String = "transitionComplete"
		public static const MULTIPART_RESUME:String = "multiPartResume"
		public static const FIRSTOFMULTI_COMPLETE:String = "firstOfMultiCOmplete"
		
		private var _t:TransitionPageData;
		
		public function TransitionEvent(type:String, transition:TransitionPageData, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			_t = transition
		}
		
		
		public function get transition():TransitionPageData
		{
			return _t
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new TransitionEvent(type, _t, bubbles, cancelable);
		}
	}
}