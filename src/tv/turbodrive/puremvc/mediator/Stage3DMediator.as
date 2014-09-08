package tv.turbodrive.puremvc.mediator
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.away3d.core.GridMenu;
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.GroupSprite3DEvent;
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.Menu3DView;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	import tv.turbodrive.puremvc.mediator.view.component.CreditsView;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class Stage3DMediator extends Mediator implements IMediator
	{
		static public const NAME:String = "Stage3DMediator"
		
		private var _parentContainer:Sprite
		
		public static var VIDEOPLANE_HIDDEN:String = NAME + "VideoPlaneHidden";
		public static var VIDEOPLANE_READY:String = NAME + "VideoPlaneReady";
		public static var OPEN_TRIANGLE_MENU:String = NAME + "openTriangleMenu";		
		public static var CLOSE_TRIANGLE_MENU:String = NAME + "closeTriangleMenu";		
		public static var REQUIRED_ASSETS_COMPLETE:String = NAME + "requiredAssetsComplete";
		private var stage3DManager:Stage3DManager;
		private var stage3DProxy:Stage3DProxy;
		private var menu3DView:Menu3DView;
		private var openPanels:Object = {}

		public function Stage3DMediator(parent:Sprite)
		{
			_parentContainer = parent
			super(NAME, Stage3DView.instance);
		}
		
		override public function onRegister():void
		{	
			stage3DManager = Stage3DManager.getInstance(_parentContainer.stage);
			stage3DProxy = stage3DManager.getFreeStage3DProxy()
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContext3DCreatedHandler);
			stage3DProxy.color = 0x000000
			stage3DProxy.antiAlias = 2				
		}
		
		private function onContext3DCreatedHandler(e:Event):void
		{			
			initStage3DView()
			initMenu3DView()
			stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContext3DCreatedHandler);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			
			// stage3dview on the background
			stage3DView.preRender();
			// menu3DView on the foreground
			if(menu3DView) menu3DView.render();
		}
		
		private function initMenu3DView():void
		{
			menu3DView = new Menu3DView(stage3DProxy)
			menu3DView.addEventListener(GridMenu.CLICK_BUTTON, clickButtonGridMenu);
			menu3DView.addEventListener(Menu3DView.MENU_OPEN, menuOpenHandler);
			menu3DView.addEventListener(Menu3DView.MENU_MOVE, menuMoveHandler);
			_parentContainer.addChild(menu3DView)
		}
		
		protected function menuMoveHandler(event:ObjectEvent):void
		{	
			translateView(0)
			sendNotification(ApplicationFacade.MENU3D_MOVE, event.getObject())
		}
		
		protected function menuOpenHandler(event:Event):void
		{
			translateView(0)
			//stage3DView.pauseRenderer()
		}
		
		private function initStage3DView():void
		{
			stage3DView.addEventListener(Stage3DView.VIDEO_PLANE_HIDDEN, videoPlaneHiddenHandler)
			stage3DView.addEventListener(Stage3DView.VIDEO_PLANE_READY, videoPlaneReadyHandler)
			stage3DView.addEventListener(TransitionEvent.TRANSITION_COMPLETE, transitionCompleteHandler)
			stage3DView.addEventListener(TransitionEvent.TRANSITION_STARTS, transitionStartsHandler)
			stage3DView.addEventListener(TransitionEvent.FIRSTOFMULTI_COMPLETE, firstOfMultiCompleteHandler)
			stage3DView.addEventListener(Stage3DView.READY, s3dReadyHandler)
			stage3DView.addEventListener(PageEvent.CHANGE_PAGE, changePageEvent)
			stage3DView.addEventListener(ContactShareEvent.OPEN_CONTACT_PANEL, openContactPanelHandler)
			//stage3DView.addEventListener(Stage3DView.OPEN_VIDEOPLAYER, openVideoHandler)
			//stage3DView.addEventListener(Stage3DView.CLOSE_VIDEOPLAYER, closeVideoHandler)
			//stage3DView.addEventListener(Stage3DView.UPDATE_VIDEOPLAYER, updateVideoHandler)
			stage3DView.addEventListener(Stage3DView.UPDATE_3DPOSITION, update3DPosition)
			stage3DView.addEventListener(Stage3DView.CLOSE_SUBPAGE, closeProjectHandler)
			stage3DView.addEventListener(Stage3DView.OPEN_SUBPAGE, openProjectHandler)
			//stage3DView.addEventListener(GridMenu.CLICK_BUTTON, clickButtonGridMenu)
				
			if(!_parentContainer.contains(stage3DView)){
				_parentContainer.addChildAt(stage3DView,0);
			}
			
			stage3DView.initView3D(stage3DProxy)
		}	
		
		protected function firstOfMultiCompleteHandler(event:TransitionEvent):void
		{
			sendNotification(ApplicationFacade.LOAD_ASSETS, event.transition.nextPage);
		}
		
		protected function openProjectHandler(event:GroupSprite3DEvent):void
		{
			sendNotification(Overlay2DMediator.OPEN_SUBPAGE,event.groupTps3d)
		}
		
		protected function closeProjectHandler(event:Event):void
		{
			sendNotification(Overlay2DMediator.CLOSE_SUBPAGE)
		}
		
		protected function update3DPosition(event:GroupSprite3DEvent):void
		{			
			sendNotification(Overlay2DMediator.UPDATE_CONTENT_POSITION,event.groupTps3d)
		}
		
		
		protected function openContactPanelHandler(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.OPEN_CONTACT_PANEL,event.getString())
		}		
		
		protected function transitionCompleteHandler(event:TransitionEvent):void
		{
			//var trs:TransitionPageData = event.transition
			//if(!trs.previousPage || (trs.nextPage.name != trs.previousPage.name || trs.nextPage.environment != trs.previousPage.environment)){
				sendNotification(ApplicationFacade.TRANSITION_COMPLETE, event.transition)
			//}
		}
		
		protected function transitionStartsHandler(event:TransitionEvent):void
		{
			sendNotification(ApplicationFacade.TRANSITION_STARTS, event.transition)
		}
		
		override public function listNotificationInterests():Array
		{
			return [BackButtonsMediator.CLICK_BACK, ApplicationFacade.NAVIGATE_TO_SUBPAGE, ApplicationFacade.OPEN_CONTACT_PANEL, ApplicationFacade.OPEN_CREDITS, ApplicationFacade.CLOSE_CREDITS,
				Menu2DMediator.ROLLOUT_HEADER, Menu2DMediator.ROLLOVER_HEADER, ApplicationFacade.OPEN_CONTACT_PANEL, ApplicationFacade.CLOSE_CONTACT_PANEL, ApplicationFacade.CLOSE_TRIANGLE_MENU,
				ApplicationFacade.MENU2D_CLICK_TRI, ApplicationFacade.MENU2D_OUT, ApplicationFacade.MENU2D_OVER, REQUIRED_ASSETS_COMPLETE, SwitchPageProxy.START_SWITCH,
				SwitchPageProxy.MULTIPART_RESUME_SWITCH, SwitchPageProxy.END_SWITCH, OPEN_TRIANGLE_MENU, CLOSE_TRIANGLE_MENU]
		}		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case REQUIRED_ASSETS_COMPLETE:
					stage3DView.initConstantAssets();
					if(menu3DView) menu3DView.initConstantAssets();
					break;
				case BackButtonsMediator.CLICK_BACK:
					stage3DView.navigationToSubPage(SubPageNames.MAIN);
					break;
				case Menu2DMediator.ROLLOUT_HEADER:
					if(menu3DView) menu3DView.slideUpFromHeader();
					break;
				case Menu2DMediator.ROLLOVER_HEADER:
					if(menu3DView) menu3DView.slideDownFromHeader();
					break;
				case SwitchPageProxy.START_SWITCH:
					stage3DView.startTransition(notification.getBody() as TransitionPageData);
					break;						
				case SwitchPageProxy.MULTIPART_RESUME_SWITCH:
					stage3DView.resumeMultiPartTransition(notification.getBody() as TransitionPageData);
					break;		
				case SwitchPageProxy.END_SWITCH:
					if(menu3DView) menu3DView.updateState(TransitionPageData(notification.getBody()).nextPage);
					break;		
				case OPEN_TRIANGLE_MENU : 					
					if(menu3DView) menu3DView.enableTriangleMenu(notification.getBody() as String);
					pause("triangleMenu")
					stage3DView.openTriangleMenu();
					break;
				case CLOSE_TRIANGLE_MENU :
					stage3DView.closeTriangleMenu();
					resume("triangleMenu")
					if(menu3DView) menu3DView.disableTriangleMenu();
					break;
				case ApplicationFacade.MENU2D_OVER :
					if(menu3DView) menu3DView.rollOverTriangle(notification.getBody() as String);
					break;
				case ApplicationFacade.MENU2D_OUT :
					if(menu3DView) menu3DView.rollOutTriangle(notification.getBody() as String);
					break;
				case ApplicationFacade.MENU2D_CLICK_TRI :
					if(menu3DView) menu3DView.clickTriangle(notification.getBody() as String);
					break;				
				case ApplicationFacade.OPEN_CONTACT_PANEL:
					pause("contactPanel")			
					break;
				case ApplicationFacade.OPEN_CREDITS:
					pause("creditsPanel")
					translateView(-CreditsView.HEIGHT_OPEN)					
					break;
				case ApplicationFacade.CLOSE_CONTACT_PANEL:
					resume("contactPanel")
					break;
				case ApplicationFacade.CLOSE_CREDITS:
					resume("creditsPanel")
					translateView(0)					
					break;
				case ApplicationFacade.NAVIGATE_TO_SUBPAGE:
					stage3DView.navigationToSubPage(notification.getBody() as String)
					break;
			}
		}		
		
		private function translateView(yTarget:int):void
		{
			var duration:Number = 0.5 //yTarget == 0 ? 0.4 : 0.4
			
			TweenMax.to(stage3DView, duration,{y:yTarget, ease:Quart.easeOut})
			TweenMax.to(menu3DView, duration,{y:yTarget, ease:Quart.easeOut})
		}
		
		private function resume(panel:String):void
		{
			/*if(!panel){
				openPanels.contact = openPanels.creditsPanel = false
			}else{*/
				openPanels[panel] = false
			//}			
			
			if(!openPanels.contactPanel && !openPanels.creditsPanel && !openPanels.triangleMenu){
				stage3DView.resumeContent()
			}
		}
		
		private function pause(panel:String):void
		{
			openPanels[panel] = true
			stage3DView.pauseContent()
		}
		
		protected function s3dReadyHandler(event:Event):void
		{
			//trace("s3dReadyHandler !")
			sendNotification(ApplicationFacade.INIT_SWFADDRESS, _parentContainer.root);
		}		
		
		protected function videoPlaneHiddenHandler(event:Event):void
		{
			//trace("-------- videoPlaneHiddenHandler")
			
			sendNotification(ApplicationFacade.PAUSE_REEL_STREAM);
			sendNotification(Stage3DMediator.VIDEOPLANE_HIDDEN)
		}
		
		protected function videoPlaneReadyHandler(event:Event):void
		{
			sendNotification(Stage3DMediator.VIDEOPLANE_READY)			
		}
		
		protected function changePageEvent(event:PageEvent):void
		{
			//trace(NAME + " - changePageEvent")
			sendNotification(ApplicationFacade.CHANGE_PAGE,event.page);
		}
		
		protected function clickButtonGridMenu(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.CHANGE_PAGE,StructureProxy.getPage(event.getString()));
		}
				
		private function get stage3DView():Stage3DView
		{
			return viewComponent as Stage3DView
		}
	}
}