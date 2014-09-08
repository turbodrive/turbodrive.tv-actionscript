package tv.turbodrive.events
{
	import flash.events.Event;

	public class InternalTransitionEvent extends Event
	{
		private var _internalSubPage:String
		private var	_transitionName:String
		
		public function InternalTransitionEvent(type:String, internalSubPage:String, transitionName:String="", bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			_internalSubPage = internalSubPage
			_transitionName = transitionName
		}
		
		
		public function get transitionName():String
		{
			return _transitionName
		}
		
		public function get internalSubPage():String
		{
			return _internalSubPage
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new InternalTransitionEvent(type, _internalSubPage, _transitionName, bubbles, cancelable);
		}
	}
}