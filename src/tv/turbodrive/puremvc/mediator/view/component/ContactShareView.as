package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Quart;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.proxy.data.ContactShareVO;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.ButtonBackRollOver;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Path;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.StylesSingleton;

	public class ContactShareView extends ContactSharePanel
	{
		private var _maskContactPanel:Shape;
		
		//private	var posYShadow1:Array = []
		//private	var posYShadow2:Array = []
		//private	var posYMask:Array = [];
		private var commonEase:Ease = Quart.easeOut;
		private var _initX:int = 800
		
		private var buttonForm:GenButton;

		private var _scrollMcTargetPosition:Number = 0
		private var boundScrollbar:Rectangle = new Rectangle(850,5,0,90)
		private var minYContact:int = 5
		private var maxYContact:int = -205
		
		private var mailInput:TextField;
		private var msgInput:TextField;
		private var cfMessage:TextField;
		private var cfEmail:TextField;
		
		private var _focusOnMail:Boolean = false
		private var _focusOnMsg:Boolean = false
		private var _formContainer:MovieClip
		
		private var sendButton:GenButton;

		private var result_mc:Sprite;
		private var _titleResult:TextField;
		private var _contentResult:TextField;
		private var _backButtonResults:GenButton;
		private var _successResult:Boolean;
		private var _isOpen:Boolean = false;

		private var _maskScroll:Shape;
		
		private var _maxHeightMainMask:int = 380
		private var _currentFormat:String
		
		private var creditButton:GenButton;

		private var cfTitle:TextField;
		private var cancelButton:GenButton;
		private var buttonsShare:Dictionary = new Dictionary();
		public static const CLICK_SHARE_BUTTON:String = "clickShareButton";

		private var _gridShade:ShadeButtonSkills;
		
		public function ContactShareView()
		{
			super();
			
			_maskContactPanel = new Shape()
			_maskContactPanel.graphics.beginFill(0x000000);
			_maskContactPanel.graphics.drawRect(0,0,1280,_maxHeightMainMask);
			_maskContactPanel.graphics.endFill();	
			
			mask = _maskContactPanel
			_maskContactPanel.height = 0
			hire_mc.x -= _initX
			bgHireMe_mc.x -= _initX
			y = MenuHeader.HEIGHT_OUT
			
			close_mc.addEventListener(MouseEvent.CLICK, clickClosePanel)			
			ButtonBackRollOver.addMotion(close_mc)
			_gridShade = new ShadeButtonSkills();
			_gridShade.x = 600
			_gridShade.y = 100
			addChildAt(_gridShade,getChildIndex(bg_mc)+1)
			_gridShade.mask = maskGrid_mc
			_gridShade.mouseChildren = _gridShade.mouseEnabled = false
				
				
			_maskScroll = new Shape()
			_maskScroll.graphics.beginFill(0x000000);
			_maskScroll.graphics.drawRect(0,0,1280,280);
			_maskScroll.graphics.endFill();
			addChild(_maskScroll)
				
			contact_mc.addEventListener(MouseEvent.ROLL_OVER, hightlightHandler)
			contact_mc.mask = _maskScroll	
				
			share_mc.addEventListener(MouseEvent.ROLL_OVER, hightlightHandler)
			_formContainer = contact_mc.form_mc
				
			// Hire
			var hTitle:TextField = Styles.createTextField("contact", "hire/title", {parent:hire_mc, upperCase:true, x:0, y:0, width:216, height:50})
			var hContent:TextField = Styles.createTextField("contact", "hire/text", {parent:hire_mc, x:2, y:82, width:286, height:152})
			hContent.wordWrap = true
			hContent.autoSize = TextFieldAutoSize.NONE
			hContent.width = 300
			
			// Contact
			var cTitle:TextField = Styles.createTextField("contact", "contact/title", {parent: contact_mc,  upperCase:true, x:42, y:34})
			var cLocation:TextField = Styles.createTextField("contact", "contact/loc", {parent: contact_mc,upperCase:true, x:42, y:83})
			var cLoc2:TextField = Styles.createTextField("contact", "contact/loc2", {parent: contact_mc,x:174, y:83})
			var cInfoLeft:TextField = Styles.createTextField("contact", "contact/infoLeft", {parent: contact_mc,upperCase:true, x:42, y:113})
			var cInfoRight:TextField = Styles.createTextField("contact", "contact/infoRight", {parent: contact_mc,x:151, y:112.5})
			cInfoRight.selectable = true
			buttonForm = new GenButton(XmlStringReader.getStringContent("contact","contact/formButton"), GenButton.WIREFRAME_GREY, GenButton.LEFT, GenButton.DOWNARROW2_PICTOGRAM)
			buttonForm.addEventListener(MouseEvent.CLICK, clickFormButtonHandler)
			buttonForm.x = 42
			buttonForm.y = 210
			contact_mc.addChild(buttonForm)
			
			creditButton = new GenButton(XmlStringReader.getStringContent("contact","contact/creditsButton"), GenButton.WIREFRAME_GREY, GenButton.LEFT, GenButton.INFO_PICTOGRAM)
			creditButton.addEventListener(MouseEvent.CLICK, clickCreditButtonHandler)
			creditButton.x = 240
			creditButton.y = 210
			contact_mc.addChild(creditButton)			
			
			contact_mc.buttonMode = true
			contact_mc.linkMail_mc.addEventListener(MouseEvent.ROLL_OVER, rollOverMailAddressHandler)
			contact_mc.linkMail_mc.addEventListener(MouseEvent.ROLL_OUT, rollOutMailAddressHandler)
			contact_mc.linkMail_mc.addEventListener(MouseEvent.CLICK, clickMailAddressHandler)
			
			//Form
			cfTitle = Styles.createTextField("contact", "form/title", {parent: contact_mc,upperCase:true, x:42, y:295})
			cfEmail = Styles.createTextField("contact", "form/email", {parent: _formContainer,upperCase:true,x:58, y:357})
			cfMessage = Styles.createTextField("contact", "form/message", {parent: _formContainer,upperCase:true,x:58, y:397})
			sendButton = new GenButton(XmlStringReader.getStringContent("contact","form/sendButton"))
			sendButton.addEventListener(MouseEvent.CLICK, clickSendHandler)
			sendButton.x = 165
			sendButton.y = 485
			_formContainer.addChild(sendButton)
			mailInput = new TextField()
			mailInput.embedFonts = true
			mailInput.defaultTextFormat = Styles.regular10TextFormat
			mailInput.autoSize = TextFieldAutoSize.NONE
			mailInput.wordWrap = false
			mailInput.type = TextFieldType.INPUT
			mailInput.width = 325
			mailInput.height = 20
			mailInput.x = 58
			mailInput.y = 356
			mailInput.selectable = true
			mailInput.antiAliasType = AntiAliasType.ADVANCED
			mailInput.sharpness = 100
			mailInput.thickness = 50				
			mailInput.addEventListener(MouseEvent.ROLL_OVER, rollOverFieldHandler)
			mailInput.addEventListener(MouseEvent.ROLL_OUT, rollOutFieldHandler)
			mailInput.addEventListener(FocusEvent.FOCUS_IN, focusInHandler)
			mailInput.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler)
			_formContainer.addChild(mailInput)
			msgInput = new TextField();
			msgInput.embedFonts = true
			msgInput.defaultTextFormat  = Styles.regular10TextFormat
			msgInput.selectable = true
			msgInput.autoSize = TextFieldAutoSize.NONE
			msgInput.type = TextFieldType.INPUT
			msgInput.wordWrap = true
			msgInput.multiline = true
			msgInput.height = 64
			msgInput.width = 325
			msgInput.x = 58
			msgInput.y = 396
			msgInput.antiAliasType = AntiAliasType.ADVANCED
			msgInput.sharpness = 100
			msgInput.thickness = 50
			msgInput.addEventListener(MouseEvent.ROLL_OVER, rollOverFieldHandler)
			msgInput.addEventListener(MouseEvent.ROLL_OUT, rollOutFieldHandler)
			msgInput.addEventListener(FocusEvent.FOCUS_IN, focusInHandler)
			msgInput.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler)
			_formContainer.addChild(msgInput)
				
			cancelButton = new GenButton(XmlStringReader.getStringContent("contact","form/cancelButton"), GenButton.WIREFRAME_GREY, GenButton.LEFT, GenButton.CROSS_PICTOGRAM)
			cancelButton.addEventListener(MouseEvent.CLICK, clickCancelHandler)
			cancelButton.x = 313
			cancelButton.y = 485
			_formContainer.addChild(cancelButton)
				
			// Share				
			var sTitle:TextField = Styles.createTextField("contact", "share/title", {parent:share_mc, upperCase:true, x:46, y:34})
			var sTxt1:TextField = Styles.createTextField("contact", "share/txt1", {parent:share_mc,x:155, y:50, width:300, height:110, antialias:StylesSingleton.THICKNESS_50})
			var sTxt2:TextField = Styles.createTextField("contact", "share/txt2", {parent:share_mc,x:48, y:70, width:300, height:110, antialias:StylesSingleton.THICKNESS_50})
			//var sPerma:TextField = Styles.createTextField("contact", "share/permalink", {parent:share_mc,upperCase:true, x:64, y:134})
			var sFollow:TextField = Styles.createTextField("contact", "share/follow", {parent:share_mc,upperCase:true, x:46, y:170})				
			addChild(_maskContactPanel)
			initShareButton(share_mc.shareFb_mc, XmlStringReader.getStringContent("contact", "share/shareFb"))
			initShareButton(share_mc.shareTw_mc, XmlStringReader.getStringContent("contact", "share/shareTw"))
			initShareButton(share_mc.shareGo_mc, XmlStringReader.getStringContent("contact", "share/shareGo"))
			initShareButton(share_mc.followIn_mc, XmlStringReader.getStringContent("contact", "share/followIn"))
			initShareButton(share_mc.followFb_mc, XmlStringReader.getStringContent("contact", "share/followFb"))
			initShareButton(share_mc.followVi_mc, XmlStringReader.getStringContent("contact", "share/followVi"))
			initShareButton(share_mc.followPin_mc, XmlStringReader.getStringContent("contact", "share/followPin"))
			// Scroll
			scroll_mc.x = boundScrollbar.x
			scroll_mc.y = boundScrollbar.y
			scroll_mc.addEventListener(MouseEvent.MOUSE_OVER, scrollOverHandler);
			scroll_mc.addEventListener(MouseEvent.MOUSE_OUT, scrollOutHandler);
			scroll_mc.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
			scroll_mc.addEventListener(MouseEvent.MOUSE_UP, scrollUpHandler);
			scroll_mc.addEventListener(MouseEvent.RELEASE_OUTSIDE, scrollUpHandler);
			
			contact_mc.y = minYContact
				
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		private function initShareButton(button:MovieClip, url:String):void
		{
			buttonsShare[button] = url
			button.addEventListener(MouseEvent.ROLL_OUT, rollOutShareHandler)
			button.addEventListener(MouseEvent.ROLL_OVER, rollOverShareHandler)
			button.addEventListener(MouseEvent.CLICK, clickShareHandler)
			button.buttonMode = true
			button.mouseChildren = false
			rollOutMovieClip(button)
		}
		
		protected function rollOverShareHandler(event:MouseEvent):void
		{
			var target:MovieClip = event.target as MovieClip
			TweenMax.to(target.picto_mc,0.3, {removeTint:true, alpha:1, ease:Quart.easeOut})
			TweenMax.to(target.bg_mc,0.3, {removeTint:true, alpha:1, ease:Quart.easeOut})
		}
		
		protected function clickShareHandler(event:MouseEvent):void
		{
			var target:MovieClip = event.target as MovieClip
			TweenMax.to(target.picto_mc,0.05, {alpha:0.7, ease:Quart.easeOut})
			TweenMax.to(target.bg_mc,0.05, {alpha:0.7, ease:Quart.easeOut})
			dispatchEvent(new StringEvent(CLICK_SHARE_BUTTON, target,buttonsShare[target]))
		}
		
		private function rollOutMovieClip(button:MovieClip):void
		{
			TweenMax.to(button.picto_mc,0.6, {tint:0x56474E, alpha:1, ease:Quart.easeOut})
			TweenMax.to(button.bg_mc,0.6, {tint:0x2E222E, alpha:1, ease:Quart.easeOut})
		}
		
		protected function rollOutShareHandler(event:MouseEvent):void
		{
			var target:MovieClip = event.target as MovieClip
			rollOutMovieClip(target)
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null);
		}
		
		protected function resizeStageHandler(event:Event):void
		{
			var sw:int = stage.stageWidth
			
			if(sw > 1600 && _currentFormat != "large"){
				bg_mc.x = maskGrid_mc.x = -31
				lineSupp_mc.visible = true
				scroll_mc.visible = false
				share_mc.x = 1274
				_currentFormat = "large"
				contact_mc.y = minYContact
				scroll_mc.y = boundScrollbar.y
				close_mc.x = 1610
				creditButton.x = 240//42
				buttonForm.visible = false
				cancelButton.visible = false
				contact_mc.hitArea_mc.width = 840
				contact_mc.form_mc.x = 420
				contact_mc.form_mc.y = -255-20
				cfTitle.x = 42+420
				cfTitle.y = 295-255-8
				sendButton.x = contact_mc.form_mc.msg_mc.width + contact_mc.form_mc.msg_mc.x - sendButton.width
				sendButton.y = 485-4
				contact_mc.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				
				if(result_mc){
					result_mc.x = 420
					result_mc.y = -275
				}
			}
			
			if(sw < 1680 && _currentFormat == "large"){
				close_mc.x = stage.stageWidth-10-close_mc.width
			}
			
			if(sw < 1600 && _currentFormat != "normal"){
				close_mc.x = 1610-420
				contact_mc.y = minYContact
				scroll_mc.y = boundScrollbar.y
				share_mc.x = 1274-420
				bg_mc.x = maskGrid_mc.x = -31-420
				lineSupp_mc.visible = false
				scroll_mc.visible = true
				_currentFormat = "normal"
				creditButton.x = 240
				buttonForm.visible = true
				cancelButton.visible = true
				contact_mc.hitArea_mc.width = 420
				contact_mc.form_mc.x = contact_mc.form_mc.y = 0
				cfTitle.x = 42
				cfTitle.y = 295
				sendButton.x = 165
				sendButton.y = 485
				contact_mc.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				
				if(result_mc){
					result_mc.x = 0
					result_mc.y = 0
				}
			}
			
			_maskContactPanel.width = sw
		}
		
		protected function clickCreditButtonHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(ContactShareEvent.OPEN_CREDITS_PANEL));			
		}
		
		protected function clickMailAddressHandler(e:Event):void
		{
			Preloader.track("_contact/clickMailAddress");
			navigateToURL(new URLRequest(XmlStringReader.getStringContent("contact", "contact/linkMail")))
		}
		
		protected function rollOverMailAddressHandler(e:MouseEvent):void
		{
			TweenMax.to(Sprite(e.target),0.3,{alpha:1, ease:Quart.easeOut})
			TweenMax.to(contact_mc.iconMail_mc,0.3,{alpha:1, ease:Quart.easeOut})
		}
		
		protected function rollOutMailAddressHandler(e:MouseEvent):void
		{
			TweenMax.to(Sprite(e.target),0.5,{alpha:0, ease:Quart.easeOut})
			TweenMax.to(contact_mc.iconMail_mc,0.5,{alpha:0.5, ease:Quart.easeOut})
		}		
		
		protected function rollOverFieldHandler(event:MouseEvent):void
		{
			var target:TextField = event.target as TextField
			if(target == msgInput){
				if(_focusOnMsg){
					TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:1, glowFilter:{alpha:1}})
				}else{
					TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:1, glowFilter:{alpha:0}})
				}
			}else{
				if(_focusOnMail){
					TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:1, glowFilter:{alpha:1}})
				}else{
					TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:1, glowFilter:{alpha:0}})
				}
			}
		}
		
		protected function rollOutFieldHandler(event:MouseEvent):void
		{
			var target:TextField = event.target as TextField
			if(target == msgInput){
				if(_focusOnMsg){
					TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:1, glowFilter:{alpha:0}})
				}else{
					TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:0, glowFilter:{alpha:0}})
				}
			}else{
				if(_focusOnMail){
					TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:1, glowFilter:{alpha:0}})
				}else{
					TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:0, glowFilter:{alpha:0}})
				}
			}
		}
		
		protected function focusOutHandler(event:FocusEvent = null):void
		{
			var target:TextField = event ? event.target as TextField : null
			if(!target || target != mailInput){
				_focusOnMsg = false
				if(!target || target.length < 2){
					TweenMax.to(cfMessage, 0.3, {alpha:1})
					cfMessage.htmlText = XmlStringReader.getStringContent("contact", "form/message").toUpperCase();
				}
				TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:0, glowFilter:{alpha:0}})
				TweenMax.to(_formContainer.msg_mc, 0.3, {removeTint:true})
			}
			if(!target || target != msgInput){
				_focusOnMail = false
				if(!target || target.length < 2){
					TweenMax.to(cfEmail, 0.3, {alpha:1})
					cfEmail.htmlText = XmlStringReader.getStringContent("contact", "form/email").toUpperCase();
				}
				TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:0, glowFilter:{alpha:0}})
				TweenMax.to(_formContainer.mail_mc, 0.3, {removeTint:true})				
			}
		}
		
		protected function focusInHandler(event:FocusEvent):void
		{
			var target:TextField = event.target as TextField
			if(target == msgInput){
				_focusOnMsg = true
				TweenMax.to(cfMessage, 0.3, {alpha:0})
				TweenMax.to(_formContainer.lightMsg_mc, 0.3, {alpha:1, glowFilter:{alpha:1}})
				TweenMax.to(_formContainer.msg_mc, 0.3, {tint:0x463D46})
				TweenMax.to(msgInput, 0.3, {alpha:1})
			}else{
				_focusOnMail = true
				TweenMax.to(cfEmail, 0.3, {alpha:0})
				TweenMax.to(_formContainer.lightMail_mc, 0.3, {alpha:1, glowFilter:{alpha:1}})
				TweenMax.to(_formContainer.mail_mc, 0.3, {tint:0x463D46})
				TweenMax.to(mailInput, 0.3, {alpha:1})
			}
		}
		
		protected function clickSendHandler(event:MouseEvent):void
		{	
			var err:Boolean = false
				
			if(mailInput.length < 2){
				cfEmail.htmlText = XmlStringReader.getStringContent("contact", "form/errorMandatory").toUpperCase();
				TweenMax.to(cfEmail, 0.3, {alpha:1})
				TweenMax.to(mailInput, 0.3, {alpha:0})
				TweenMax.to(_formContainer.mail_mc, 0.3, {tint:Colors.VINTAGE_RED})
				err = true
			}
			
			if(msgInput.length < 2){
				cfMessage.htmlText = XmlStringReader.getStringContent("contact", "form/errorMandatory").toUpperCase();
				TweenMax.to(cfMessage, 0.3, {alpha:1})
				TweenMax.to(msgInput, 0.3, {alpha:0})
				TweenMax.to(_formContainer.msg_mc, 0.3, {tint:Colors.VINTAGE_RED})
				err = true
			}
			if(err) return
			
			sendButton.buttonMode = false
			sendButton.mouseEnabled = false
			sendButton.alpha = 0.5
				
			var request:URLRequest = new URLRequest(Path.MAIL_SENDER)
			request.method = URLRequestMethod.POST
			var vars:URLVariables = new URLVariables();
			vars.email = mailInput.text
			vars.message = msgInput.text
			request.data = vars
				
			var sender:URLLoader = new URLLoader(request)
			sender.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
			sender.addEventListener(Event.COMPLETE, sendMailCompleteHandler)
		}
		
		private function showResultMail(success:Boolean = true):void
		{
			TweenMax.to(_formContainer,0.5, {autoAlpha:0})
			if(!result_mc){
				result_mc = new Sprite();
				contact_mc.addChild(result_mc);
				result_mc.visible = false
				result_mc.alpha = 0
				_titleResult = Styles.createTextField("contact", "serverAnswers/successTitle",{parent:result_mc, upperCase:true, x:72} )
				_contentResult = Styles.createTextField("contact", "serverAnswers/successContent",{parent:result_mc, upperCase:false, x:72} )
				_backButtonResults = new GenButton(XmlStringReader.getStringContent("contact", "serverAnswers/backButton"))
				_backButtonResults.y = 458
				_backButtonResults.x = 72
				_backButtonResults.addEventListener(MouseEvent.CLICK, clickBackButtonResultsHandler)
				result_mc.addChild(_backButtonResults)
				if(_currentFormat == "large"){
					result_mc.x = 420
					result_mc.y = -275
				}
			}
			_successResult = success
			if(!success){
				
				_titleResult.y = 370
				_contentResult.y = 395
				_titleResult.htmlText = XmlStringReader.getStringContent("contact", "serverAnswers/errorTitle").toUpperCase()
				_contentResult.htmlText = XmlStringReader.getStringContent("contact", "serverAnswers/errorContent")
			}else{
				_titleResult.y = 370
				_contentResult.y = 395
				_titleResult.htmlText = XmlStringReader.getStringContent("contact", "serverAnswers/successTitle").toUpperCase()
				_contentResult.htmlText = XmlStringReader.getStringContent("contact", "serverAnswers/successContent")
			}
			TweenMax.to(result_mc, 0.5, {autoAlpha:1})
		}
		
		protected function clickBackButtonResultsHandler(event:MouseEvent):void
		{
			TweenMax.to(result_mc,0.5,{autoAlpha:0})
			TweenMax.to(_formContainer,0.5,{autoAlpha:1})
			if(_successResult){
				mailInput.text = ""
				msgInput.text = ""
				focusOutHandler();
			}
		}
		
		protected function sendMailCompleteHandler(event:Event):void
		{
			var result:String = URLLoader(event.target).data
			
			sendButton.alpha = 1
			sendButton.buttonMode = true
			sendButton.mouseEnabled = true
			
			Preloader.track("_contact/contactForm/"+result);
				
			if(result == "invalid"){
				cfEmail.htmlText = XmlStringReader.getStringContent("contact", "form/errorMail").toUpperCase();
				TweenMax.to(cfEmail, 0.3, {alpha:1})
				TweenMax.to(mailInput, 0.3, {alpha:0})
				TweenMax.to(_formContainer.mail_mc, 0.3, {tint:Colors.VINTAGE_RED})					
			}else if(result == "error"){
				showResultMail(false)
			}else if(result == "success"){
				
				showResultMail(true)
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			Preloader.track("_contact/contactForm/IOError");
			//trace("SendMail IO Error")
		}
		
		protected function clickCancelHandler(event:MouseEvent):void
		{
			_scrollMcTargetPosition = boundScrollbar.y
			mailInput.text = ""
			msgInput.text = ""
			focusOutHandler();
				
			updateScrollPosition();
		}
		
		protected function clickFormButtonHandler(event:MouseEvent):void
		{
			_scrollMcTargetPosition = boundScrollbar.y + boundScrollbar.height
			updateScrollPosition();
		}
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{	
			_scrollMcTargetPosition += (-event.delta*10)
			if(_scrollMcTargetPosition < boundScrollbar.y ) _scrollMcTargetPosition = boundScrollbar.y
			if(_scrollMcTargetPosition > boundScrollbar.y+boundScrollbar.height ) _scrollMcTargetPosition = boundScrollbar.y+boundScrollbar.height
			updateScrollPosition()
		}
		
		protected function scrollOverHandler(event:MouseEvent):void
		{			
			highLight(ContactShareVO.CONTACT)
			TweenMax.to(scroll_mc, 0.3, {alpha:1, tint:0x463D46})
		}
		
		protected function scrollOutHandler(event:MouseEvent):void
		{
			TweenMax.to(scroll_mc, 0.8, {alpha:1, removeTint:true})
		}
		
		protected function scrollDownHandler(event:MouseEvent):void
		{
			TweenMax.to(scroll_mc, 0.3, {alpha:1, tint:Colors.VINTAGE_RED})
			scroll_mc.startDrag(false, boundScrollbar)
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
		}
		
		protected function scrollUpHandler(event:MouseEvent):void
		{
			TweenMax.to(scroll_mc, 0.3, {alpha:0.5, removeTint:true})
			scroll_mc.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			_scrollMcTargetPosition = scroll_mc.y
			updateScrollPosition(false);
		}
		
		private function updateScrollPosition(updateScrollMc:Boolean = true):void
		{
			var targetContact:int = minYContact-(((_scrollMcTargetPosition - boundScrollbar.y) / boundScrollbar.height) * 260)
			TweenMax.to(contact_mc, 0.3, {y:targetContact})
			if(updateScrollMc) TweenMax.to(scroll_mc, 0.3, {y:_scrollMcTargetPosition})
		}
		
		protected function hightlightHandler(event:MouseEvent):void
		{			
			var area:String
			if(event.currentTarget == share_mc) area = ContactShareVO.SHARE
			if(event.currentTarget == contact_mc) area = ContactShareVO.CONTACT
			
			highLight(area)
			dispatchEvent(new StringEvent(ContactShareEvent.HIGHLIGHT, this, area));
		}
		
		protected function clickClosePanel(event:MouseEvent):void
		{
			clickCancelHandler(null)
			dispatchEvent(new Event(ContactShareEvent.CLOSE_CONTACT_PANEL))
		}
		
		public function open(part:String):void
		{
			if(!_isOpen) _gridShade.alpha = 1
			TweenMax.to(_gridShade, 1, {alpha:0})
			visible = true
			_isOpen = true
				
			TweenMax.to(mask, 0.4,{y:0, height:380, ease:commonEase})
			highLight(part)
			
			if(hire_mc.x < 0){
				TweenMax.to(hire_mc, 0.5, {delay:0.25, x:String(_initX)})
				TweenMax.to(bgHireMe_mc, 0.5, {delay:0.2, x:String(_initX)})
				//TweenMax.to(maskHireMe_mc, 0.5, {delay:0.2, x:String(_initX)})
			}
		}
		
		private function highLight(part:String):void
		{
			if(part == ContactShareVO.CONTACT){
				TweenMax.to(contact_mc,0.3,{alpha:1, ease:Quart.easeOut})
				TweenMax.to(buttonForm,0.3,{colorMatrixFilter:{saturation:1}, ease:Quart.easeOut})
				TweenMax.to(share_mc, 0.3, {alpha:0.2, ease:Quart.easeOut})
				TweenMax.to(scroll_mc, 0.3, {alpha:1, removeTint:true, ease:Quart.easeOut})
			}else{
				TweenMax.to(contact_mc,0.3,{alpha:0.2, ease:Quart.easeOut})
				TweenMax.to(buttonForm,0.3,{colorMatrixFilter:{saturation:0}, ease:Quart.easeOut})
				TweenMax.to(share_mc, 0.3, {alpha:1, ease:Quart.easeOut})
				TweenMax.to(scroll_mc, 0.3, {alpha:0, removeTint:true, ease:Quart.easeOut})
			}
		}
		
		public function close():void
		{
			_isOpen = false
			TweenMax.to(mask, 0.4,{y:0, height:0, ease:commonEase, onComplete:switchVisibility})
			//TweenMax.to(shadow01_mc, 0.4,{y:posYShadow1[0], ease:commonEase})
			//TweenMax.to(shadow02_mc, 0.4,{y:posYShadow2[0], ease:commonEase})
		}
		
		public function switchVisibility():void
		{
			visible = false
		}
		
		
		public function rollOverHeader():void
		{
			if(!_isOpen) return
			
			TweenMax.to(mask, 0.3,{y:MenuHeader.HEIGHT_OVER-MenuHeader.HEIGHT_OUT, height:380, ease:Quart.easeOut})		
		}
		
		public function rollOutHeader():void
		{
			if(!_isOpen) return
			TweenMax.to(mask, 0.3,{y:0, height:380, ease:Quart.easeOut})
		}
	}
}