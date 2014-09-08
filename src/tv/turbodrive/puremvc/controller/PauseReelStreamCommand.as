package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.loader.ReelVideoPlayer;

	
	public class PauseReelStreamCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//ReelPlayerProxy(facade.retrieveProxy(ReelPlayerProxy.NAME)).pause();
			ReelVideoPlayer.instance.pause();
		}
	}
}