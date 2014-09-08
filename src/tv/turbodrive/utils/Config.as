package tv.turbodrive.utils
{
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	public class Config
	{
		public static var USE_WORKER:Boolean = true
		public static var IS_STANDALONE:Boolean = false
		public static var IS_ONLINE:Boolean = false
		public static var SEEK_SERVER:Boolean = false
		public static var IS_PLAYER_DEBUGGER:Boolean = false
		public static var USE_ONLINEVIDEO:Boolean = false
		public static var USE_FALLBACK_VIDEO:Boolean = true
		public static var USE_ONLINEASSETS:Boolean = false
		public static var GLOBAL_VOLUME:Number = 1
		public static var OFFLINE_VOLUME:Number = 0
		
		public function Config()
		{
		}
		
		public static function init(root:Sprite):void
		{
			IS_ONLINE = (root.loaderInfo.url.search("http") > -1)
			IS_STANDALONE = Capabilities.playerType == "StandAlone"
			
			IS_PLAYER_DEBUGGER = Capabilities.isDebugger
			
			Security.loadPolicyFile(Path.VIDEO_REEL_SERVER_ROOT + "crossdomain.xml")
			Security.loadPolicyFile("http://str07.infomaniak.ch/crossdomain.xml")
			Security.loadPolicyFile("http://static.infomaniak.ch/crossdomain.xml")
				
			if(IS_ONLINE || USE_ONLINEVIDEO){				
				SEEK_SERVER = true				
			}
			
			if(USE_ONLINEASSETS){
				Security.loadPolicyFile("http://www.turbodrive.tv/crossdomain.xml")
			}
			
			GLOBAL_VOLUME = IS_ONLINE ? 1 : OFFLINE_VOLUME
		}
	}
}