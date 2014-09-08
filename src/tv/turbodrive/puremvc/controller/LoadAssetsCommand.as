package tv.turbodrive.puremvc.controller
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.loader.AssetsManager;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.mediator.Stage3DMediator;
	import tv.turbodrive.puremvc.mediator.StageMediator;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.Styles;
	
	public class LoadAssetsCommand extends SimpleCommand implements ICommand
	{
		static public const NAME:String = "LoadAssetsCommand"
		
		override public function execute(notification:INotification):void
		{
			// first time call of Assets Manager >> Instanciation
			if(AssetsManager.instance.requiredAssetsComplete){
				AssetsManager.instance.addEventListener(Event.COMPLETE, pageCompleteHandler)
			}else{
				Preloader.track("_mainLoad/start");
				AssetsManager.instance.addEventListener(Event.COMPLETE, firstCompleteHander)
			}
			// start load			
			AssetsManager.instance.load(notification.getBody() as Page)
		}
		
		protected function pageCompleteHandler(event:PageEvent):void
		{		
			AssetsManager.instance.removeEventListener(Event.COMPLETE, pageCompleteHandler)				
			sendNotification(ApplicationFacade.RESUME_SWITCH_PROCESSING, NAME);
		}
		
		protected function firstCompleteHander(event:PageEvent):void
		{
			Preloader.track("_mainLoad/complete");
			AssetsManager.instance.removeEventListener(Event.COMPLETE, firstCompleteHander)
			Styles.init()
			sendNotification(ApplicationFacade.BUILD_PLAYER);
			sendNotification(Stage3DMediator.REQUIRED_ASSETS_COMPLETE);
			sendNotification(ApplicationFacade.RESUME_SWITCH_PROCESSING, NAME);
		}
	}
}