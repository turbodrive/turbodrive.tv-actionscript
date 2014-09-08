
package tv.turbodrive.events
{
	import flash.events.Event;
	

	public class BasicEvent extends Event
	{
		
		protected var _oTarget : Object;
		/**
		 * The type of the event, redefined to provide write access
		 */
		protected var _sType : String;
		
		/**
		 * Creates a new <code>BasicEvent</code> event for the
		 * passed-in event type. The <code>target</code> is optional, 
		 * if the target is omitted and the event used in combination
		 * with the <code>EventBroadcaster</code> class, the event
		 * target will be set on the event broadcaster source.
		 * 
		 * @param	type	<code>String</code> name of the event
		 * @param	target	an object considered as source for this event
		 * @see		EventBroadcaster#broadcastEvent() The EventBroadcaster.broadcastEvent() method
		 */
		public function BasicEvent( type : String, target : Object = null, bubbles : Boolean = false )
		{
			super ( type, bubbles );
			_sType = type;
			_oTarget = target;
		}
		
		/**
		 * The type of this event
		 */
		public override function get type() : String
		{
			return _sType;
		}
		/**
		 * @private
		 */
		public function set type( en : String ) : void
		{
			_sType = en;
		}
		
		/**
		 * Defines the new event type for this event object.
		 * 
		 * @param	en	the new event name, or event type, as string
		 */
		public function setType( en : String ) : void
		{
			_sType = en;
		}
		/**
		 * Returns the type of this event, which generally correspond
		 * to the name of the called function on the listener.
		 * 
		 * @return	the type of this event
		 */
		public function getType():String
		{
			return _sType;
		}
		
		/**
		 * The source object of this event
		 */
		public override function get target() : Object
		{ 
			return _oTarget; 
		}
		/**
		 * @private
		 */
		public function set target( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		
		/**
		 * Defines the new source object of this event.
		 *  
		 * @param	oTarget	the new source object of this event
		 */
		public function setTarget( oTarget : Object ) : void 
		{ 
			_oTarget = oTarget; 
		}
		/**
		 * Returns the current source of this event object.
		 * 
		 * @return	object source of this event
		 */
		public function getTarget() : Object
		{ 
			return _oTarget; 
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new BasicEvent(type, target);
		}

		
	}
}