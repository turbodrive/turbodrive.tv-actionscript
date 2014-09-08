package tv.turbodrive.puremvc
{
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import tv.turbodrive.puremvc.controller.ChangePageCommand;
	import tv.turbodrive.puremvc.controller.ClickVideoCommand;
	import tv.turbodrive.puremvc.controller.CloseTriangleMenuCommand;
	import tv.turbodrive.puremvc.controller.InitSwfAddressCommand;
	import tv.turbodrive.puremvc.controller.LoadAssetsCommand;
	import tv.turbodrive.puremvc.controller.OpenTriangleMenuCommand;
	import tv.turbodrive.puremvc.controller.PauseReelStreamCommand;
	import tv.turbodrive.puremvc.controller.ResumeProcessingCommand;
	import tv.turbodrive.puremvc.controller.ResumeReelStreamCommand;
	import tv.turbodrive.puremvc.controller.StartupCommand;
	import tv.turbodrive.puremvc.controller.SwitchModeCommand;
	import tv.turbodrive.puremvc.controller.TransitionCompleteCommand;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const STARTUP:String = "startup";
		public static const LOAD_ASSETS:String = "loadAssets";
		public static const BUILD_PLAYER:String = "buildPlayer";
		public static const BUILD_HEADER:String = "buildHeader";
		public static const CHANGE_PAGE:String = "changePage";
		public static const SWITCH_MODE:String = "switchMode";
		public static const CLICK_VIDEO:String = "clickVideo";
		
		public static const PAUSE_REEL_STREAM:String = "pauseReelStream";
		public static const RESUME_REEL_STREAM:String = "resumeReelStream";
		public static const RESUME_SWITCH_PROCESSING:String = "resumeSwitchProcessing";
		public static const TRANSITION_COMPLETE:String = "transitionComplete";
		public static const TRANSITION_STARTS:String = "transitionStarts"
		public static const OPEN_TRIANGLE_MENU:String = "openTriangleMenu";
		public static const CLOSE_TRIANGLE_MENU:String = "closeTriangleMenu";
		
		public static const INIT_SWFADDRESS:String = "initSwfAddress";
		
		public static const MENU3D_MOVE:String = "menu3dMove";
		public static const MENU2D_OVER:String = "menu2dOver";
		public static const MENU2D_OUT:String = "menu2dOut"
		public static const MENU2D_CLICK_TRI:String = "menu2dClickTri";
		public static const OPEN_CONTACT_PANEL:String = "openContactPanel";
		public static const CLOSE_CONTACT_PANEL:String = "closeContactPanel";
		public static const OPEN_CREDITS:String = "openCredits";
		public static const CLOSE_CREDITS:String = "closenCredits";
		public static const NAVIGATE_TO_SUBPAGE:String = "navigateToSubPage";
		
		
		public function ApplicationFacade() 
		{
			super();			
		}
		
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController()
			registerCommand(STARTUP, StartupCommand)
			registerCommand(LOAD_ASSETS, LoadAssetsCommand)
			registerCommand(CHANGE_PAGE, ChangePageCommand)
			registerCommand(SWITCH_MODE, SwitchModeCommand)
			registerCommand(CLICK_VIDEO, ClickVideoCommand)
			registerCommand(PAUSE_REEL_STREAM, PauseReelStreamCommand)
			registerCommand(RESUME_REEL_STREAM, ResumeReelStreamCommand)
			registerCommand(RESUME_SWITCH_PROCESSING, ResumeProcessingCommand)
			registerCommand(TRANSITION_COMPLETE, TransitionCompleteCommand)
			registerCommand(OPEN_TRIANGLE_MENU, OpenTriangleMenuCommand)
			registerCommand(CLOSE_TRIANGLE_MENU, CloseTriangleMenuCommand)
			registerCommand(INIT_SWFADDRESS, InitSwfAddressCommand)
		}		
		
		public function startup(o:Object):void {
			sendNotification(STARTUP,o)
		}
	}
}