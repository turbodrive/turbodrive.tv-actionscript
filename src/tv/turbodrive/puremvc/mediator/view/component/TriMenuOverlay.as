package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Styles;
	
	public class TriMenuOverlay extends Sprite
	{
		private var _titleSc:TextField
		private var _titleMp:TextField
		private var _title:Sprite = new Sprite();
		
		private var _infoSc:TextField;
		private var _infoMp:TextField;
		private var _redline:Shape = new Shape();

		private var _openedCredits:Boolean = false;
		private var _openedContact:Boolean = false;
		
		private var _initY:Number
		
		public function TriMenuOverlay()
		{			
			x = 63
			this.mouseEnabled = this.mouseChildren = false
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			_titleSc = Styles.createTextField("gui", "triangleMenu/selectedCases", {upperCase:true})
			_titleMp = Styles.createTextField("gui", "triangleMenu/moreProjects", {upperCase:true})				
			_titleSc.y = _titleMp.y = 0
			_titleMp.x = _titleSc.width + 25
			//_titleSc.alpha = _titleMp.alpha = 0
			
			_title.addChild(_titleMp)
			_title.addChild(_titleSc)
			addChild(_title)
			
			_infoSc = Styles.createTextField("gui", "triangleMenu/selectedCasesInfo", {upperCase:false})
			_infoMp = Styles.createTextField("gui", "triangleMenu/moreProjectsInfo", {upperCase:false})
			_infoSc.x = _infoMp.x = 5
			_infoSc.y = _infoMp.y = 142
			_infoSc.alpha = _infoMp.alpha
				
			addChild(_redline)
			addChild(_infoSc)
			addChild(_infoMp)
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null)
		}		
		
		protected function resizeStageHandler(event:Event):void
		{
			_initY = stage.stageHeight-230
			
			if(_openedCredits){
				y = _initY-CreditsView.HEIGHT_OPEN
			}else{
				y = _initY
			}
			_redline.graphics.clear();
			_redline.graphics.beginFill(Colors.VINTAGE_RED)
			_redline.graphics.drawRect(7,120, stage.stageWidth-140,3);
			_redline.graphics.endFill();
		}
		
		public function show(category:String):void
		{	
			var durationTranslation:Number = 0.5
			if(_titleSc.alpha == 0 && _titleMp.alpha == 0) durationTranslation = 0
			
			if(category == PagesName.SELECTED_CASES){
				TweenMax.to(_titleSc, 0.5, {alpha:1})
				TweenMax.to(_titleMp, 0.5, {alpha:0})
				TweenMax.to(_infoMp, 0.5, {alpha:0})
				TweenMax.to(_infoSc, 0.5, {alpha:1})
				TweenMax.to(_title, durationTranslation, {x : 0, ease:Quart.easeOut})
			}else{
				TweenMax.to(_titleSc, 0.5, {alpha:0})
				TweenMax.to(_titleMp, 0.5, {alpha:1})
				TweenMax.to(_infoMp, 0.5, {alpha:1})
				TweenMax.to(_infoSc, 0.5, {alpha:0})
				TweenMax.to(_title, durationTranslation, {x : -_titleMp.x, ease:Quart.easeOut})
			}
			//TweenMax.to(_redline, 0.5, {alpha:1})
		}
		
		public function openCredits():void
		{
			_openedCredits = true
			if(stage) TweenMax.to(this, 0.5, {y :_initY-CreditsView.HEIGHT_OPEN,  ease:Quart.easeOut})
			checkAppearance()
		}
		
		public function openContact():void
		{
			_openedContact = true
			checkAppearance()
		}
		
		public function closeCredits():void
		{
			_openedCredits = false
			if(stage) TweenMax.to(this, 0.5, {y :_initY,  ease:Quart.easeOut})
			checkAppearance()
		}
		
		public function closeContact():void
		{
			_openedContact = false
			checkAppearance()
		}
		
		private function checkAppearance():void
		{
			if(_openedContact || _openedCredits){
				TweenMax.to(this, 0.5, {colorTransform:{brightness:0.5}})
			}
			if(!_openedContact && !_openedCredits){
				TweenMax.to(this, 0.5, {colorTransform:{brightness:1}})
			}			
		}
		
		public function hide():void
		{
			TweenMax.to(_titleSc, 0.5, {alpha:0})
			TweenMax.to(_titleMp, 0.5, {alpha:0})
			TweenMax.to(_infoMp, 0.5, {alpha:0})
			TweenMax.to(_infoSc, 0.5, {alpha:0})
			//TweenMax.to(_redline, 0.5, {alpha:0})
		}
	}
}