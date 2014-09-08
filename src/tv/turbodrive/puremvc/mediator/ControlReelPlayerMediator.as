package tv.turbodrive.puremvc.mediator
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.FooterCtrlVideoView;
	import tv.turbodrive.puremvc.mediator.view.component.RedTimeline;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class ControlReelPlayerMediator extends Mediator implements IMediator
	{
		static public const NAME:String = "ControlReelPlayerMediator";
		static public const SHOW_TIMELINE:String = NAME+"ShowTimeline";
		static public const HIDE_TIMELINE:String = NAME+"HideTimeline";
		static public const START_HIDING_TIMELINE:String = NAME+"StartHidingTimeline";
		static public const MAINTIMELINE_YMOVE:String = NAME+"MainTimelineYmove";
				
		private var _parentContainer:Sprite;
		
		
		public function ControlReelPlayerMediator(viewComponent:Sprite=null)
		{
			_parentContainer = viewComponent
			super(NAME, new FooterCtrlVideoView());	
		}
		
		override public function onRegister():void
		{			
			footerCtrlVideoView.createMenu(StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getPageChildren(PagesName.REEL));			
			
			// une fois le footer créé, on le met à jour (mais pas dans le cas où la page n'est pas dispo : pré-intro par exemple)	
			var currentPage:Page = SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).getCurrentPage()
			if(currentPage){
				footerCtrlVideoView.updateMenuState(currentPage);
				checkAddHUD(currentPage);
			}			
		}
		
		override public function listNotificationInterests():Array
		{
			return [Stage3DMediator.OPEN_TRIANGLE_MENU, Stage3DMediator.CLOSE_TRIANGLE_MENU, SwitchPageProxy.START_SWITCH, SwitchPageProxy.END_SWITCH,
				SwitchPageProxy.LIGHT_TIMELINE, Menu2DMediator.COPYBUTTON_OUT, Menu2DMediator.COPYBUTTON_OVER]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){				
				case SwitchPageProxy.START_SWITCH :
					checkRemoveHUD(notification.getBody() as TransitionPageData)
					break;
				case SwitchPageProxy.END_SWITCH :
					checkAddHUD(TransitionPageData(notification.getBody()).nextPage)
					break;
				case SwitchPageProxy.LIGHT_TIMELINE :
					addFooter(true, notification.getBody());					
					break;
				case Stage3DMediator.OPEN_TRIANGLE_MENU :
					openTriangleMenu()
					break;
				case Stage3DMediator.CLOSE_TRIANGLE_MENU :
					closeTriangleMenu();
					break;
				case Menu2DMediator.COPYBUTTON_OUT :
					copyrightRollOut();
					break;
				case Menu2DMediator.COPYBUTTON_OVER :
					copyrightRollOver();
					break;
			}
		}	
		
		private function copyrightRollOver():void
		{
			if(_parentContainer.contains(footerCtrlVideoView) && footerCtrlVideoView._openPlayer) footerCtrlVideoView.rollOverHandler();
		}
		
		private function copyrightRollOut():void
		{
			if(_parentContainer.contains(footerCtrlVideoView) && footerCtrlVideoView._openPlayer) footerCtrlVideoView.rollOutHandler();
		}
		
		private function closeTriangleMenu():void
		{
			footerCtrlVideoView.visible = true
		}
		
		private function openTriangleMenu():void
		{
			footerCtrlVideoView.visible = false
		}
		
		private function checkAddHUD(page:Page):void {			
			if(page.environment == PagesName.REEL && page.id != PagesName.INTRO && page.id != PagesName.REEL ) addFooter();						
			footerCtrlVideoView.updateMenuState(page);			
		}
		
		private function checkRemoveHUD(info:TransitionPageData):void {			
			if(info.nextPage.name == PagesName.INTRO){
				footerCtrlVideoView.firstTime = true
			}
			
			if(!info.previousPage) return			
			if(info.nextPage.environment == PagesName.FOLIO && info.previousPage.environment == PagesName.REEL){
				removeFooter();
			}			
		}		
		
		public function removeFooter():void {
			footerCtrlVideoView.hide()
			footerCtrlVideoView.removeEventListener(PageEvent.CHANGE_PAGE, changePageHandler);
			footerCtrlVideoView.removeEventListener(FooterCtrlVideoView.ON_OPEN, onOpenFooterHandler);
			footerCtrlVideoView.removeEventListener(FooterCtrlVideoView.ON_CLOSE, onCloseFooterHandler);
			if(_parentContainer.contains(footerCtrlVideoView))_parentContainer.removeChild(footerCtrlVideoView);
		}
		
		private function onCloseFooterHandler(e:Event):void
		{
			sendNotification(HIDE_TIMELINE);
		}
		
		private function onOpenFooterHandler(e:Event):void
		{
			sendNotification(SHOW_TIMELINE);
		}	

		
		private function addFooter(lightIfHere:Boolean = false, invisibleButtons:Boolean = false):void
		{
			if(!_parentContainer.contains(footerCtrlVideoView)){
				_parentContainer.addChild(footerCtrlVideoView);
				footerCtrlVideoView.addEventListener(PageEvent.CHANGE_PAGE, changePageHandler);
				footerCtrlVideoView.addEventListener(FooterCtrlVideoView.ON_OPEN, onOpenFooterHandler);
				footerCtrlVideoView.addEventListener(FooterCtrlVideoView.ON_CLOSE, onCloseFooterHandler);
				footerCtrlVideoView.addEventListener(FooterCtrlVideoView.ON_START_CLOSING, onStartClosingHandler);
				footerCtrlVideoView.addEventListener(RedTimeline.MAINLINE_YMOVE, mainLineTimelineYMovehandler)
			}
			if(lightIfHere){
				footerCtrlVideoView.openAndClose(invisibleButtons);
			}
		}	
		
		protected function mainLineTimelineYMovehandler(event:NumberEvent):void
		{
			sendNotification(MAINTIMELINE_YMOVE, event.getNumber())
		}
		
		protected function onStartClosingHandler(event:Event):void
		{
			sendNotification(START_HIDING_TIMELINE);
		}		
		
		protected function changePageHandler(event:PageEvent):void
		{
			setTimeout(footerCtrlVideoView.rollOutHandler,1500,null);
			sendNotification(ApplicationFacade.CHANGE_PAGE,event.page);
		}
		
		private function  get footerCtrlVideoView():FooterCtrlVideoView
		{
			return viewComponent as FooterCtrlVideoView
		}			
	}
}