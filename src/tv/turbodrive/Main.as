package tv.turbodrive
{
	import com.google.analytics.AnalyticsTracker;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import tv.turbodrive.loader.BridgeLoaderEvent;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.utils.Config;
	import tv.turbodrive.utils.Path;

	[SWF(width='1920', height='973', backgroundColor='#000000', frameRate='25')]
	
	public class Main extends Sprite
	{	
		private static var _txt:TextField
		
		public var _tracker:AnalyticsTracker
		private var keys:Array = ["5fOeN1E",	"D8I16",	"89yF6Dk",	"78KA1X","14epsnJ",	"33csDb",	"edrFLD",	"CKGHm4",	"MC54zg6",	"RSnqi0A",	"p08fJGCe",		"33oDJbC",		"YVMEGI",		"sUglZh",	"ZwQgEZh",		"HPwBbuH",		"LWjkLKq",	"XzkYaz",	"ioM1mUp",	"CEq6s9A",	"zdKCJ5g",	"0zdKCJ5g",		"e1d2ujg",	"90S762",	"NURHP",	"NEbQOfk",	"2JsmLK","74TkgU" ]
		
		private var _key:String;
		public static var INSTANCE:Sprite
		public var animloader:MovieClip		
		
		public function Main():void 
		{			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);				
		}
		
		public function dispatchMainReady():void
		{
			dispatchEvent(new Event(BridgeLoaderEvent.MAIN_CONTENT_READY))
		}
		
		private function init(e:Event = null):void 
		{	
			
			INSTANCE = this
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var _contextMenu:ContextMenu = new ContextMenu()
			_contextMenu.hideBuiltInItems();
			_contextMenu.customItems = [new ContextMenuItem("Turbodrive | Beta v0.92 | Work In Progress... "), new ContextMenuItem("© 2014 Silvère Maréchal", false, false)]
			this.contextMenu = _contextMenu
				
			Config.init(this);
			Path.update();
			stage.stageFocusRect = false
					
			
			var facade:ApplicationFacade = ApplicationFacade.getInstance()
			facade.startup( this );
		}	
		
		
		private function checkKey():Boolean
		{
			var k:String = this.loaderInfo.parameters.lsk as String

			for(var i:int = 0; i<keys.length ; i++){
				if(k == keys[i]){
					_key = k
					return true
				}
			}
			return false;
		}
		
		public function enableDebug():void
		{			
			_txt = new TextField()
			_txt.background = true
			_txt.backgroundColor = 0xFFFFFF
			_txt.width = 250
			_txt.height = 500
			_txt.x = _txt.y = 10
			this.addChild(_txt)
			Main.trc("enabled")
		}
		
		public static function trc(s:String):void{
			_txt.appendText(s + " \n")
			_txt.parent.setChildIndex(_txt,_txt.parent.numChildren-1)
		}
		
		
	}
}