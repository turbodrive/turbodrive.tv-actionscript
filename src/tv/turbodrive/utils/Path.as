package tv.turbodrive.utils
{
	

	public class Path
	{
		static public var CSS_FILE:String = "css/flash.css"
		static public var XML_FILE:String = "xml/content.xml";
		static public var VIDEO_REEL:String = ""
		static public const VIDEO_REEL_SERVER_ROOT:String = "http://vod.infomaniak.com/"
		static public const VIDEO_REEL_SERVER_EXTEND:String = VIDEO_REEL_SERVER_ROOT+"redirect/silvremarchal_1_vod/"
		//static public const VIDEO_REEL_SERVER:String = VIDEO_REEL_SERVER_ROOT+"redirect/silvremarchal_vod/teaser-6315/mp4-610/mainediting_001.mp4"
		//static public const VIDEO_REEL_SERVER:String = VIDEO_REEL_SERVER_ROOT+"redirect/silvremarchal_vod/teaser-6315/mp4-609/mainediting_006_hq.mp4"
		//static public const VIDEO_REEL_SERVER:String = VIDEO_REEL_SERVER_ROOT+"redirect/silvremarchal_vod/raw-6980/mp4-32/mainediting_007b_vhsscratch_1.mp4"
		//static public const VIDEO_REEL_SERVER_HD_27:String = VIDEO_REEL_SERVER_ROOT+"raw-12978/mp4-32/mainediting_007b_vhsscratch_1.mp4"
		static public const VIDEO_REEL_SERVER_HD_20:String = VIDEO_REEL_SERVER_EXTEND+"raw-12978/mp4-32/mainediting_008_vhsscratch.mp4"
		//static public const VIDEO_REEL_SERVER_HD_21:String = VIDEO_REEL_SERVER_ROOT+"infomaniak_encoding-12980/mp4-226/mainediting_008_vhsscratch_prepinfomaniak.mp4"
		static public const VIDEO_REEL_SERVER_HQ_09:String = VIDEO_REEL_SERVER_EXTEND+"infomaniak_encoding-12980/mp4-12/mainediting_008_vhsscratch_prepinfomaniak.mp4"
		static public const VIDEO_REEL_SERVER_IPHONE_04:String = VIDEO_REEL_SERVER_EXTEND+"infomaniak_encoding-12980/mp4-323/mainediting_008_vhsscratch_prepinfomaniak.mp4"
		static public const VIDEO_REEL_SERVER_IPHONE_03:String = VIDEO_REEL_SERVER_EXTEND+"infomaniak_encoding-12980/mp4-322/mainediting_008_vhsscratch_prepinfomaniak.mp4"
		//static public const VIDEO_QUALITIES:Array = [VIDEO_REEL_SERVER_HD_20,VIDEO_REEL_SERVER_HQ_09,VIDEO_REEL_SERVER_IPHONE_04,VIDEO_REEL_SERVER_IPHONE_03];
		static public const VIDEO_QUALITIES:Array = [VIDEO_REEL_SERVER_HD_20,VIDEO_REEL_SERVER_HQ_09,VIDEO_REEL_SERVER_IPHONE_04,VIDEO_REEL_SERVER_IPHONE_03];
		static public const VIDEO_RATES:Array = ["HD 2M","HQ 0.9M","SD 0.4M","LD 0.3M"];
			
		static public const VIDEO_REEL_RELATIVE:String = "videos/mainediting_007.mp4"
			
		static public const ATF_DIRECTORY:String = "assets/atf/"		
		public static var FONTS_FILE:String = "assets/swf/fonts.swf";
		//public static var JPEG_DIRECTORY:String = "assets/jpg/";
		//public static var HEXA_MENU:String = "assets/awd/hexaMenuGrid.awd";
		//public static var TRANSITION_BLOCS:String = "assets/awd/transitionBlocs.awd";
		
		public static var ONLINE_DIRECTORY:String = "http://www.turbodrive.tv/"; 
		public static var ASSETS_DIR:String = "assets/"
		public static const MAIL_SENDER:String = "http://www.turbodrive.tv/php/sendMail.php"		
		public static var VIDEO_DIR:String = "assets/videos/";
		
		public function Path()
		{		
			
		}
		
		public static function update():void
		{
			VIDEO_REEL = Config.SEEK_SERVER ? VIDEO_REEL_SERVER_HD_20 : VIDEO_REEL_RELATIVE
			//VIDEO_REEL =  VIDEO_REEL_RELATIVE
			if(!Config.IS_ONLINE && Config.USE_ONLINEASSETS){
				CSS_FILE = ONLINE_DIRECTORY+CSS_FILE
				XML_FILE = ONLINE_DIRECTORY+XML_FILE
				FONTS_FILE = ONLINE_DIRECTORY+FONTS_FILE
				ASSETS_DIR = ONLINE_DIRECTORY+ASSETS_DIR
			}
		}
	}
}