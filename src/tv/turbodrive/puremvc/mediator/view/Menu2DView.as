package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.mediator.view.component.ContactShareView;
	import tv.turbodrive.puremvc.mediator.view.component.CreditsView;
	import tv.turbodrive.puremvc.mediator.view.component.MenuHeader;
	import tv.turbodrive.puremvc.mediator.view.component.TriMenuOverlay;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	
	public class Menu2DView extends Sprite
	{
		public static const ANGLE_MENU:Number = -3
		public static const REEL_MODE:String = "reelMode"
		public static const REEL_NOMOVE_MODE:String = "reelNoMovMode";
		public static const FOLIO_MODE:String = "folioMode"
		public static const HIDDEN_MODE:String = "hiddenMode";
			
		public static const CLICK_MENU_BUTTON:String = "clickMenuButton"
		public static const CLICK_MENU_CLOSEBUTTON:String = "clickMenuCloseButton";
		
		public static const ROLLOVER_TRI_BUTTON:String = "rollOverTriButton"
		public static const ROLLOUT_TRI_BUTTON:String = "rollOutTriButton"
		public static const CLICK_TRI_BUTTON:String = "clickTriButton"
			
		private var _sW:int;
		private var _sH:int;
		
		private var _delay:Boolean;
		private var hit:Sprite;
		private var _mainTw:TweenMax;
		private var _lightTw:TweenMax;
		private var _mode:String = "";
		private var _outAlpha:Number = 1
		
		private var _aboutTw:TweenMax;
		private var _mpTw:TweenMax;
		private var _selTw:TweenMax;
		private var _buttonsTarget:Dictionary = new Dictionary();
		
		private var _buttons2D:ButtonMenu2D;
		private var _menuHeader:MenuHeader;
		private var _contactPanel:ContactShareView
		private var _creditsPanel:CreditsView
		
		private var _overlayMenu:MovieClip
		private var _overlayBg:Bitmap
		private var _triMenuOverlay:TriMenuOverlay
		private var _maskTriMenu:Shape = new Shape();
		
		private var _isOpen:Boolean = false
		private var _targetHMask:int = 0
		private var _decomposeDelay:Number = 0.2
		
		private var _openedCredits:Boolean;
		private var _openedContact:Boolean;
		
		public function Menu2DView(pagesFolio:Vector.<Page>)
		{
			super();							
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
				
			_buttons2D = new ButtonMenu2D();
			var i:uint
			for(i = 0; i< _buttons2D.moreProjects.numChildren; i++){
				enableListeners(_buttons2D.moreProjects.getChildAt(i) as SimpleButton)
			}
			for(i = 0; i< _buttons2D.selectedCases.numChildren; i++){
				enableListeners(_buttons2D.selectedCases.getChildAt(i) as SimpleButton)
			}
			
			alpha = 0
			mode = Menu2DView.HIDDEN_MODE
			//mouseEnabled = mouseChildren = false
		}
		
		public function init():void
		{
			if(_overlayMenu) return
			addConstantsButtons();		
			_overlayMenu = new MovieClip();			
			_overlayBg = new Bitmap(new OverlayMenu(), "auto", true);
			_triMenuOverlay = new TriMenuOverlay();
			_triMenuOverlay.visible = false
			_overlayMenu.addChildAt(_overlayBg,0);
			_overlayMenu.addChild(_triMenuOverlay);
			_overlayMenu.mask = _maskTriMenu
			addChildAt(_overlayMenu,0);
			_overlayMenu.addChild(_maskTriMenu)
			_overlayMenu.visible = false
			_overlayMenu.alpha = 0
			
			mouseEnabled = false
			mouseChildren = false
			_overlayMenu.mouseEnabled = false
			_overlayMenu.mouseChildren = false
			parent.mouseEnabled = false
		}
		
		private function enableListeners(btn:SimpleButton):void
		{
			btn.addEventListener(MouseEvent.ROLL_OUT, rollOutTriHandler)
			btn.addEventListener(MouseEvent.ROLL_OVER, rollOverTriHandler)
			btn.addEventListener(MouseEvent.CLICK, clickTriHandler)
		}
		
		protected function rollOutTriHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Menu2DView.ROLLOUT_TRI_BUTTON,this,SimpleButton(event.currentTarget).name.split("Button")[0]));
		}
		
		protected function rollOverTriHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Menu2DView.ROLLOVER_TRI_BUTTON,this,SimpleButton(event.currentTarget).name.split("Button")[0]));
		}
		
		protected function clickTriHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Menu2DView.CLICK_TRI_BUTTON,this,SimpleButton(event.currentTarget).name.split("Button")[0]));
		}
		
		public function set mode(value:String):void
		{
			if(_mode == value) return
			_mode = value
			if(_mode == HIDDEN_MODE){
				TweenMax.to(this, 0.5, {alpha:0})
				mouseChildren = false
			}else{
				TweenMax.to(this, _decomposeDelay, {alpha:1})
				TweenMax.to(_menuHeader, _decomposeDelay, {delay:_decomposeDelay, autoAlpha:1})
				TweenMax.to(_overlayMenu, _decomposeDelay, {delay:_decomposeDelay*2, autoAlpha:1})
				mouseChildren = true
			}
			
			if(_menuHeader) _menuHeader.setMode(_mode)
		}
		
		private function addConstantsButtons():void
		{			
			_menuHeader = new MenuHeader()
			_menuHeader.addEventListener(MenuHeader.OUT_HEADER, rollOutHeaderHandler)
			_menuHeader.addEventListener(MenuHeader.OVER_HEADER, rollOverHeaderHandler)
			_menuHeader.addEventListener(Menu2DView.CLICK_MENU_BUTTON, categoryClickHandler)
			_menuHeader.addEventListener(MenuHeader.CHANGE_ALPHA_BG, changeAlphaBgHandler)
			_menuHeader.addEventListener(ContactShareEvent.OPEN_CONTACT_PANEL, openContactPanelHandler)
			_menuHeader.visible = false
			_menuHeader.alpha = 0;
			addChild(_menuHeader)
			
			_contactPanel = new ContactShareView();
			_contactPanel.addEventListener(ContactShareEvent.CLOSE_CONTACT_PANEL, closeContactPanelHandler);
			_contactPanel.addEventListener(ContactShareEvent.OPEN_CREDITS_PANEL, openCreditsPanelHandler);
			_contactPanel.addEventListener(ContactShareView.CLICK_SHARE_BUTTON, clickShareButton)
			_contactPanel.visible = false
			addChildAt(_contactPanel,0);
			
			_creditsPanel = new CreditsView();
			_creditsPanel.addEventListener(ContactShareEvent.CLOSE_CREDITS_PANEL, closeCreditsPanelHandler);
			_creditsPanel.visible = false
			addChildAt(_creditsPanel,0);
			
			//_categoryMenu.addEventListener(Menu2DView.CLICK_MENU_BUTTON, categoryClickHandler)	
			
			// close button
			/*_closeButton = new closeMenuBtn();
			_closeButton.alpha = 0
			_closeButton.buttonMode = _closeButton.mouseEnabled = true*/
				
			mode = Menu2DView.HIDDEN_MODE
			if(_sW > 0) _menuHeader.updateWidth(_sW, _sH)
				
			//replaceCloseButton()
		}	
		
		protected function clickShareButton(event:StringEvent):void
		{
			Preloader.track("_contact/share/"+event.getString());
			navigateToURL(new URLRequest(event.getString()), "_blank")
		}
		
		protected function changeAlphaBgHandler(event:NumberEvent):void
		{
			TweenMax.to(_overlayMenu, 0.3, {autoAlpha:event.getNumber()})
		}
		
		protected function openCreditsPanelHandler(event:Event):void
		{
			dispatchEvent(event.clone())
		}
		
		protected function rollOverHeaderHandler(event:Event):void
		{
			dispatchEvent(event.clone())
			_contactPanel.rollOverHeader();
			if(!_isOpen) TweenMax.to(_maskTriMenu, 0.3, {height:MenuHeader.HEIGHT_OVER, ease:Quart.easeOut})
		}
		
		protected function rollOutHeaderHandler(event:Event):void
		{
			dispatchEvent(event.clone())
			_contactPanel.rollOutHeader();
			if(!_isOpen) TweenMax.to(_maskTriMenu, 0.3, {height:MenuHeader.HEIGHT_OUT, ease:Quart.easeOut})
		}
		
		protected function closeContactPanelHandler(event:Event):void
		{
			dispatchEvent(event)
		}
		
		protected function closeCreditsPanelHandler(event:Event):void
		{
			dispatchEvent(new Event(ContactShareEvent.CLOSE_CREDITS_PANEL))
		}
		
		protected function clickCloseContactPanel(event:MouseEvent):void
		{
			dispatchEvent(new Event(ContactShareEvent.CLOSE_CONTACT_PANEL))
		}
		
		protected function openContactPanelHandler(event:StringEvent):void
		{
			_menuHeader.forceRollOut();
			dispatchEvent(event.clone());
		}
		
		protected function categoryClickHandler(event:StringEvent):void
		{
			dispatchEvent(event);
		}
		
		public function mouseClickCloseHandler(event:MouseEvent):void
		{
			closeContactPanel();
			closeCredits();
			dispatchEvent(new Event(CLICK_MENU_CLOSEBUTTON));
			_menuHeader.forceRollOut();
		}
		
		protected function mouseClickHandler(event:MouseEvent):void
		{
			_menuHeader.forceRollOut();			
			dispatchEvent(new StringEvent(CLICK_MENU_BUTTON,event.target, String(_buttonsTarget[event.currentTarget])));
			
		}
		
		private function resetTweens():void
		{
			if(_mainTw) _mainTw.pause()
			if(_aboutTw) _aboutTw.pause()
			if(_mpTw) _mpTw.pause()
			if(_selTw) _selTw.pause()
		}
		
		public function highLightMoreProjects():void
		{
			_menuHeader.highLightMoreProjects()
		}		
	
		public function hide():void
		{
			/*if(_lightTw)_lightTw.pause()			
			_lightTw = TweenMax.to(this,0.8,{alpha:_outAlpha, ease:Quart.easeOut})*/
		}
		
		public function show():void
		{
			
			/*if(_lightTw)_lightTw.pause()		
			_lightTw = TweenMax.to(this,0.3,{alpha:1, ease:Quart.easeOut})*/
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			/*alpha = 0
			if(_delay){
				TweenMax.to(this,1,{delay:3,alpha:1});
			}else{
				TweenMax.to(this,1,{delay:.3,alpha:1});
			}*/
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null)
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.removeEventListener(Event.RESIZE, resizeStageHandler)
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			_sW = stage.stageWidth;		
			_sH = stage.stageHeight;			

			var rX:Number = _sW/1280
			var rY:Number = _sH/720
			var scaleVisuel:Number = rY
			if(rX > rY) scaleVisuel = rX
			if(_overlayBg){
				_overlayBg.scaleX = _overlayBg.scaleY = scaleVisuel			
				_overlayBg.x = (_sW-_overlayBg.width)*0.5
				_overlayBg.y = (_sH-_overlayBg.height)*0.5			
			}
			////
			_maskTriMenu.graphics.clear()
			_maskTriMenu.graphics.beginFill(0xFF0000,1);
			_maskTriMenu.graphics.drawRect(0,0,_sW,_sH);
			_maskTriMenu.graphics.endFill();
			if(_isOpen){
				_maskTriMenu.height = _sH
			}else{
				_maskTriMenu.height = MenuHeader.HEIGHT_OUT
			}
		
			if(_menuHeader) _menuHeader.updateWidth(_sW, _sH)		
		}		
		
		public function activeDelayShow(delay:Boolean):void
		{
			_delay = delay
		}	
		
		public function open(category:String):void
		{
			if(category == PagesName.SELECTED_CASES){
				_buttons2D.selectedCases.mouseChildren = true
				_buttons2D.moreProjects.mouseChildren = false
			}else{
				_buttons2D.selectedCases.mouseChildren = false
				_buttons2D.moreProjects.mouseChildren = true
			}
			
			_triMenuOverlay.show(category)
			if(_isOpen) return
			_menuHeader.showCloseButton()
			_menuHeader.close_mc.addEventListener(MouseEvent.CLICK, mouseClickCloseHandler)			
			_triMenuOverlay.visible = true			
			if(!contains(_buttons2D)) addChildAt(_buttons2D, 1)
			
			TweenMax.to(_maskTriMenu, .5, {height:_sH, ease:Quart.easeOut})
			_isOpen = true
		}
		
		public function close():void
		{
			if(!_isOpen) return
			
			_menuHeader.hideCloseButton()
			_menuHeader.close_mc.removeEventListener(MouseEvent.CLICK, mouseClickCloseHandler)
			TweenMax.to(_maskTriMenu, .5, {height:MenuHeader.HEIGHT_OUT, ease:Quart.easeOut, onComplete:hideTriMenuOverlay})		
			
			if(contains(_buttons2D)) removeChild(_buttons2D)
			_isOpen = false
		}
		
		public function hideTriMenuOverlay():void
		{
			_triMenuOverlay.visible = false
		}
		
		public function update2DMenu(rect:Rectangle):void
		{
			_buttons2D.x = rect.x - 10
			_buttons2D.y = rect.y - 10
			_buttons2D.scaleX = rect.width / 232
			_buttons2D.scaleY = _buttons2D.scaleX
		}
		
		public function hideAndClose():void
		{
			// during switch env
		}
		
		public function updateState(nextPage:Page):void
		{
			if(_menuHeader){
				_menuHeader.updateState(nextPage)
				resizeStageHandler(null)
			}
		}
		
		public function startTransition(nextPage:Page):void
		{
			if(_menuHeader) _menuHeader.startTransition(nextPage)	
		}
		
		public function openContacPanel(area:String):void
		{
			
			if(_openedContact) return
			if(_menuHeader){
				_menuHeader.openContact = true
				if(_isOpen) _menuHeader.hideCloseButton()
			}
			Preloader.track("_contactPanel");
			_openedContact = true
			_triMenuOverlay.openContact()
			_contactPanel.open(area)
			checkButtons2DActivation()
		}
		
		public function closeContactPanel():void
		{			
			if(!_openedContact) return
			if(_menuHeader){
				_menuHeader.openContact = false
				if(_isOpen)	_menuHeader.showCloseButton()
			}
			_openedContact = false
			_triMenuOverlay.closeContact()
			_contactPanel.close()
			checkButtons2DActivation()
		}			
		
		public function openCredits():void
		{
			if(_openedCredits) return
			if(_menuHeader){
				_menuHeader.openedCredits = true
				if(_isOpen) _menuHeader.hideCloseButton()
			}
			Preloader.track("_creditsPanel");
			_openedCredits = true
			_triMenuOverlay.openCredits()
			_creditsPanel.open()
			checkButtons2DActivation()
		}
		
		public function closeCredits():void
		{
			if(!_openedCredits) return
			if(_menuHeader){
				_menuHeader.openedCredits = false
				if(_isOpen) _menuHeader.showCloseButton()
			}
			
			_openedCredits = false
			_triMenuOverlay.closeCredits()
			_creditsPanel.close();
			checkButtons2DActivation()
		}
		
		public function checkButtons2DActivation():void
		{
			if(_openedCredits || _openedContact){
				//_buttons2D.mouseEnabled = _buttons2D.mouseChildren = false
				if(contains(_buttons2D)) removeChild(_buttons2D)
			}
			
			if(!_openedContact && !_openedCredits){
				//_buttons2D.mouseEnabled = _buttons2D.mouseChildren = true
				if(_isOpen) addChildAt(_buttons2D,1)
			}			
		}		
	}
}