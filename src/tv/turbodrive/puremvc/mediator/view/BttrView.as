package tv.turbodrive.puremvc.mediator.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BttrView extends Bttr
	{
		public function BttrView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			buttonMode = true
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null)
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeStageHandler)
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			x = 0
			y = stage.stageHeight - 80
		}
	}
}