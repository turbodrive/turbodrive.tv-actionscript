package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.Styles;

	public class MenuHeaderSection extends EventDispatcher
	{
		private var _main:MovieClip
		private var _folio:MovieClip
		private var _reel:MovieClip
		private var _buttons:Array = []
		private var _texts:Dictionary = new Dictionary();
			
		private var _isContact:Boolean;
		public function MenuHeaderSection(container:MovieClip, keyContent:String)
		{
			container.addEventListener(MouseEvent.ROLL_OUT, globalRollOutHandler, true)
			container.addEventListener(MouseEvent.ROLL_OVER, globalRollOverHandler, true)
			container.mouseChildren = true
			_main = container.main_mc
			_main.target = keyContent
			_buttons.push(_main)
				
			if(container.folio_mc){
				_folio = container.folio_mc
				_folio.target = keyContent
				_buttons.push(_folio)
			}
			if(container.reel_mc){
				_reel = container.reel_mc
				_reel.target = PagesName.INTRO
				_buttons.push(_reel)
			}
			
			_isContact = _buttons.length == 1
			var yPosMainText:int = 29
			if(_isContact) yPosMainText = 37
				
			_texts[_main] = Styles.createTextField("gui","header/"+keyContent+"Over", {upperCase:true, x:6,y:yPosMainText, parent:_main})
			if(_folio){
				var txtFieldFolio:TextField = Styles.createTextField("gui","header/folio", {upperCase:true, x:5.7,y:6.45, parent:container.folio_mc})
				_texts[_folio] = txtFieldFolio
			}
			if(_reel){
				var txtFieldReel:TextField = Styles.createTextField("gui","header/reel", {upperCase:true, x:5.7,y:6.45})
				MovieClip(container.reel_mc).addChild(txtFieldReel)
				_texts[_reel] = txtFieldReel
			}
				
			for(var i:int = 0; i< _buttons.length; i++){
				resetButton(_buttons[i] as MovieClip)
			}
		}
		
		protected function globalRollOutHandler(event:MouseEvent):void
		{
			var menu:MovieClip = MovieClip(event.currentTarget)
			var button:MovieClip = MovieClip(event.target)
			
			for(var i:int = 0; i<_buttons.length; i++){
				var btn:MovieClip = _buttons[i] as MovieClip
				outMenu(btn)
			}
		}
		
		protected function globalRollOverHandler(event:MouseEvent):void
		{
			var menu:MovieClip = MovieClip(event.currentTarget)
			var button:MovieClip = MovieClip(event.target)
				
			for(var i:int = 0; i<_buttons.length; i++){
				var btn:MovieClip = _buttons[i] as MovieClip
				if(btn == button){
					overButton(btn)
				}else{
					outButton(btn)
				}
			}	
		}
		
		private function resetButton(button:MovieClip):void
		{
			button.bg_mc.alpha = 0
			button.mouseChildren = false
			button.buttonMode = button.mouseEnabled = true
			TweenMax.to(TextField(_texts[button]), 0.1, {tint:0x574950});
			button.arrow_mc.x = _texts[button].width + _texts[button].x + 6
		}
		
		private function outMenu(btn:MovieClip):void
		{
			btn.twBg = TweenMax.to(btn.bg_mc, 0.5, {delay:0.1, alpha:0, tint:0x584951, ease:Quart.easeOut})
			btn.twTx = TweenMax.to(TextField(_texts[btn]), 0.5, {delay:0.1, tint:0x574950});
			if(_isContact || btn.bg_mc.height <= 70) TweenMax.to(btn.arrow_mc, 0.5, {alpha:0, ease:Quart.easeOut})
		}
		
		private function outButton(btn:MovieClip):void
		{
			if(btn.twBg) btn.twBg.pause()
			if(btn.twTx) btn.twTx.pause()
			
			if(_isContact || btn.bg_mc.height <= 70) TweenMax.to(btn.arrow_mc, 0.5, {alpha:0, ease:Quart.easeOut})
			btn.twBg = TweenMax.to(btn.bg_mc, 0.5, {alpha:1, tint:0x584951, ease:Quart.easeOut})
			btn.twTx = TweenMax.to(TextField(_texts[btn]), 0.5, {tint:0xCECEC4});
		}
		
		private function overButton(btn:MovieClip):void
		{
			if(btn.twBg) btn.twBg.pause()
			if(btn.twTx) btn.twTx.pause()
			
			btn.twBg = TweenMax.to(btn.bg_mc, 0.3, {alpha:1, removeTint:true, ease:Quart.easeOut})
			if(_isContact || btn.bg_mc.height <= 70) TweenMax.to(btn.arrow_mc, 0.3, {alpha:1, ease:Quart.easeOut})
			btn.twTx = TweenMax.to(TextField(_texts[btn]), 0.3, {tint:0xEFECE1});
		}
	}
}