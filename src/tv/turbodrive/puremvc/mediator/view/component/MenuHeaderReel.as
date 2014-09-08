package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.mediator.view.Menu2DView;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.Styles;

	public class MenuHeaderReel extends HeaderReel
	{
		private var _buttonsTarget:Dictionary = new Dictionary();
		private var buttonMenuList:Array = []
		
		private var _scButton:Sprite
		private var _mpButton:Sprite
		private var _aboutButton:Sprite
		
		private var menuW:int = 535
			
		private var _outAlpha:Number = 0.1

		private var _copyrightY:int;
		public function MenuHeaderReel()
		{		
			
			_scButton = selectedCasesButton
			Styles.createTextField("gui","header/selectedCases", {upperCase:true, x:13,y:11, parent:_scButton})
			_buttonsTarget[_scButton] = PagesName.SELECTED_CASES
			_scButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			_scButton.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			_scButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)			
			
			_mpButton = moreProjectsButton
			Styles.createTextField("gui","header/moreProjects", {upperCase:true, x:12,y:11, parent:_mpButton})
			_buttonsTarget[_mpButton] = PagesName.MORE_PROJECTS				
			_mpButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			_mpButton.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			_mpButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)
			
			_aboutButton = aboutButton
			Styles.createTextField("gui","header/about", {upperCase:true, x:12,y:24, parent:_aboutButton})
			_buttonsTarget[_aboutButton] = PagesName.ABOUT
			_aboutButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			_aboutButton.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			_aboutButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)
			buttonMenuList.push(_scButton, _mpButton, _aboutButton)
				
			_scButton.alpha = _mpButton.alpha = _aboutButton.alpha = 0.3
			_scButton.buttonMode = _mpButton.buttonMode = _aboutButton.buttonMode = true
				
			hitArea_mc.addEventListener(MouseEvent.ROLL_OVER, globalRollOverHandler)
			hitArea_mc.addEventListener(MouseEvent.ROLL_OUT, globalRollOutHandler)
			hitArea_mc.height += 10
			hitArea_mc.alpha = 0
			
			_scButton.alpha = _mpButton.alpha = _aboutButton.alpha = _outAlpha		
		}
		
		public function globalRollOutHandler(event:MouseEvent):void
		{
			TweenMax.to(_scButton, 0.5, {alpha:_outAlpha,ease:Quart.easeOut})
			TweenMax.to(_mpButton, 0.5, {alpha:_outAlpha,ease:Quart.easeOut})
			TweenMax.to(_aboutButton, 0.5, {alpha:_outAlpha,ease:Quart.easeOut})
			
		}
		
		public function globalRollOverHandler(event:MouseEvent, overTimeline:Boolean = false):void
		{
			TweenMax.to(_scButton, 0.3, {alpha:0.6,ease:Quart.easeOut})
			TweenMax.to(_mpButton, 0.3, {alpha:0.6,ease:Quart.easeOut})
			TweenMax.to(_aboutButton, 0.3, {alpha:0.6,ease:Quart.easeOut})			
		}		
		
		protected function rollOverHandler(event:Event):void
		{
			globalRollOverHandler(null)
			var button:Sprite = Sprite(event.currentTarget)
			TweenMax.to(button, 0.3, {alpha:1, ease:Quart.easeOut})
			/*if(_highlightButton && _highlightButton != button){
				TweenMax.to(_highlightButton, 0.3, {tint:0x53444D, ease:Quart.easeOut})
			}*/
		}
		
		protected function rollOutHandler(event:Event):void
		{
			globalRollOutHandler(null)
			var button:Sprite = Sprite(event.currentTarget)
			TweenMax.to(button, 0.8, {alpha:0.3, ease:Quart.easeOut})
			/*if(_highlightButton && _highlightButton != button){
				TweenMax.to(_highlightButton, 0.8, {removeTint:true, ease:Quart.easeOut})
			}*/
		}
		
		protected function mouseClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Menu2DView.CLICK_MENU_BUTTON,event.target, String(_buttonsTarget[event.currentTarget])));
		}
		
		public function updateWidth(_sW:int, _sH:int):void
		{			
			_scButton.x = _sW - menuW
			_mpButton.x = _scButton.x + _scButton.width - 1
			_aboutButton.x = _mpButton.x + _mpButton.width - 1		
		}
	}
}