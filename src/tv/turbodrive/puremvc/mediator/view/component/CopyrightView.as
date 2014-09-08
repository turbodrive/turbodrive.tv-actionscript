package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.AutoAlphaPlugin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import tv.turbodrive.utils.Styles;

	public class CopyrightView extends Sprite
	{
		private var copyButton:CopyrightAndCredits
		
		private var _timelineOpen:Boolean;
		private var _alphaOut:Number = 0.5
		private var _offsetY:Number = 0;

		private var twTimelineSync:TweenMax;
		public function CopyrightView()
		{
			copyButton = new CopyrightAndCredits()
			
			var textCopyright:TextField = Styles.createTextField("gui", "copyright", {parent:copyButton, x:22,y:6});
			textCopyright.alpha = 0.6
			
			copyButton.buttonMode = true
			copyButton.mouseChildren = false
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			alpha = _alphaOut
			addChild(copyButton)
				
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null);
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			x = stage.stageWidth - copyButton.width
			updateYView()
		}
		
		private function updateYView():void
		{
			y = stage.stageHeight - copyButton.height + _offsetY
		}
		
		public function openTimeline():void
		{
			if(twTimelineSync) twTimelineSync.pause()
			twTimelineSync = TweenMax.to(copyButton, 0.25, { y:-39})
		}
		
		public function closeTimeline():void			
		{
			if(twTimelineSync) twTimelineSync.pause()
			twTimelineSync = TweenMax.to(copyButton, 0.5, {y:0})
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			TweenMax.to(this, 0.5, {alpha:_alphaOut})
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			TweenMax.to(this, 0.3, {alpha:1})
		}
		
		public function updateY(pY:Number):void
		{
			_offsetY = pY
			updateYView()
		}
		
		public function hide():void
		{
			TweenMax.to(copyButton, 0.5, {autoAlpha:0})
		}
		
		public function show():void
		{
			TweenMax.to(copyButton, 0.5, {autoAlpha:1})
		}
	}
}