package tv.turbodrive.events
{
	import flash.events.Event;	

	
	 public class ObjectEvent extends BasicEvent
	{
		/** Object stored */
		private var _o : Object;
		
		/**
		 * Creates a new <code>ObjectEvent</code> object.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * @param	o		object carried by this event
		 */
		 public function ObjectEvent( sType : String, oTarget : Object = null, o : Object = null )
		{
			super( sType, oTarget );
			_o = o;
		}
		
		/**
		 * Returns the object carried by this event.
		 * 
		 * @return	the object carried by this event.
		 */
		public function getObject() : Object
		{
			return _o;
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new ObjectEvent(type, target, _o);
		}
	}
}