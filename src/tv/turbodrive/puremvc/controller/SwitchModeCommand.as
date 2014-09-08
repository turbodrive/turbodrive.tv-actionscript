package tv.turbodrive.puremvc.controller
{
	import com.asual.swfaddress.SWFAddress;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	
	public class SwitchModeCommand extends SimpleCommand implements ICommand
	{

		override public function execute(notification:INotification):void
		{
			var currentPage:Page = SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).getCurrentPage() as Page
			var newPageId:String
			var tProxy:SwitchPageProxy = SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME));
			
			if(currentPage.environment == PagesName.FOLIO){
				// go to Reel
				newPageId = PagesName.REEL_PROJECTS_PREFIX+currentPage.id
			}else if(currentPage.environment == PagesName.REEL){
				// go to porfolio
				newPageId = currentPage.id.slice(PagesName.REEL_PROJECTS_PREFIX.length);
				
				// on mémorise également la page courante, car c'est celle que l'on va relancer si l'on revient depuis le folio depuis une page sans équivalent.
				tProxy.lastChapter = currentPage
			}
			
			var sProxy:StructureProxy = StructureProxy(facade.retrieveProxy(StructureProxy.NAME));
			var newPageAddress:String
			
			if(StructureProxy.getPage(newPageId)){
				newPageAddress = sProxy.getCompleteAddress(StructureProxy.getPage(newPageId));
			}else{
				if(tProxy.lastChapter){
					newPageAddress = sProxy.getCompleteAddress(tProxy.lastChapter)
				}else{
					newPageAddress = sProxy.getCompleteAddress(StructureProxy.getPage(PagesName.INTRO));
				}
			}
			
			
				
			SWFAddress.setValue(newPageAddress)
		}
	}
}