package tv.turbodrive.events
{
	import flash.events.Event;
	
	import tv.turbodrive.puremvc.proxy.data.Page;

	public class PageEvent extends Event
	{	
		static public const CHANGE_PAGE:String  = "ChangePage";
		static public const OVER_NAV:String = "overNav"
		
		private var _p:Page;
		
		public function PageEvent(type:String, page:Page, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			_p = page
		}
		
		
		public function get page():Page
		{
			return _p
		}
		
		/**
		 * Clone the event
		 * 
		 * @return	a clone of the event
		 */
		override public function clone() : Event
		{
			return new PageEvent(type, _p, bubbles, cancelable);
		}
	}
}