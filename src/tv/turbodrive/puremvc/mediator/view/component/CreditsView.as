package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.ButtonBackRollOver;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.StylesSingleton;

	public class CreditsView extends CreditsPanel
	{
		
		private var isOpen:Boolean = false
		public static const HEIGHT_OPEN:Number = 355
		
		private var _copyright:TextField;
		public function CreditsView()
		{
			close_mc.addEventListener(MouseEvent.CLICK, clickClosePanel)
			ButtonBackRollOver.addMotion(close_mc)
				
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			
			
			//****/
			var pageName:String = "credits"
			var xTx:int = 46
			Styles.createTextField(pageName,"intro/title", {parent:this, upperCase:true, x:xTx, y:36, antialiasing:StylesSingleton.NORMAL})
			Styles.createTextField(pageName,"intro/content", {parent:this, upperCase:false, x:xTx, y:92, antialiasing:StylesSingleton.THICKNESS_50})			
			
			xTx = 476
			Styles.createTextField(pageName,"content/reelTitle", {parent:this, upperCase:true, x:xTx, y:54, antialiasing:StylesSingleton.NORMAL})
			Styles.createTextField(pageName,"content/websiteTitle", {parent:this, upperCase:true, x:xTx, y:251, antialiasing:StylesSingleton.NORMAL})
			Styles.createTextField(pageName,"content/colPosition", {parent:this, upperCase:true, x:xTx, y:88})
			Styles.createTextField(pageName,"content/colNames", {parent:this, upperCase:false, x:623, y:88, antialiasing:StylesSingleton.THICKNESS_200})
			
			xTx = 895
			Styles.createTextField(pageName,"music/title", {parent:this, upperCase:true, x:xTx, y:54, antialiasing:StylesSingleton.NORMAL})
			Styles.createTextField(pageName,"music/content", {parent:this, upperCase:false, x:xTx, y:88, antialiasing:StylesSingleton.THICKNESS_200})
			
			xTx = 95
			Styles.createTextField(pageName,"thanks/title", {parent:thx_mc, upperCase:true, x:xTx, y:280})
			Styles.createTextField(pageName,"thanks/content", {parent:thx_mc, upperCase:false, x:xTx, y:312})
			_copyright = Styles.createTextField(pageName,"intro/copyright", {parent:this, upperCase:false, x:xTx, y:326, antialiasing:StylesSingleton.THICKNESS_50})
			_copyright.alpha = 0.9
				
			linkMusic_mc.buttonMode =true
			linkMusic_mc.alpha = 0
			linkMusic_mc.addEventListener(MouseEvent.ROLL_OVER, rollOverMusicHandler)
			linkMusic_mc.addEventListener(MouseEvent.ROLL_OUT, rollOutMusicHandler)
			linkMusic_mc.addEventListener(MouseEvent.CLICK, clickMusicHandler)
		}
		
		protected function clickMusicHandler(e:Event):void
		{
			navigateToURL(new URLRequest(XmlStringReader.getStringContent("contact", "contact/linkMail")))
		}
		
		protected function rollOverMusicHandler(e:MouseEvent):void
		{
			TweenMax.to(Sprite(e.target),0.3,{alpha:0.15, ease:Quart.easeOut})
		}
		
		protected function rollOutMusicHandler(e:MouseEvent):void
		{
			TweenMax.to(Sprite(e.target),0.5,{alpha:0, ease:Quart.easeOut})
		}	
		
		protected function addedToStageHandler(event:Event):void
		{		
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler(null);
		}			
		
		protected function resizeStageHandler(event:Event):void
		{
			shadow_mc.width = stage.stageWidth
			close_mc.x = stage.stageWidth - 30 - close_mc.width
			thx_mc.x = stage.stageWidth - 480
			bgWhite_mc.width = stage.stageWidth + 400
			y = getYTarget();
			_copyright.x = stage.stageWidth - _copyright.width - 30
		}
		
		public function getYTarget():int
		{
			if(!stage) return 20000
			
			if(isOpen){
				return stage.stageHeight - HEIGHT_OPEN
			}			
			return stage.stageHeight
		}
		
		protected function clickClosePanel(event:MouseEvent):void
		{
			dispatchEvent(new Event(ContactShareEvent.CLOSE_CREDITS_PANEL))
		}
		
		public function close():void
		{
			isOpen = false				
			TweenMax.to(this, 0.5, {y:getYTarget(), ease:Quart.easeOut, onComplete:switchVisibility})
		}
		
		public function open():void
		{
			isOpen = true
			visible = true
			TweenMax.to(this, 0.5, {y:getYTarget(), ease:Quart.easeOut})
		}
		
		public function switchVisibility():void
		{
			visible = false
		}
	}
}