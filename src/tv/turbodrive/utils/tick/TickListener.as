
package  tv.turbodrive.utils.tick 
{
	import flash.events.Event;		

	/**
	 * ...
	 * @author Viseth Chum d'après Bourre (Framework Lowra)
	 */
	public interface TickListener 
	{

		function onTick( event : Event = null ) : void;
	}
}