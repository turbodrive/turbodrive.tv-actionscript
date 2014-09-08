package tv.turbodrive.puremvc.mediator
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.away3d.elements.PageAbout;
	import tv.turbodrive.away3d.elements.entities.AbstractProjectGp3D;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.view.component.BackButtonsView;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class BackButtonsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BackButtonsMediator"
		public static const CLICK_BACK:String = NAME + "clickBack";
			
		private var _parent:DisplayObjectContainer;		
		
		public function BackButtonsMediator(parent)
		{
			_parent = parent			
			super(NAME, new BackButtonsView());
		}
		
		override public function listNotificationInterests():Array
		{			
			return [ApplicationFacade.TRANSITION_COMPLETE, ApplicationFacade.TRANSITION_STARTS]
		}		
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.TRANSITION_STARTS:
					startTransition(notification.getBody() as TransitionPageData);		
					break;
				case ApplicationFacade.TRANSITION_COMPLETE:
					completeTransition(notification.getBody() as TransitionPageData);		
					break;
				case ApplicationFacade.TRANSITION_COMPLETE:
					completeTransition(notification.getBody() as TransitionPageData);		
					break;
				
			}
		}
		
		private function completeTransition(info:TransitionPageData):void
		{
			//trace("#####  " + NAME  + " - completeTransition " + info.transitionName +" --  " + info.internalSubTransition)
			if(info.internalSubTransition){
				if(!_parent.contains(backButtonsView)){
					_parent.addChild(backButtonsView)
					backButtonsView.addEventListener(BackButtonsView.CLICK, clickBackHandler)
				}
				if(info.internalSubTransition == SubTransitionNames.EXTRACONTENT){					
					backButtonsView.showButtonBack(BackButtonsView.EXTRA_PROJECT)
				}
				/*if(info.internalSubTransition == SubTransitionNames.VIDEOPLAYER){					
					backButtonsView.showButtonBack(BackButtonsView.EXTRA_PROJECT)
				}*/
				if(info.internalSubTransition == SubTransitionNames.ABOUTSKILLS){					
					backButtonsView.showButtonBack(BackButtonsView.SKILLS_ABOUT, BackButtonsView.LEFT)
				}
				if(info.internalSubTransition == SubTransitionNames.ABOUTTIMELINE){					
					backButtonsView.showButtonBack(BackButtonsView.TIMELINE_ABOUT)
				}
			}
		}
		
		protected function clickBackHandler(event:Event):void
		{
			sendNotification(BackButtonsMediator.CLICK_BACK)
		}
		
		private function startTransition(info:TransitionPageData):void
		{
			//trace("#####  " + NAME  + " - start transtion " + info.internalSubTransition)
			/*if(info.internalSubPage){
				if(info.internalSubPage == ProjectGp3D.INTERNAL_HOMEFROMEXTRA || info.internalSubPage == ProjectGp3D.INTERNAL_HOMEFROMEXTRA){
					backButtonsView.removeButtonBack();
				}
			}else{*/
				backButtonsView.removeButtonBack();
			//}
		}
		
		private function get backButtonsView():BackButtonsView
		{
			return viewComponent as BackButtonsView
		}
	}
}