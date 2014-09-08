package tv.turbodrive.puremvc.controller
{
	
	import com.asual.swfaddress.SWFAddress;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	
	public class ClickVideoCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			// récupération de l'état de la vidéo au moment où on click dessus
			var transitionProxy:SwitchPageProxy = facade.retrieveProxy(SwitchPageProxy.NAME) as SwitchPageProxy
			var currentPage:Page =  transitionProxy.getCurrentPage()
			var newPageId:String
			
			Preloader.track("_ClickVideo/"+currentPage.id);
			
			if(currentPage.id == PagesName.REEL){
				newPageId = PagesName.INTRO
			}else if(currentPage.id == PagesName.INTRO){
				newPageId = PagesName.REEL_TOT
			}else{
				sendNotification(ApplicationFacade.SWITCH_MODE);
				return
			}		
			
			var sProxy:StructureProxy = StructureProxy(facade.retrieveProxy(StructureProxy.NAME));
			var newPageAddress:String = sProxy.getCompleteAddress(StructureProxy.getPage(newPageId));
			
			SWFAddress.setValue(newPageAddress)				
			
		}
	}
}