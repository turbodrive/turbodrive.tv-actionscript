package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class TransitionCompleteCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			trace("TransitionCompleteCommand >> " + TransitionCompleteCommand);
			
			var trs:TransitionPageData = notification.getBody() as TransitionPageData
			if(!trs.previousPage || (trs.nextPage.name != trs.previousPage.name || trs.nextPage.environment != trs.previousPage.environment)){			
				SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).currentTransitionComplete(trs.nextPage)
			}
		}
	}
}