package tv.turbodrive.puremvc.mediator.view.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import tv.turbodrive.utils.ButtonBackRollOver;
	
	public class BackButtonsView extends Sprite
	{
		public static const EXTRA_PROJECT:String = "backBttn_ExtraProject"
		public static const SKILLS_ABOUT:String = "backBttn_SkillsAbout"
		public static const TIMELINE_ABOUT:String = "backBttn_TimelineAbout"
		
		private var btn1:backBttn_ExtraProject
		private var btn2:backBttn_SkillsAbout
		private var btn3:backBttn_TimelineAbout
			
		public static const RIGHT:String = "rightSide"
		public static const LEFT:String = "leftSide"
		
		private var currentButtonBack:MovieClip;
		private var _side:String;
		public static const CLICK:String = "clickBackButton";
		
		public function BackButtonsView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeStageHandler)
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			if(!currentButtonBack) return
			currentButtonBack.y = MenuHeader.HEIGHT_OUT
			if(_side == RIGHT){
				currentButtonBack.x = stage.stageWidth - 120
			}else{
				currentButtonBack.x = 60
			}
				
		}
		
		public function showButtonBack(typeButton:String, side:String = "rightSide"):void
		{
			if(currentButtonBack) removeButtonBack()
			_side = side
			var classButton:Class = getDefinitionByName(typeButton) as Class
			currentButtonBack = new classButton();
			currentButtonBack.addEventListener(MouseEvent.CLICK, clickHandler)
			ButtonBackRollOver.addMotion(currentButtonBack)
			addChild(currentButtonBack);
			resizeStageHandler(null)
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(BackButtonsView.CLICK));
		}
		
		public function removeButtonBack():void
		{
			if(currentButtonBack){
				currentButtonBack.removeEventListener(MouseEvent.CLICK, clickHandler)
				if(contains(currentButtonBack)) removeChild(currentButtonBack)
				currentButtonBack = null
			}
		}
	}
}