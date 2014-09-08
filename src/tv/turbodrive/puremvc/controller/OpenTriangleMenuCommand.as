package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.puremvc.mediator.Menu2DMediator;
	import tv.turbodrive.puremvc.mediator.Stage3DMediator;
	
	public class OpenTriangleMenuCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			Preloader.track("_OpenTriangleMenu");
			sendNotification(Stage3DMediator.OPEN_TRIANGLE_MENU, notification.getBody());
			sendNotification(Menu2DMediator.OPEN_TRIANGLE_MENU, notification.getBody());		
		}
	}
}