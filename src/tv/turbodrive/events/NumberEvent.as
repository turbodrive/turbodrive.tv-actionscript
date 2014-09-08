
package tv.turbodrive.events
{
	import flash.events.Event;	
	
	
	public class NumberEvent extends BasicEvent
	{
		private var _n : Number;
		
		/**
		 * Creates a new <code>NumberEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	num		numeric value carried by this event
		 */
		public function NumberEvent( type : String, target : Object = null, num : Number = 0, bubbles:Boolean = false )
		{
			super( type, target, bubbles );
			_n = num;
		}
		
		/**
		 * Returns the numeric value carried by this event.
		 * 
		 * @return	the numeric value carried by this event.
		 */
		public function getNumber() : Number
		{
			return _n;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new NumberEvent(type, target, _n);
		}
	}
}