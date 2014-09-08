package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import tv.turbodrive.utils.Colors;

	public class FullscreenButtonView extends FullscreeenButton
	{
		private var twPicto:TweenMax
		private var twLine:TweenMax
		private var twBrd:TweenMax
		private var twHit:TweenMax
		private var twBg:TweenMax
		
		public function FullscreenButtonView()
		{
			super();
			buttonMode = true
			mouseChildren = false
			mouseEnabled = true
			
			rollOut()
		}
		
		public function changeState(isfullscreen:Boolean =false ):void{
			if(isfullscreen){
				picto_mc.gotoAndStop(2)
			}else{
				picto_mc.gotoAndStop(1)
			}
		}
		
		public function stopTween():void
		{
			if(twPicto) twPicto.pause()
			if(twLine) twLine.pause()
			if(twBrd) twBrd.pause()
			if(twHit) twHit.pause()
			if(twBg) twBg.pause()
		}
		
		public function panelRollOver(delay:Number = 0):void
		{
			stopTween()
			twLine = TweenMax.to(this.line_mc, 0.6, {delay:delay, alpha:1, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {delay:delay, alpha:0.4, removeTint:true, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.3, {delay:delay, alpha:0, ease:Quart.easeOut })
			twHit = TweenMax.to(hitArea_mc, 0.3, {delay:delay, alpha:0, ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {alpha:0.3, ease:Quart.easeOut })
		}
		
		public function panelRollOut():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.5, {alpha:0, removeTint:true, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			twHit = TweenMax.to(hitArea_mc, 0.3, {alpha:0, ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {alpha:0, ease:Quart.easeOut })
		}
		
		public function rollOver():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.3, {alpha:0, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {tint:Colors.VINTAGE_WHITE, alpha:1, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.3, {alpha:1, ease:Quart.easeOut })
			twHit = TweenMax.to(hitArea_mc, 0.3, {alpha:1, ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {alpha:0, ease:Quart.easeOut })
		}
		
		public function rollOut():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {tint:Colors.VINTAGE_WHITE, alpha:0, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			twHit = TweenMax.to(hitArea_mc, 0.3, {alpha:0, ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {alpha:0, ease:Quart.easeOut })
		}
		
		public function destroy():void
		{
			stopTween();
			twPicto = null
			twLine = null
			if(twBrd) twBrd = null
			twBg = null
			
			while(numChildren > 0) removeChildAt(0);
		}
	}
}