package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.proxy.SWFAddressReceiverProxy;
	
	public class InitSwfAddressCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new SWFAddressReceiverProxy(notification.getBody()))
		}
	}
}