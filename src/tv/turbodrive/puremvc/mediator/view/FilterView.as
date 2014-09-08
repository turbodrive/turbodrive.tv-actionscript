package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FilterView extends Sprite
	{
		public function FilterView()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			mouseEnabled = true
			buttonMode = true
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null)
			alpha = 0
			TweenMax.to(this, 0.5, {alpha :1})
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeStageHandler)
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			graphics.clear();
			graphics.beginFill(0x150C19, 0.6);
			graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			graphics.endFill()
		}
				
		public function hideAndRemove():void
		{
			if(!parent) return
			TweenMax.to(this, 0.5, {alpha:0, onComplete:parent.removeChild, onCompleteParams:[this]} )
		}
	}
}