package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	
	public class ResumeProcessingCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).resumeProcessing(notification.getBody() as String);
		}
	}
}