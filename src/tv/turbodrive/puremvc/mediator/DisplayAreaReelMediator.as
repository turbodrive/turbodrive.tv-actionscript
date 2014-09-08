package tv.turbodrive.puremvc.mediator
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import away3d.debug.AwayStats;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.GmdView;
	import tv.turbodrive.puremvc.mediator.view.ReelVideoView;
	import tv.turbodrive.puremvc.mediator.view.component.CreditsView;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.Config;
	
	public class DisplayAreaReelMediator extends Mediator implements IMediator
	{
		
		static public const NAME:String = "DisplayAreaReelMediator"
		
		private var _parentContainer:Sprite;
		private var _gmdView:GmdView;

		private var _lockResume:Boolean = false;
		private var _openedCredits:Boolean = false
		private var _openedContact:Boolean = false
		
		private var _openedTriangleMenu3D:Boolean = false;
		public function DisplayAreaReelMediator(parent:Sprite)
		{
			_parentContainer = parent
			super(mediatorName);
		}
		
		override public function onRegister():void
		{
			_gmdView = new GmdView();
			_parentContainer.addChild(_gmdView)
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.OPEN_CREDITS, ApplicationFacade.CLOSE_CREDITS, ApplicationFacade.OPEN_CONTACT_PANEL, ApplicationFacade.CLOSE_CONTACT_PANEL, Stage3DMediator.OPEN_TRIANGLE_MENU, Stage3DMediator.CLOSE_TRIANGLE_MENU, SwitchPageProxy.START_SWITCH, SwitchPageProxy.END_SWITCH, SwitchPageProxy.MULTIPART_RESUME_SWITCH, SwitchPageProxy.GMD_APPEARING, SwitchPageProxy.GMD_PAUSE, SwitchPageProxy.GMD_RESUME, SwitchPageProxy.GMD_HIDE]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SwitchPageProxy.START_SWITCH :
					startSwitch(notification.getBody() as TransitionPageData)
					break;
				case SwitchPageProxy.MULTIPART_RESUME_SWITCH :
					resumeSwitch(notification.getBody() as TransitionPageData)
					break;
				case SwitchPageProxy.END_SWITCH :
					checkShowVideo(notification.getBody() as TransitionPageData)
					break;
				case SwitchPageProxy.GMD_APPEARING :
					_gmdView.show(notification.getBody() as Number);
					break;
				case SwitchPageProxy.GMD_PAUSE :
					_gmdView.pause();
					break;
				case SwitchPageProxy.GMD_RESUME :
					_gmdView.resume();
					break;
				case SwitchPageProxy.GMD_HIDE :
					_gmdView.hide();
					break;
				case Stage3DMediator.OPEN_TRIANGLE_MENU :
					_gmdView.pause();
					openTriangleMenu()
					break;
				case Stage3DMediator.CLOSE_TRIANGLE_MENU :
					_gmdView.resume()
					closeTriangleMenu();
					break;
				case ApplicationFacade.OPEN_CONTACT_PANEL:
					openContact()
					break;
				case ApplicationFacade.OPEN_CREDITS:
					openCredits()
					break;
				case ApplicationFacade.CLOSE_CONTACT_PANEL:
					closeContact();
					break;
				case ApplicationFacade.CLOSE_CREDITS:
					closeCredits();
					break;
			}
		}
		
		private function translateView(yTarget:int):void
		{
			if(!reelVideoView) return
			var duration:Number = 0.5			
			TweenMax.to(reelVideoView, duration,{y:yTarget, ease:Quart.easeOut})
		}
		
		private function closeContact():void
		{
			_openedContact = false
			checkVideoPauseResume()
		}
		
		private function openContact():void
		{
			_openedContact = true
			checkVideoPauseResume()
		}
		
		private function openCredits():void
		{
			translateView(-CreditsView.HEIGHT_OPEN)
			_openedCredits = true
			checkVideoPauseResume()
		}
		
		private function closeCredits():void
		{			
			translateView(0)
			_openedCredits = false
			checkVideoPauseResume()
		}
		
		private function checkVideoPauseResume():void
		{
			if(_openedContact || _openedCredits || _openedTriangleMenu3D){
				sendNotification(ApplicationFacade.PAUSE_REEL_STREAM)
				_gmdView.pause()
			}
			if(!_openedContact && !_openedCredits && !_openedTriangleMenu3D){
				if(reelVideoView && reelVideoView.visible) sendNotification(ApplicationFacade.RESUME_REEL_STREAM)
				_gmdView.resume()
			}
		}
		
		
		private function closeTriangleMenu():void
		{
			_openedTriangleMenu3D = false
			if(_lockResume) return
			_gmdView.visible = reelVideoView.globalVisibility = true
			checkVideoPauseResume()
		}
		
		private function openTriangleMenu():void
		{
			_openedTriangleMenu3D = true
			if(_lockResume) return
			_gmdView.visible = reelVideoView.globalVisibility = false
			checkVideoPauseResume()
		}
		
		private function startSwitch(info:TransitionPageData):void
		{
		
			if(info.nextPage.environment == PagesName.FOLIO){
				_lockResume = true
				_gmdView.hide();
				_gmdView.visible = false
			}
			
			if(info.previousPage && info.previousPage.environment == PagesName.REEL){
				_lockResume = true
				_gmdView.hide();
				// goto FOLIO
				// init textureBuffer
				// >> automatic
			}else if(info.nextPage.environment == PagesName.REEL){
				_lockResume = false
				// goto REEL
				// wait while the buffer is filling out
				addVideo(false)
			}
		}
		
		private function resumeSwitch(info:TransitionPageData):void
		{
			if(info.previousPage && info.previousPage.environment == PagesName.REEL){
				// goto FOLIO
				// clean ?
			}else if(info.previousPage && info.previousPage.environment == PagesName.FOLIO && info.nextPage.environment == PagesName.REEL){
				// goto REEL
				// showVideo in few times...	
				addVideo(false)
			}
		}
		
		private function removeFromStage():void
		{
			if(_parentContainer.contains(reelVideoView)) _parentContainer.removeChild(reelVideoView)
		}
		
		private function addVideo(visible:Boolean):void
		{						
			if(!viewComponent){
				var reelVideo:ReelVideoView = new ReelVideoView()
				reelVideo.addEventListener(ReelVideoView.CLICK_REEL, clickReelHandler)
				setViewComponent(reelVideo)
			}
			
			if(!reelVideoView.parent){
				var depth:int = 0
				if(_parentContainer.numChildren > 0 && _parentContainer.getChildAt(0) is AwayStats){
					depth = 1
				}
				_parentContainer.addChildAt(reelVideoView, depth)
			}			
			
			reelVideoView.globalVisibility = visible
			reelVideoView.updateStream()
		}
		
		private function checkShowVideo(info:TransitionPageData):void
		{
			if(info.nextPage.environment == PagesName.REEL) _gmdView.visible = true
			
			if(reelVideoView){				
				if(info.nextPage.environment == PagesName.REEL){
					if(info.nextPage.id == PagesName.REEL && Config.IS_ONLINE){
						reelVideoView.clickEnabled = false
					}else{
						reelVideoView.clickEnabled = true
					}
					
					if(info.nextPage.id == PagesName.REEL || info.nextPage.id == PagesName.INTRO){
						reelVideoView.flashWhiteEnabled = false
					}else{
						reelVideoView.flashWhiteEnabled = true
					}
				}
				
			}
			
			if(info.nextPage.environment == PagesName.REEL){
				if(!info.previousPage){
					addVideo(true)
				}
			}
		}
		
		protected function clickReelHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CLICK_VIDEO,event);
			_gmdView.hide()
		}
		
		private function hideVideo():void
		{
			if(reelVideoView && reelVideoView.visible) reelVideoView.visible = false
		}
		
		private function get reelVideoView():ReelVideoView
		{
			return ReelVideoView(viewComponent);
		}
		
	}
}