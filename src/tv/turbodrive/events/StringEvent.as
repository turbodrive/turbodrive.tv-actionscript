package tv.turbodrive.events
{
	import flash.events.Event;	
	
	public class StringEvent extends BasicEvent
	{
		private var _s : String;
		
		/**
		 * Creates a new <code>StringEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	string	string value carried by this event
		 */
		public function StringEvent( type : String, target : Object = null, string : String = "" )
		{
			super( type, target );
			_s = string;
		}
		
		/**
		 * Returns the string value carried by this event.
		 * 
		 * @return	the string value carried by this event.
		 */
		public function getString() : String
		{
			return _s;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new StringEvent(type, target, _s);
		}
	}
}