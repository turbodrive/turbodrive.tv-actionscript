package tv.turbodrive.puremvc.mediator
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.Menu2DView;
	import tv.turbodrive.puremvc.mediator.view.component.CopyrightView;
	import tv.turbodrive.puremvc.mediator.view.component.MenuHeader;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;

	public class Menu2DMediator extends Mediator implements IMediator
	{
		static public const NAME:String = "HeaderMediator";		
		public static const OPEN_TRIANGLE_MENU:String = NAME + "openTriangleMenu";
		public static const CLOSE_TRIANGLE_MENU:String = NAME + "closeTriangleMenu";
		public static const ROLLOVER_HEADER:String = NAME + "rollOverHeader";
		public static const ROLLOUT_HEADER:String =  NAME + "rollOutHeader";
		public static const COPYBUTTON_OVER:String = NAME + "copyrightButtonOver";
		public static const COPYBUTTON_OUT:String = NAME + "copyrightButtonOut";
		
		private var _container:Sprite;
		private var _memMode:String
		
		private var _copyRight:CopyrightView;
		public function Menu2DMediator(container:Sprite=null)
		{
			_container = container			
			super(NAME);
		}
		
		override public function onRegister():void
		{
			_copyRight = new CopyrightView()
			_copyRight.addEventListener(MouseEvent.CLICK, clickCopyHandler)
			_copyRight.addEventListener(MouseEvent.ROLL_OVER, rolloverCopyHandler)
			_copyRight.addEventListener(MouseEvent.ROLL_OUT, rolloutCopyHandler)
			_container.addChild(_copyRight)
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.CLOSE_CREDITS, ApplicationFacade.OPEN_CREDITS, Stage3DMediator.REQUIRED_ASSETS_COMPLETE, ControlReelPlayerMediator.START_HIDING_TIMELINE,
				ApplicationFacade.OPEN_CONTACT_PANEL, ApplicationFacade.CLOSE_CONTACT_PANEL, ApplicationFacade.MENU3D_MOVE, CLOSE_TRIANGLE_MENU, OPEN_TRIANGLE_MENU, SwitchPageProxy.LIGHT_HEADER,
				SwitchPageProxy.START_SWITCH, SwitchPageProxy.END_SWITCH, ControlReelPlayerMediator.HIDE_TIMELINE, ControlReelPlayerMediator.SHOW_TIMELINE, ControlReelPlayerMediator.MAINTIMELINE_YMOVE]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName()){
				case Stage3DMediator.REQUIRED_ASSETS_COMPLETE:
					init();
					break;
				case SwitchPageProxy.START_SWITCH :
					startTransition(notification.getBody() as TransitionPageData);
					break;
				case SwitchPageProxy.END_SWITCH:	
					completeTransition(notification.getBody() as TransitionPageData)
					break;
				case ApplicationFacade.OPEN_CREDITS:
					_copyRight.hide()
					menu2dView.openCredits();
					break;
				case ApplicationFacade.CLOSE_CREDITS:
					_copyRight.show()
					menu2dView.closeCredits();
					break;
				case ControlReelPlayerMediator.HIDE_TIMELINE:	
					hide();
					break;
				case ControlReelPlayerMediator.SHOW_TIMELINE:
					_copyRight.openTimeline()
					show();
					break;
				case ControlReelPlayerMediator.START_HIDING_TIMELINE:
					_copyRight.closeTimeline();
					startHidingTimeline();
					break;
				case ControlReelPlayerMediator.MAINTIMELINE_YMOVE:
					mainLineTimelineYMovehandler(notification.getBody() as Number)
					break;
				case SwitchPageProxy.LIGHT_HEADER:
					lightHeader();
					break;
				case OPEN_TRIANGLE_MENU :
					if(menu2dView){
						menu2dView.open(notification.getBody() as String);
						menu2dView.closeContactPanel();
						menu2dView.closeCredits();
					}
					break;
				case CLOSE_TRIANGLE_MENU :
					if(menu2dView){
						menu2dView.close();
						menu2dView.closeContactPanel();
						menu2dView.closeCredits();
					}
					break;
				case ApplicationFacade.MENU3D_MOVE :
					if(menu2dView){
						menu2dView.update2DMenu(notification.getBody() as Rectangle);
					}					
					break;
				case ApplicationFacade.OPEN_CONTACT_PANEL:
					menu2dView.openContacPanel(notification.getBody() as  String);				
					break;
				case ApplicationFacade.CLOSE_CONTACT_PANEL:
					menu2dView.closeContactPanel();
					break;		
			}
		}
		
		private function init():void
		{
			buildHeader()
			menu2dView.init()
			if(_memMode){
				menu2dView.mode = _memMode
				_memMode = null
			}
		}
		
		private function startHidingTimeline():void
		{
			if(menu2dView) menu2dView.hide()
		}
		
		private function lightHeader():void
		{
			if(menu2dView){
				menu2dView.highLightMoreProjects();
			}
		}		
		
		/****** COPYRIGHT - CREDITS BUTTON *****/
		
		private function mainLineTimelineYMovehandler(yMove:Number):void
		{
			_copyRight.updateY(yMove)
		}
		
		private function clickCopyHandler(event:MouseEvent):void
		{
			sendNotification(ApplicationFacade.OPEN_CREDITS)
		}
		
		private function rolloutCopyHandler(event:MouseEvent):void
		{
			sendNotification(COPYBUTTON_OUT)
		}
		
		private function rolloverCopyHandler(event:MouseEvent):void
		{
			sendNotification(COPYBUTTON_OVER)
		}
		
		
		/*************************/
		
		private function show():void
		{
			if(menu2dView) menu2dView.show()
		}
		
		private function hide():void
		{
			
		}
				
		private function buildHeader():void
		{
			if(!menu2dView){
				viewComponent = new Menu2DView(StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getPageChildren(PagesName.FOLIO));
				menu2dView.addEventListener(Menu2DView.CLICK_MENU_BUTTON, clickMenuButtonHandler);
				menu2dView.addEventListener(Menu2DView.CLICK_MENU_CLOSEBUTTON, clickMenuCloseButtonHandler);
				menu2dView.addEventListener(Menu2DView.ROLLOUT_TRI_BUTTON, rollOutTriHandler);
				menu2dView.addEventListener(Menu2DView.ROLLOVER_TRI_BUTTON, rollOverTriHandler);
				menu2dView.addEventListener(Menu2DView.CLICK_TRI_BUTTON, clickTriHandler);
				menu2dView.addEventListener(ContactShareEvent.OPEN_CONTACT_PANEL, openContactPanelHandler);
				menu2dView.addEventListener(ContactShareEvent.CLOSE_CONTACT_PANEL, closeContactPanelHandler);
				menu2dView.addEventListener(MenuHeader.OUT_HEADER, rollOutHeaderHandler)
				menu2dView.addEventListener(MenuHeader.OVER_HEADER, rollOverHeaderHandler)
				menu2dView.addEventListener(ContactShareEvent.CLOSE_CREDITS_PANEL, closeCreditsPanelHandler);
				menu2dView.addEventListener(ContactShareEvent.OPEN_CREDITS_PANEL, openCreditsPanelHandler);
			}

			if(!_container.contains(menu2dView)){
				_container.addChildAt(menu2dView,_container.getChildIndex(_copyRight))		
			}
		}		
		
		protected function openCreditsPanelHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.OPEN_CREDITS)
		}
		
		protected function closeCreditsPanelHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CLOSE_CREDITS);
		}
		
		protected function rollOverHeaderHandler(event:Event):void
		{
			sendNotification(Menu2DMediator.ROLLOVER_HEADER)
		}
		
		protected function rollOutHeaderHandler(event:Event):void
		{
			sendNotification(Menu2DMediator.ROLLOUT_HEADER)
		}
		
		protected function closeContactPanelHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CLOSE_CONTACT_PANEL);
		}
		
		protected function openContactPanelHandler(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.OPEN_CONTACT_PANEL, event.getString())
		}
		
		protected function clickTriHandler(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.MENU2D_CLICK_TRI, event.getString())
		}
		
		protected function rollOverTriHandler(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.MENU2D_OVER, event.getString())
		}
		
		protected function rollOutTriHandler(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.MENU2D_OUT, event.getString())
		}
		
		private function completeTransition(info:TransitionPageData = null):void
		{
			trace("RETURN END TRANSITION")
			
			if(!info || !info.nextPage) return
			
			if(!menu2dView) return
			if(menu2dView) menu2dView.updateState(info.nextPage)
			if(info.nextPage.environment == PagesName.REEL && info.nextPage.id != PagesName.INTRO && info.nextPage.id != PagesName.REEL ){				
				menu2dView.mode = Menu2DView.REEL_MODE
			}else if(info && info.previousPage && info.previousPage.environment == PagesName.REEL && info.nextPage.environment == PagesName.FOLIO){
				menu2dView.mode = Menu2DView.FOLIO_MODE
			}/*else{
				menu2dView.mode = Menu2DView.HIDDEN_MODE
				trace("hidden mode >> Header invisible")
			}*/
			// sinon le header est invisible en principe
		}
		
		
		
		private function startTransition(info:TransitionPageData = null):void
		{
			//
			var delay:Boolean = false
			if(info && info.previousPage){
				if(info.previousPage.environment == PagesName.REEL){
					delay = true					
				}
					
				if(info.previousPage.environment == PagesName.FOLIO && info.nextPage.environment == PagesName.REEL){
					if(menu2dView){
						menu2dView.mode = Menu2DView.REEL_MODE
						menu2dView.hideAndClose();
					}					
				}else{
					if(menu2dView){
						menu2dView.mode = Menu2DView.FOLIO_MODE
					}else{
						_memMode = Menu2DView.FOLIO_MODE
					}				
				}
			}else{
				if(menu2dView){
					menu2dView.mode = Menu2DView.FOLIO_MODE
				}else{
					_memMode = Menu2DView.FOLIO_MODE
				}
			}
			if(menu2dView) menu2dView.startTransition(info.nextPage);
		
		}
		
		protected function clickMenuCloseButtonHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CLOSE_TRIANGLE_MENU);
		}
		
		protected function clickMenuButtonHandler(event:StringEvent):void
		{
			var name:String = event.getString();
			var page:Page = StructureProxy.getPage(name)
			
			if(page.environment == PagesName.REEL){
				if(SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).currentEnvType == PagesName.REEL){
					menu2dView.mouseClickCloseHandler(null);
				}else{
					sendNotification(ApplicationFacade.CHANGE_PAGE, page);
				}
				return
			}
				
			if(page && !page.isFolder){
				// about // reel
				sendNotification(ApplicationFacade.CHANGE_PAGE, page);
			}else{
				// other categories
				sendNotification(ApplicationFacade.OPEN_TRIANGLE_MENU, name);
			}
		}
		
		private function get menu2dView():Menu2DView
		{
			return viewComponent as Menu2DView
		}
		
		
	}
}