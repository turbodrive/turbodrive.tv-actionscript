package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class GmdView extends AnimatedGMD
	{
		private var _timeline:TimelineMax
		private var _timelineIntro:TimelineMax
		
		public function GmdView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			buttonMode = true
			rotation = -3
			this.stop();
			this.filters = [new DropShadowFilter(0,0,0x2E222E,1,25,25,1.3,2)]
			
			//visible = false
			_timeline = new TimelineMax()
			_timeline.append(TweenMax.to(this,1,{startAt:{alpha:1, visible:true}, paused:true, delay:5.1, frame:this.totalFrames, ease:Linear.easeNone, onStart:startTweenHandler}));
			_timeline.append(TweenMax.to(this,0.3,{autoAlpha:0, delay:6.8}));
			
			_timelineIntro = new TimelineMax()
			_timelineIntro.append(TweenMax.to(this,1,{startAt:{alpha:1, visible:true}, paused:true, frame:this.totalFrames, ease:Linear.easeNone}));
			_timelineIntro.append(TweenMax.to(this,0.3,{autoAlpha:0, delay:1.5}));
			
			scaleX = scaleY = 1.2
		}		
		
		protected function startTweenHandler(event:Event = null):void
		{
		 visible = true;
		 alpha = 1;
		}
		
		public function show(delay:Number):void
		{	
			this.gotoAndStop(1);
			if(delay == 0){
				_timelineIntro._first.paused(false);	
				_timelineIntro.play(0)
			} else {
				_timeline._first.paused(false);	
				_timeline.play(0)
			}
		}
			
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null)
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
		}		
				
		protected function rollOutHandler(event:MouseEvent):void{

		}
		
		protected function rollOverHandler(event:MouseEvent):void{
			
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			stage.removeEventListener(Event.RESIZE, resizeStageHandler)
		}
		
		protected function resizeStageHandler(event:Event):void
		{			
			x =  stage.stageWidth * .75
			y = stage.stageHeight *.75
		}
		
		public function hide():void
		{
			pause();
			TweenMax.to(this, 0.5, {autoAlpha:0})
		}
		
		public function pause():void
		{
			if(_timeline) _timeline.pause();
			if(_timelineIntro) _timelineIntro.pause();
		}
		
		public function resume():void
		{
			if(_timeline.paused()) _timeline.play()
		}
	}
}