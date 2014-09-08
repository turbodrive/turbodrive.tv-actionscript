package tv.turbodrive.away3d.elements
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.transitions.HyperDrive;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class HyperDriveGp3D extends GroupPlane3D
	{
		private var _hyperDrive:HyperDrive;
		private var _delayTimer:Number
		private var _initialized:Boolean = false
		
		public function HyperDriveGp3D()
		{
			super(MaterialName.SPECIAL_HYPERDRIVE);
			
			_hyperDrive = new HyperDrive();
			visible = false
			_globalContainer.addChild(_hyperDrive)
		}
		
		public function init():void
		{
			if(_initialized) return		
			_initialized = true
			visible = true
			_hyperDrive.x = 50000
			_hyperDrive.start();
			setTimeout(endInit,2500)
			
		}
		
		private function endInit():void
		{
			_hyperDrive.x = 0
			_hyperDrive.stop()
			_hyperDrive.reset()
			visible = false
		}
		
		public function preStart():void
		{
			_hyperDrive.reset()
			_hyperDrive.start()
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{	
			var d:Number = timelineDuration-0.8				
			if(d < 0) return

			visible = true
			
			//_delayTimer = setTimeout(_hyperDrive.start, d*1000);
			
			_hyperDrive.show();
			_hyperDrive.increaseSpeed(timelineDuration/2, timelineDuration/2);
		}
		
		public function stop():void
		{
			clearTimeout(_delayTimer)
			_hyperDrive.addEventListener(Event.COMPLETE, completeStopHD)
			_hyperDrive.stop()
		}
		
		protected function completeStopHD(event:Event):void
		{
			_hyperDrive.removeEventListener(Event.COMPLETE, completeStopHD);
			visible = false
		}	
		
		
		public function hide():void
		{
			clearTimeout(_delayTimer)
			_hyperDrive.addEventListener(Event.COMPLETE, completeStopHD)
			_hyperDrive.hideAndStop()
		}
	}
}