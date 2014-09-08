package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.FlashTextEngine;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;

	public class ProjectPageSkillsButtonBr extends ButtonSkillsBR
	{
		public static const W_BUTTON:int = 74
		public static const H_BUTTON:int = 71
		
		public static const ACTIVATED:String = "activatedButton"
		
		public var id:int = 0
		///private var localOver:Boolean = false
		
		private var twPicto:TweenMax
		private var twLine:TweenMax
		private var twBrd:TweenMax
		//private var showBorder:Boolean = false
		private var _label:Sprite;
		
		
		public function ProjectPageSkillsButtonBr(info:ProjectSkillsButtonInfo)
		{			
			id = info.id
			this.alpha = 0
			picto_mc.gotoAndStop(info.type)
			//if(info.id > 0) showBorder = true
			
			var title:TextElement = new TextElement(info.title.toUpperCase(),FlashTextEngine.getElFormat("titleButtonSkills",Styles.sheet));
			var content:TextElement = info.content ? new TextElement("\n"+info.content,FlashTextEngine.getElFormat("subtitleButtonSkills",Styles.sheet)) : null
			
			MathUtils.ANGLE_SKEW_DEGREES = 0
			var textAlign:String = info.labelAlign
			if(content){
				var groupContent:GroupElement = new GroupElement(new <ContentElement>[title, content]);
				_label = FlashTextEngine.createSpriteSkewLines(groupContent, 3, textAlign)
			}else{
				_label = FlashTextEngine.createSpriteSkewLines(title, 3, textAlign)
			}		
			
			addChild(_label)
			
			_label.y = H_BUTTON+22
			if(info.labelAlign == FlashTextEngine.LEFT_ALIGN){
				_label.x = MathUtils.getSkewXPos(_label.y) + 5
			}else{
				_label.x = MathUtils.getSkewXPos(_label.y) - FlashTextEngine.DEFAULT_LINE_WIDTH + W_BUTTON - 5
			}			
			_label.alpha = 0			
			_label.mouseChildren = _label.mouseEnabled = false
				
			line_mc.y -= 3
			this.mouseChildren = false
			this.buttonMode = false
			
			/*picto_mc.mouseEnabled = false
			picto_mc.mouseChildren = false*/
			
			//hitArea_mc.mouseEnabled = true
			//hitArea_mc.mouseChildren = false
			
		
			//panelRollOut()				
			//hitArea_mc.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			//hitArea_mc.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		public function stopTween():void
		{
			if(twPicto) twPicto.pause()
			if(twLine) twLine.pause()
			if(twBrd) twBrd.pause()
		}
		
		public function panelRollOver(delay:Number = 0):void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.6, {delay:delay, alpha:1, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {delay:delay, alpha:1, removeTint:true, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.3, {delay:delay, alpha:0, ease:Quart.easeOut })
			TweenMax.to(_label, 0.3, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function panelRollOut():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.5, {alpha:1, removeTint:true, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			TweenMax.to(_label, 0.5, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function rollOver():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.3, {alpha:0, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {tint:Colors.VINTAGE_WHITE, alpha:1, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.3, {alpha:1, ease:Quart.easeOut })
			TweenMax.to(_label, 0.3, {autoAlpha:1, ease:Quart.easeOut })
		}
		
		public function rollOut():void
		{
			stopTween()
			twLine = TweenMax.to(line_mc, 0.5, {alpha:1, ease:Quart.easeOut })
			twPicto = TweenMax.to(picto_mc, 0.3, {tint:Colors.VINTAGE_WHITE, alpha:0.4, ease:Quart.easeOut })
			twBrd = TweenMax.to(border_mc, 0.5, {alpha:0, ease:Quart.easeOut })
			TweenMax.to(_label, 0.5, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function destroy():void
		{
			stopTween();
			twPicto = null
			twLine = null
			if(twBrd) twBrd = null
			
			while(numChildren > 0) removeChildAt(0);
		}
		
		
		public function animate(d:Number = 0):void
		{
			this.alpha = 1
			line_mc.alpha = picto_mc.alpha = 0
			twLine = TweenMax.to(line_mc, 0.1, {delay:d+0.4 + id*0.1, alpha:1, ease:Quart.easeOut, onComplete:hideLine })
			twPicto = TweenMax.to(picto_mc, 1, {delay:d+0.5 + id*0.1, alpha:1, ease:Quart.easeOut })
		}
		
		public function hideLine():void
		{
			twLine = TweenMax.to(line_mc, 0.5, {delay:0.25, alpha:0, ease:Quart.easeOut, onComplete:dispatchActivated})
		}
		
		public function dispatchActivated():void
		{
			this.mouseChildren = true
			this.buttonMode = true
			dispatchEvent(new Event(ACTIVATED))
		}
	}
}