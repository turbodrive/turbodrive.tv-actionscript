package tv.turbodrive.puremvc.controller
{
	import com.asual.swfaddress.SWFAddress;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;

	public class ChangePageCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{	
			// Start to close the menu BEFORE change page (in case of little delay).
			var page:Page
			if(notification.getBody() is Page){
				page = notification.getBody() as Page
			}else{
				page = StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getRealPage(notification.getBody() as  String);
			}
			sendNotification(ApplicationFacade.CLOSE_TRIANGLE_MENU, page)			
			
			var pageAddress:String = StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getCompleteAddress(notification.getBody())
			SWFAddress.setValue(pageAddress)			
		}
	}
}