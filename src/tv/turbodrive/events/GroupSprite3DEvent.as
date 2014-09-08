package tv.turbodrive.events
{
	import flash.events.Event;
	
	import tv.turbodrive.away3d.elements.entities.GroupTps3D;

	public class GroupSprite3DEvent extends Event
	{
		private var _g:GroupTps3D
		
		public function GroupSprite3DEvent(type:String, groupTps3d:GroupTps3D, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_g = groupTps3d
		}
		
		
		public function get groupTps3d():GroupTps3D
		{
			return _g
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new GroupSprite3DEvent(type, groupTps3d, bubbles, cancelable);
		}
	}
}