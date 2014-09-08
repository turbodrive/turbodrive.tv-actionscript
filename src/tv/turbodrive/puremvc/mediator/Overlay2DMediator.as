package tv.turbodrive.puremvc.mediator
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.away3d.elements.entities.GroupTps3D;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.BttrView;
	import tv.turbodrive.puremvc.mediator.view.FilterView;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.BackButtonsView;
	import tv.turbodrive.puremvc.mediator.view.component.CreditsView;
	import tv.turbodrive.puremvc.mediator.view.component.NextPrevNavigationView;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class Overlay2DMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "Overlay2DMediator";
		public static const UPDATE_CONTENT_POSITION:String = NAME + "updateContentPosition";
		public static const OPEN_SUBPAGE:String = NAME + "openSubPage";
		public static const CLOSE_SUBPAGE:String = NAME + "closeSubPage";		
		
		private var _playingTransition:Boolean = false;		
		private var _parent:Sprite;
		
		private var _depthOrder:Array = [Overlay2DView, NextPrevNavigationView, BttrView, BackButtonsView, FilterView]
		private var _dictionnaryDepth:Dictionary = new Dictionary();
			
		private var _nextPrevNavigation:NextPrevNavigationView;
		private var _buttonBack:BttrView;
		private var _filter:FilterView;
		private var openPanels:Object = {}
		
		private var overlayHidden:Boolean = false;

		private var _bmp:Bitmap;
		
		
		public function Overlay2DMediator(parent:Sprite){
			_parent = parent
			_parent.addEventListener(Event.ADDED, addComponentOnStage)
			super(NAME, new Overlay2DView());
		}
		
		private function getTargetDepth(component:DisplayObject):int
		{
			for(var i:int = 0; i<_depthOrder.length; i++ ){				
				if(component is _depthOrder[i]){
					return i
				}
			}
			return -1
		}
		
		protected function addComponentOnStage(event:Event):void
		{		
			var comp:DisplayObject = DisplayObject(event.target)
			if(comp.parent != _parent) return
							
			var depthTarget:int = getTargetDepth(comp)
			
			for(var i:int = 0; i<_parent.numChildren; i++){
				var child:DisplayObject = _parent.getChildAt(i)
				if(child != comp){
					var tDepthChild:int = getTargetDepth(child)
					if(tDepthChild > depthTarget){
						_parent.setChildIndex(comp, i)
						return						
					}
				}
			}			
		}		
		
		override public function onRegister():void
		{
			_filter = new FilterView();
			_filter.addEventListener(MouseEvent.CLICK, clickFilterHandler)
			openPanels.contact = openPanels.credits	= false
			
			
		}
		
		override public function listNotificationInterests():Array
		{			
			return [Overlay2DMediator.CLOSE_SUBPAGE, Overlay2DMediator.OPEN_SUBPAGE, Overlay2DMediator.UPDATE_CONTENT_POSITION, Menu2DMediator.OPEN_TRIANGLE_MENU,
				ApplicationFacade.OPEN_CONTACT_PANEL, Menu2DMediator.CLOSE_TRIANGLE_MENU, ApplicationFacade.CLOSE_CONTACT_PANEL, ApplicationFacade.OPEN_CREDITS, ApplicationFacade.CLOSE_CREDITS,
				SwitchPageProxy.END_SWITCH,SwitchPageProxy.START_SWITCH]
		}		
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case Overlay2DMediator.OPEN_SUBPAGE:
					openSubPage(notification.getBody() as GroupTps3D)
					break;
				case Overlay2DMediator.CLOSE_SUBPAGE:
					//closeProject()
					break;				
				case Overlay2DMediator.UPDATE_CONTENT_POSITION:
					/*if(!_playingTransition) */overlay.updateTitlePosition(notification.getBody() as GroupTps3D)
					break;
				case Menu2DMediator.OPEN_TRIANGLE_MENU :
					showFilter("triangleMenu");
					hideNextPrev()
					hideBttr();
					hideOverlay()
					hideFilter();
					break;
				case ApplicationFacade.OPEN_CONTACT_PANEL:					
					showFilter("contact");
					break;
				case Menu2DMediator.CLOSE_TRIANGLE_MENU :
					hideFilter("triangleMenu");
					showBttr();
					showOverlay()
					hideFilter();
					showNextPrev()
					break;
				case ApplicationFacade.CLOSE_CONTACT_PANEL:
					hideFilter("contact");
					break;
				case ApplicationFacade.OPEN_CREDITS:
					translateView(-CreditsView.HEIGHT_OPEN)
					showFilter("credits");
					break;
				case ApplicationFacade.CLOSE_CREDITS:
					translateView(0)					
					hideFilter("credits");
					break;				
				case SwitchPageProxy.END_SWITCH :
					completeTransition(notification.getBody() as TransitionPageData);
					break;
				case SwitchPageProxy.START_SWITCH:
					startTransition(notification.getBody() as TransitionPageData);		
					break;					
			}
		}
		
		private function showNextPrev():void
		{
			if(_nextPrevNavigation && !_parent.contains(_nextPrevNavigation)){
				_parent.addChild(_nextPrevNavigation)
			}
			/*if(!_bmp){
				_bmp = new Bitmap(new OverlayMenu());
				_bmp.alpha = 0.3
				_parent.addChild(_bmp)
				_bmp.width = _parent.stage.stageWidth
				_bmp.height = _parent.stage.stageHeight
				
			}*/
		}
		
		private function hideNextPrev():void
		{
			if(_nextPrevNavigation && _parent.contains(_nextPrevNavigation)){
				_parent.removeChild(_nextPrevNavigation)
			}
		}
		
		private function showOverlay():void
		{
			if(!overlayHidden) return
			overlayHidden  = false
			TweenMax.to(overlay, 0.3, {autoAlpha : 1})
		}
		
		private function hideOverlay():void
		{
			overlayHidden = true
			TweenMax.to(overlay, 0.3, {autoAlpha : 0});
		}
		
		/****** PANELS ******/
		
		private function translateView(yTarget:int):void
		{
			var duration:Number = 0.5 //yTarget == 0 ? 0.4 : 0.4			
			TweenMax.to(_parent, duration,{y:yTarget, ease:Quart.easeOut})
		}	
		
		
		/****** FILTER ******/
		
		protected function clickFilterHandler(event:MouseEvent):void
		{
			sendNotification(ApplicationFacade.CLOSE_CREDITS)
			sendNotification(ApplicationFacade.CLOSE_CONTACT_PANEL)
		}
		
		private function hideFilter(panel:String = null):void
		{
			if(!panel){
				openPanels.contact = openPanels.credits = false
			}else{
				openPanels[panel] = false
			}			
			
			if(!openPanels.contact && !openPanels.credits){
				_filter.hideAndRemove()
				if(!openPanels.triangleMenu) overlay.resumeContent()
			}
		}
		
		private function showFilter(panel:String):void
		{
			openPanels[panel] = true
			if(panel!= "triangleMenu") _parent.addChild(_filter)
			overlay.pauseContent()
		}
		
		/****** START / COMPLETE TRANSITIONS ******/
		
		private function startTransition(info:TransitionPageData = null):void
		{
			_playingTransition = true
			if(info.previousPage && (info.previousPage.id != info.nextPage.id || info.previousPage.category != info.nextPage.category)){
				closeProject()			
			}
			
			if(info.previousPage && info.nextPage.category != PagesName.SELECTED_CASES && info.previousPage.category == PagesName.SELECTED_CASES){
				removeBttrButton();
			}	
			
			
			if(_nextPrevNavigation) TweenMax.to(_nextPrevNavigation, 0.3, {autoAlpha:0})
		}
		
		private function completeTransition(info:TransitionPageData = null):void
		{	
			_playingTransition = false
			
			if(info.nextPage.category == PagesName.SELECTED_CASES){
				if(!_buttonBack){
					_buttonBack = new BttrView();
					_buttonBack.addEventListener(MouseEvent.CLICK,clickBttr);
				}
				if(!_parent.contains(_buttonBack)){
					_parent.addChild(_buttonBack);
					_buttonBack.gotoAndPlay(2);
				}
			}
			
			if(!_nextPrevNavigation){
				_nextPrevNavigation = new NextPrevNavigationView()				
				_nextPrevNavigation.addEventListener(NextPrevNavigationView.ON_BUTTON_CLICK, nextPrevButtonClickHandler)
			}else{
				TweenMax.to(_nextPrevNavigation, 0.2, {autoAlpha:1})
			}
			if(!_parent.contains(_nextPrevNavigation)){
				_parent.addChild(_nextPrevNavigation)
			}
			_nextPrevNavigation.updateState(info.nextPage);
		}
		
		/****** NEXT - PREV *****/
		protected function nextPrevButtonClickHandler(event:PageEvent):void
		{
			sendNotification(ApplicationFacade.CHANGE_PAGE, event.page);
		}
		
		/****** BTTR ******/
		
		private function showBttr():void
		{
			if(_buttonBack) TweenMax.to(_buttonBack,0.5, {autoAlpha:1})
		}
		
		private function hideBttr():void
		{
			if(_buttonBack) TweenMax.to(_buttonBack,0.5, {autoAlpha:0})
		}
		
		private function removeBttrButton():void
		{
			if(_buttonBack){
				/*if(_parent.contains(_buttonBack)){
					_parent.removeChild(_buttonBack)
				}*/
				_buttonBack.gotoAndStop(_buttonBack.totalFrames)
				if(_parent.contains(_buttonBack))TweenMax.to(_buttonBack,0.4,{frame:1, ease:Linear, onComplete:_parent.removeChild, onCompleteParams:[_buttonBack]})
				
				_buttonBack.removeEventListener(MouseEvent.CLICK, clickBttr)
				_buttonBack = null
			}
		}
		
		protected function clickBttr(event:MouseEvent):void
		{
			sendNotification(ApplicationFacade.SWITCH_MODE)
		}
		
		/****** OVERLAY CONTENT ******/
		
		private function openSubPage(gtps3d:GroupTps3D):void
		{
		
			if(!_parent.contains(overlay)) _parent.addChild(overlay)
			overlay.addEventListener(Overlay2DView.NAVIGATE_TO_SUBPAGE, clickNavigateToSubPage)
			overlay.openSubPage(gtps3d);
		}		
		
		private function closeProject():void
		{
			overlay.closeSubPage();
			overlay.removeEventListener(Overlay2DView.NAVIGATE_TO_SUBPAGE, clickNavigateToSubPage)
		}
		
		protected function clickNavigateToSubPage(event:StringEvent):void
		{
			sendNotification(ApplicationFacade.NAVIGATE_TO_SUBPAGE, event.getString());
		}
		
		/*private function destroyOverlay():void
		{
			overlay.destroy();			
			if(_parent.contains(overlay))_parent.removeChild(overlay);
		}*/
				
		private function get overlay():Overlay2DView
		{
			return viewComponent as Overlay2DView		
		}
	}
}