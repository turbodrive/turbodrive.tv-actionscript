
package tv.turbodrive.events
{
	import flash.events.Event;	
	
	
	public class BooleanEvent extends BasicEvent
	{
		private var _b : Boolean;
		
		/**
		 * Creates a new <code>BooleanEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	bool	boolean value carried by this event
		 */
		public function BooleanEvent( type : String, target : Object = null, bool : Boolean = false )
		{
			super( type, target );
			_b = bool;
		}
		
		/**
		 * Returns the boolean value carried by this event.
		 * 
		 * @return	the boolean value carried by this event.
		 */
		public function getBoolean() : Boolean
		{
			return _b;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new BooleanEvent(type, target, _b);
		}
	}
}