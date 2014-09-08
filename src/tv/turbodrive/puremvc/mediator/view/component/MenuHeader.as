package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.mediator.view.Menu2DView;
	import tv.turbodrive.puremvc.proxy.data.ContactShareVO;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.ButtonBackRollOver;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Styles;

	public class MenuHeader extends Header
	{
		private var _buttonsTarget:Dictionary = new Dictionary();
		private var buttonMenuList:Array = []
		
		private var _scButton:Sprite
		private var _mpButton:Sprite
		private var _aboutButton:Sprite
		private var _contactButton:Sprite
		private var _shareButton:Sprite	

		private var _highlightButton:Sprite;

		private var _xPositionMenu:int;
		private var sW:int;

		private var _closeBtnVisible:Boolean;
		public static const OVER_HEADER:String = "rollOverHeader";
		public static const OUT_HEADER:String = "rollOutHeader";
		public static const CHANGE_ALPHA_BG:String = "changeAlphaBg";
		
		public static const HEIGHT_OVER:int = 140
		public static const HEIGHT_OUT:int = 50
			
		private var _hit:Sprite = new Sprite();

		private var _openMenu3D:Boolean = false;
		private var _openHeader2D:Boolean = false;
		private var _openContact:Boolean = false;
		private var _openedCredits:Boolean = false;

		private var _timeOutOver:Number;
		private var _timeOutOut:Number;
		private var _contactClicked:Boolean = false;
		private var _mode:String;
		private var paddingReelMode:int = -5
		private var posDbleLineTextY:Number = 11.25
		private var posSimpleLineTextY:Number = 18
		//private var targetYopen:int = 0
		
		private var timeoutMouse:Number
		private var _mousePos:Point
		private var _mouseIsMoving:Boolean = false
		
		private var _alphaMenuMseMove:Number = 0.9
		private var _alphaMenuMseNoMov:Number = 0.15
			
		private var _cat:String;
		private var _textOutSc:TextField;
		private var _textOutMp:TextField;
		private var _textOutAbout:TextField;		

		private var _highLightTimeout:Number;

		private var twHighLight:TweenMax;
		
		public function MenuHeader()
		{
			mouseEnabled = true
			buttonMode = true
			
			menu_mc.y = logo_mc.y = HEIGHT_OUT
			this.mask = this.maskMenu_mc
			maskMenu_mc.y = 0
			maskMenu_mc.x = 0
				
			lineOpenHeader_mc.height = 1
			lineOpenHeader_mc.alpha = 0
			lineOpenHeader_mc.mouseChildren = lineOpenHeader_mc.mouseEnabled = false
				
			_hit.graphics.beginFill(0xFF0000,0)
			_hit.graphics.drawRect(0,0,1280,HEIGHT_OVER);
			_hit.graphics.endFill();
			addChildAt(_hit, 0)			
				
			_contactButton = menu_mc.contact_mc
			_shareButton = menu_mc.share_mc
			menu_mc.contact_mc.bg_mc.alpha = menu_mc.share_mc.bg_mc.alpha = 0
			_shareButton.buttonMode = _contactButton.buttonMode = true
			_shareButton.mouseChildren = _contactButton.mouseChildren = false
			_contactButton.addEventListener(MouseEvent.ROLL_OVER, rollOverContactShareHandler)
			_shareButton.addEventListener(MouseEvent.ROLL_OVER, rollOverContactShareHandler)
			_contactButton.addEventListener(MouseEvent.ROLL_OUT, rollOutContactShareHandler)
			_contactButton.addEventListener(MouseEvent.CLICK, clickContactShareHandler)
			_shareButton.addEventListener(MouseEvent.ROLL_OUT, rollOutContactShareHandler)
			_shareButton.addEventListener(MouseEvent.CLICK, clickContactShareHandler)
			menu_mc.menuRollOut_mc.contact_mc.alpha = menu_mc.menuRollOut_mc.share_mc.alpha = 0
			MovieClip(menu_mc.menuRollOut_mc.contact_mc).mouseEnabled = false;
			MovieClip(menu_mc.menuRollOut_mc.share_mc).mouseEnabled = false;
			
			_scButton = menu_mc.menuRollOut_mc.selectedCasesButton
			_textOutSc = Styles.createTextField("gui","header/selectedCases", {upperCase:true, x:7,y:posDbleLineTextY, parent:_scButton})
			
			_buttonsTarget[_scButton] = PagesName.SELECTED_CASES
			
			_mpButton = menu_mc.menuRollOut_mc.moreProjectsButton
			_textOutMp = Styles.createTextField("gui","header/moreProjects", {upperCase:true, x:7,y:posDbleLineTextY, parent:_mpButton})

			_aboutButton = menu_mc.menuRollOut_mc.aboutButton
			_textOutAbout = Styles.createTextField("gui","header/about", {upperCase:true, x:7,y:posSimpleLineTextY, parent:_aboutButton})
			_buttonsTarget[_aboutButton] = PagesName.ABOUT
			MovieClip(menu_mc.menuRollOut_mc).buttonMode = true;
			buttonMenuList.push(_scButton, _mpButton, _aboutButton)
			
			var menuSelectedCases:MenuHeaderSection = new MenuHeaderSection(menu_mc.selectedCases_mc, PagesName.SELECTED_CASES);
			var menuMoreProjects:MenuHeaderSection = new MenuHeaderSection(menu_mc.moreProjects_mc, PagesName.MORE_PROJECTS);
			var menuAbout:MenuHeaderSection = new MenuHeaderSection(menu_mc.about_mc, PagesName.ABOUT);
			menu_mc.selectedCases_mc.addEventListener(MouseEvent.CLICK, clickMenuHeaderSectionHandler, true);
			menu_mc.moreProjects_mc.addEventListener(MouseEvent.CLICK, clickMenuHeaderSectionHandler, true);
			menu_mc.about_mc.addEventListener(MouseEvent.CLICK, clickMenuHeaderSectionHandler, true);
			
			menu_mc.menuRollOut_mc.selectedCasesButton.lineReel_mc.alpha = 0
			menu_mc.menuRollOut_mc.moreProjectsButton.lineReel_mc.alpha = 0
			menu_mc.menuRollOut_mc.aboutButton.lineReel_mc.alpha = 0
			
			this.addEventListener(MouseEvent.ROLL_OVER, globalRollOverHandler, true)
			this.addEventListener(MouseEvent.ROLL_OUT, globalRollOutHandler)
				
			close_mc.visible = false
			ButtonBackRollOver.addMotion(close_mc)
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		public function setMode(mode:String):void
		{
			if(_mode == mode) return
			_mode = mode			
			if(_mode == Menu2DView.REEL_MODE){
				startMouseMovDetection()
			}else{
				stopMouseMovDetection()
			}
			
			applyMode(_mode, 1.5, 1.5, true)
		}
		
		/*** MOUSE MOVEMENT DETECTION - MENU HIGHLIGHTING ***/
		
		private function stopMouseMovDetection():void
		{
			clearTimeout(timeoutMouse)
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveDetectHandler)
		}
		
		protected function mouseMoveDetectHandler(event:MouseEvent):void
		{		
			if(_openHeader2D || _openMenu3D || _openContact || _openedCredits){
				clearTimeout(timeoutMouse)
			}else{
				if(timeoutMouse != 0){
					clearTimeout(timeoutMouse)
					mouseMov()
					timeoutMouse = 0
				}
				timeoutMouse = setTimeout(mouseNoMov,1500)
			}
		}	
		
		private function checkTempMode():void
		{
			if(_openContact || _openedCredits){
				applyMode(Menu2DView.FOLIO_MODE, 0, 0.5, true)
			}
			
			if(!_openContact && !_openedCredits){
				applyMode(_mode, 0, 0.5, true)
			}
		}
		
		public function set openContact(value:Boolean):void
		{
			_openContact = value
			checkTempMode()
		}
		
		public function get openContact():Boolean
		{
			return _openContact
		}
		
		public function set openedCredits(value:Boolean):void
		{
			_openedCredits = value
			checkTempMode()
		}
		
		public function get openedCredits():Boolean
		{
			return _openedCredits
		}
		
		private function mouseMov():void
		{
			_mouseIsMoving = true
			if(alpha < _alphaMenuMseMove){
				if(!_openMenu3D) applyMode(Menu2DView.REEL_MODE,0,0.2,true);
			}
		}
		
		private function mouseNoMov():void
		{
			clearTimeout(timeoutMouse)
			_mouseIsMoving = false
			if(alpha > _alphaMenuMseNoMov){
				if(!_openMenu3D) applyMode(Menu2DView.REEL_MODE,0,1,true);
			}
		}
		
		private function startMouseMovDetection():void
		{
			_mousePos = new Point(stage.mouseX, stage.mouseY)
			//timeoutMouse = setTimeout(mouseNoMov,1500)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveDetectHandler)
		}
		
		/************/
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
				
			parent.addChild(lineOpenHeader_mc)
			parent.addChild(close_mc)
		}	
		
		protected function clickMenuHeaderSectionHandler(event:Event):void
		{
			var target:String = MovieClip(event.target).target		
			if(event.currentTarget == _aboutButton || event.currentTarget == menu_mc.about_mc){
				_contactClicked = true
				forceRollOut()
			}
			dispatchEvent(new StringEvent(Menu2DView.CLICK_MENU_BUTTON,event.target, target));
		}
		
		protected function clickContactShareHandler(event:MouseEvent):void
		{
			_contactClicked = true
			dispatchEvent(new StringEvent(ContactShareEvent.OPEN_CONTACT_PANEL,this, event.currentTarget == _shareButton ? ContactShareVO.SHARE : ContactShareVO.CONTACT))
		}
		
		
		protected function rollOverContactShareHandler(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget)
			TweenMax.to(button.bg_mc, 0.3, {alpha:1, ease:Quart.easeOut})
			TweenMax.to(button.picto_mc, 0.3, {tint:0xEFECE1, ease:Quart.easeOut})
		}
		
		protected function rollOutContactShareHandler(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget)
			TweenMax.to(button.bg_mc, 0.8, {alpha:0, ease:Quart.easeOut})		
			TweenMax.to(button.picto_mc, 0.8, {removeTint:true, ease:Quart.easeOut})
		}
		
		public function updateState(page:Page):void
		{
			if(_cat == page.category) return
			_cat = page.category
			if(page.category == PagesName.ABOUT) _highlightButton = _aboutButton
			if(page.category == PagesName.SELECTED_CASES) _highlightButton = _scButton
			if(page.category == PagesName.MORE_PROJECTS) _highlightButton = _mpButton
			
			if(_highlightButton){
				TweenMax.to(_highlightButton, 0.3, {removeTint:true})
				if(_highlightButton == _aboutButton) _highlightButton.mouseEnabled = _highlightButton.buttonMode = false
			}
				
			for(var i:int = 0; i< buttonMenuList.length; i++){
				var button:Sprite = buttonMenuList[i] as Sprite
				if(button != _highlightButton){
					button.mouseEnabled = button.buttonMode = true
				}
			}			
		}
		
		public function startTransition(page:Page):void
		{
			if(page.category == _cat) return
			_highlightButton = null
				
			for(var i:int = 0; i< buttonMenuList.length; i++){
				var button:Sprite = buttonMenuList[i] as Sprite
				TweenMax.to(button,0.8, {tint:0x53444D})
				button.mouseEnabled = button.buttonMode = false
			}
		}
		
		protected function globalRollOutHandler(event:MouseEvent):void
		{
			if(_contactClicked) _contactClicked = false
			clearTimeout(_timeOutOver)
			clearTimeout(_timeOutOut)
			_timeOutOut = setTimeout(rollOut,300, event)			
		}
		
		public function forceRollOut():void
		{
			rollOut()
			_contactClicked = true
			//globalRollOutHandler(null);
		}
		
		public function applyMode(mode:String, delay:Number = 0, duration:Number = 0.5, moveMenuY:Boolean = false):void
		{			
			if(mode == Menu2DView.FOLIO_MODE){
				if(twHighLight) twHighLight.pause();
				TweenMax.to(this,duration,{delay:delay, alpha:1})
				dispatchEvent(new NumberEvent(CHANGE_ALPHA_BG,this,1))
				TweenMax.to(logo_mc, duration, {delay:delay, alpha:1})
				TweenMax.to(menu_mc.menuRollOut_mc.contact_mc, duration, {delay:delay, alpha:1})
				TweenMax.to(menu_mc.menuRollOut_mc.share_mc, duration, {delay:delay, alpha:1})
				
				//if(moveMenuY){
					TweenMax.to(_textOutSc, duration, {delay:delay, y:posDbleLineTextY})
					TweenMax.to(_textOutMp, duration, {delay:delay, y:posDbleLineTextY})
					TweenMax.to(_textOutAbout, duration, {delay:delay, y:posSimpleLineTextY})
				//}
				
				TweenMax.to(menu_mc.menuRollOut_mc.selectedCasesButton.lineReel_mc, duration, {delay:delay, alpha:0})
				TweenMax.to(menu_mc.menuRollOut_mc.moreProjectsButton.lineReel_mc, duration, {delay:delay, alpha:0})
				TweenMax.to(menu_mc.menuRollOut_mc.aboutButton.lineReel_mc, duration, {delay:delay, alpha:0})
				
			}else if(mode == Menu2DView.REEL_MODE){
				if(twHighLight) twHighLight.pause();
				if(_mouseIsMoving){
					TweenMax.to(this,duration,{delay:delay, alpha:_alphaMenuMseMove})
					dispatchEvent(new NumberEvent(CHANGE_ALPHA_BG,this,1))
				}else{
					TweenMax.to(this,duration,{delay:delay, alpha:_alphaMenuMseNoMov})
					dispatchEvent(new NumberEvent(CHANGE_ALPHA_BG,this,0.2))
				}				
				
				TweenMax.to(logo_mc, duration, {delay:delay, alpha:0})
				TweenMax.to(menu_mc.menuRollOut_mc.contact_mc, duration, {delay:delay, alpha:0})
				TweenMax.to(menu_mc.menuRollOut_mc.share_mc, duration, {delay:delay, alpha:0})
				
				//if(moveMenuY) TweenMax.to(menu_mc, duration, {delay:delay, y:HEIGHT_OUT- paddingReelMode})
					
				TweenMax.to(_textOutSc, duration, {delay:delay, y:posDbleLineTextY+paddingReelMode})
				TweenMax.to(_textOutMp, duration, {delay:delay, y:posDbleLineTextY+paddingReelMode})
				TweenMax.to(_textOutAbout, duration, {delay:delay, y:posSimpleLineTextY+paddingReelMode})
				
				TweenMax.to(menu_mc.menuRollOut_mc.selectedCasesButton.lineReel_mc, duration, {delay:delay, alpha:1})
				TweenMax.to(menu_mc.menuRollOut_mc.moreProjectsButton.lineReel_mc, duration, {delay:delay, alpha:1})
				TweenMax.to(menu_mc.menuRollOut_mc.aboutButton.lineReel_mc, duration, {delay:delay, alpha:1})
			}
		}
		
		private function rollOut(event:Event = null):void
		{
			clearTimeout(_timeOutOver);
			clearTimeout(_timeOutOut);
			_openHeader2D = false;
			var targetY:int = HEIGHT_OUT;
			//if(_mode == Menu2DView.REEL_MODE) targetY -= paddingReelMode;
			TweenMax.to(menu_mc, 0.3, {y:targetY, ease:Quart.easeOut});
			TweenMax.to(logo_mc, 0.3, {y:HEIGHT_OUT, ease:Quart.easeOut});
			TweenMax.to(maskMenu_mc, 0.3, {height:HEIGHT_OUT, ease:Quart.easeOut});
			updateLineStage();
			dispatchEvent(new Event(OUT_HEADER));
			if(!_openMenu3D) applyMode(_mode,0,0.3, false);
			if(_mode == Menu2DView.REEL_MODE){
				mouseMoveDetectHandler(null)
			}
		}
		
		private function rollOver(event:Event):void
		{
			clearTimeout(_highLightTimeout)
			clearTimeout(_timeOutOver);
			clearTimeout(_timeOutOut);
			_openHeader2D = true;
			if(event && (event.target is MovieClip) && MovieClip(event.target).name == "close_mc") return;
			TweenMax.to(menu_mc, 0.3, {y:0, ease:Quart.easeOut});
			TweenMax.to(logo_mc, 0.3, {y:0, ease:Quart.easeOut});
			TweenMax.to(maskMenu_mc, 0.3, {height:HEIGHT_OVER, ease:Quart.easeOut});
			updateLineStage();
			dispatchEvent(new Event(OVER_HEADER));
			applyMode(Menu2DView.FOLIO_MODE,0, 0.3, false);
		}
		
		protected function globalRollOverHandler(event:MouseEvent):void
		{
			if(_contactClicked){
				_contactClicked = false
				return
			}
			clearTimeout(_highLightTimeout)
			clearTimeout(_timeOutOver)
			clearTimeout(_timeOutOut)
			_timeOutOver = setTimeout(rollOver,80, event)
			
			/*logo_mc.alpha = _contactButton.alpha = _shareButton.alpha = 1
			alpha = 1*/
			//menu_mc.y = logo_mc.y = HEIGHT_OUT			
		}
		
		private function updateLineStage():void
		{
			var targetAlpha:Number = 0;
			var targetHeight:int = 1;
			var targetY:int = 55;
			var targetTint:Number = _openHeader2D ? Colors.VINTAGE_RED : 0x594B52;
			
			if(_openHeader2D){
				targetHeight = 3
				targetY = 138
				if(_openMenu3D){
					targetAlpha = 1
				}
			}else {
				if(_openMenu3D){
					targetAlpha = 0.65
				}
			}
			TweenMax.to(lineOpenHeader_mc, 0.3, {height:targetHeight, y:targetY, tint:targetTint, alpha:targetAlpha, ease:Quart.easeOut})
		}
		
		protected function rollOverHandler(event:Event):void
		{
			var button:Sprite = Sprite(event.currentTarget)
			TweenMax.to(button, 0.3, {tint:0xEFECE1, ease:Quart.easeOut})
			if(_highlightButton && _highlightButton != button){
				TweenMax.to(_highlightButton, 0.3, {tint:0x53444D, ease:Quart.easeOut})
			}
		}
		
		protected function rollOutHandler(event:Event):void
		{
			var button:Sprite = Sprite(event.currentTarget)
			TweenMax.to(button, 0.8, {tint:0x53444D, ease:Quart.easeOut})
			if(_highlightButton && _highlightButton != button){
				TweenMax.to(_highlightButton, 0.8, {removeTint:true, ease:Quart.easeOut})
			}
		}
		
		public function updateWidth(_sW:int, _sH:int):void
		{
			sW = _sW
			menu_mc.x = sW - 681
			close_mc.x = sW - close_mc.width - 30
			maskMenu_mc.width = _hit.width = sW
			lineOpenHeader_mc.width = sW-140
			lineOpenHeader_mc.x = 70
				
			_hit.graphics.clear()
			_hit.graphics.beginFill(0xFF0000,0)
			_hit.graphics.drawRect(0,0,sW,HEIGHT_OVER);
			_hit.graphics.endFill();
		}
		
		public function hide():void{
			//if(twHighLight) twHighLight.pause();
			TweenMax.to(this, 0.3, {alpha:0})
		}
		
		public function show():void
		{
			if(twHighLight) twHighLight.pause();
			TweenMax.to(this, 0.3, {delay:0.15, alpha:1})
		}
		
		public function showCloseButton():void
		{
			_openMenu3D = true
			Sprite(close_mc).visible = true
			updateLineStage()
			stopMouseMovDetection()
			applyMode(Menu2DView.FOLIO_MODE, 0, 0.5, true)
		}
		
		public function hideCloseButton():void
		{
			_openMenu3D = false
			Sprite(close_mc).visible = false
			updateLineStage()
			if(_mode == Menu2DView.REEL_MODE){
				startMouseMovDetection()
				applyMode(_mode, 0, 0.5, true)
			}
		}	
		
		public function highLightMoreProjects():void
		{
			twHighLight = TweenMax.to(this,0.3,{alpha:1})			
			TweenMax.to(_scButton,0.3, {alpha:0.3})
			TweenMax.to(_mpButton,0.3, {tint:0xEFECE1, alpha:0.8})
			TweenMax.to(_aboutButton,0.3, {delay:1.5, tint:0xEFECE1, alpha:0.8, onComplete:unLightButtons})
		}
		
		public function unLightButtons():void
		{
			TweenMax.to(_mpButton,1.5, {delay:3,tint:0x53444D, alpha:1})
			TweenMax.to(_aboutButton,1.5, {delay:3, tint:0x53444D,alpha:1})
			TweenMax.to(_scButton,1.5, {delay:3, tint:0x53444D,alpha:1})
			if(twHighLight) twHighLight.pause();
			twHighLight = TweenMax.to(this,1.5, {delay:3,alpha:0.15})
		}
	}
}