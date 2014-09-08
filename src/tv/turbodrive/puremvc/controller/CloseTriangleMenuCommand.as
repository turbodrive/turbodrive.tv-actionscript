package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.puremvc.mediator.Stage3DMediator;
	import tv.turbodrive.puremvc.mediator.Menu2DMediator;
	
	public class CloseTriangleMenuCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(Stage3DMediator.CLOSE_TRIANGLE_MENU, notification.getBody());		
			sendNotification(Menu2DMediator.CLOSE_TRIANGLE_MENU, notification.getBody());		
		}
	}
}