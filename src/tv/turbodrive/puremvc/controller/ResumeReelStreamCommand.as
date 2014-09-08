package tv.turbodrive.puremvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import tv.turbodrive.loader.ReelVideoPlayer;
	
	public class ResumeReelStreamCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			ReelVideoPlayer.instance.resume(false);
		}
	}
}