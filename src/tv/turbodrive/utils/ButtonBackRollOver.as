package tv.turbodrive.utils
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ButtonBackRollOver
	{
		public function ButtonBackRollOver()
		{
		}
		
		public static function addMotion(button:MovieClip):void
		{
			if(button.hasEventListener(MouseEvent.ROLL_OVER)) return
			button.mouseChildren = false
			button.mouseEnabled = true
			button.buttonMode = true
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			button.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			button.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			button.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			button.addEventListener(MouseEvent.RELEASE_OUTSIDE, rollOutHandler);
		}
		
		protected static function rollOutHandler(event:MouseEvent):void
		{
			var  button:MovieClip = event.currentTarget as MovieClip
			TweenMax.to(button.picto_mc, 0.5, {removeTint:true, ease:Quart.easeOut})
			TweenMax.to(button.bg_mc, 0.5, {removeTint:true, ease:Quart.easeOut})
		}
		
		protected static function rollOverHandler(event:MouseEvent):void
		{
			var  button:MovieClip = event.currentTarget as MovieClip
			TweenMax.to(button.picto_mc, 0.25, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
			TweenMax.to(button.bg_mc, 0.25, {tint:Colors.VINTAGE_WHITE, ease:Quart.easeOut})			
		}
		
		protected static function mouseUpHandler(event:MouseEvent):void
		{
			var  button:MovieClip = event.currentTarget as MovieClip
			TweenMax.to(button.picto_mc, 0.2, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
			TweenMax.to(button.bg_mc, 0.2, {tint:Colors.VINTAGE_WHITE, ease:Quart.easeOut})			
		}
		
		protected static function mouseDownHandler(event:MouseEvent):void
		{
			var  button:MovieClip = event.currentTarget as MovieClip
			TweenMax.to(button.picto_mc, 0.1, {removeTint:true, ease:Quart.easeOut})
			TweenMax.to(button.bg_mc, 0.1, {removeTint:true, ease:Quart.easeOut})
			
		}
	}
}