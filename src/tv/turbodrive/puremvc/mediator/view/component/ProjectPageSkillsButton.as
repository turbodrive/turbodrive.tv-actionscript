package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.FlashTextEngine;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;

	public class ProjectPageSkillsButton extends ButtonSkillsProject
	{
		private var isVertical:Boolean = false;
		public static const W_BUTTON:int = 70
		public static const H_BUTTON:int = 60
		
		public var id:int = 0
		private var localOver:Boolean = false
			
		private var twPicto:TweenMax
		private var twBg:TweenMax
		private var twBrd:TweenMax
		private var showBorder:Boolean = false
		private var _label:Sprite;
		
		public function ProjectPageSkillsButton(info:ProjectSkillsButtonInfo, isVertical:Boolean = false)
		{			
			id = info.id
			this.isVertical = isVertical;
				
			if(isVertical && id > 0){
				this.topLine_mc.alpha = 1
			}else{
				this.topLine_mc.alpha = 0
			}
			this.bLeft_mc.alpha = 0
			picto_mc.gotoAndStop(info.type)
			if(info.id > 0) showBorder = true
				
			var title:TextElement = new TextElement(info.title.toUpperCase(),FlashTextEngine.getElFormat("titleButtonSkills",Styles.sheet));
			var content:TextElement = info.content ? new TextElement("\n"+info.content,FlashTextEngine.getElFormat("subtitleButtonSkills",Styles.sheet)) : null
						
			var textAlign:String = isVertical ? FlashTextEngine.LEFT_ALIGN : info.labelAlign
			if(content){
				var groupContent:GroupElement = new GroupElement(new <ContentElement>[title, content]);
				_label = FlashTextEngine.createSpriteSkewLines(groupContent, 3, textAlign)
			}else{
				_label = FlashTextEngine.createSpriteSkewLines(title, 3, textAlign)
			}		
			
			addChild(_label)
			
			if(isVertical){
				_label.y = 12+(bg_mc.height - _label.height) * 0.5
				_label.x = MathUtils.getSkewXPos(_label.y) + bg_mc.width	
			}else{
				_label.y = bg_mc.height + bg_mc.y + 28
				if(info.labelAlign == FlashTextEngine.LEFT_ALIGN){
					_label.x = MathUtils.getSkewXPos(_label.y)
				}else{
					_label.x = MathUtils.getSkewXPos(_label.y) - FlashTextEngine.DEFAULT_LINE_WIDTH + W_BUTTON - 5
				}			
				_label.alpha = 0
			}
			
			_label.mouseChildren = _label.mouseEnabled = false
				
		
			picto_mc.mouseEnabled = false
			picto_mc.mouseChildren = false
			
			if(!isVertical){
				bg_mc.mouseEnabled = true
				bg_mc.buttonMode = true
				panelRollOut()				
				bg_mc.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				bg_mc.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}else{
				bg_mc.mouseEnabled = false
				bg_mc.buttonMode = false
			}
		}
		
		public function stopTween():void
		{
			if(twPicto) twPicto.pause()
			if(twBg) twBg.pause()
			if(twBrd) twBrd.pause()
		}
		
		public function panelRollOver(delay:Number = 0):void
		{
			stopTween()
			twPicto = TweenMax.to(picto_mc, 0.3, {delay:delay, removeTint:true , ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {delay:delay, removeTint:true, alpha:1, ease:Quart.easeOut })
			if(showBorder) twBrd = TweenMax.to(bLeft_mc, 0.3, {tint:Colors.VIOLET_HEADER_BAR, delay:delay, alpha:1, ease:Quart.easeOut })
			TweenMax.to(_label, 0.3, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function panelRollOut():void
		{
			stopTween()
			twPicto = TweenMax.to(picto_mc, 0.5, {removeTint:true , ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.5, {removeTint:true, alpha:0, ease:Quart.easeOut })
			twBrd = TweenMax.to(bLeft_mc, 0.5, {tint:Colors.VIOLET_HEADER_BAR, alpha:0, ease:Quart.easeOut })
			TweenMax.to(_label, 0.5, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function rollOutHandler(e:MouseEvent):void
		{
			stopTween()
			twPicto = TweenMax.to(picto_mc, 0.5, {removeTint:true , ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.5, {tint:Colors.LIGHT_GREY, alpha:1, ease:Quart.easeOut })
			if(showBorder) twBrd = TweenMax.to(bLeft_mc, 0.5, {removeTint:true, alpha:1, ease:Quart.easeOut })
			TweenMax.to(_label, 0.5, {autoAlpha:0, ease:Quart.easeOut })
		}
		
		public function rollOverHandler(e:MouseEvent):void
		{
			stopTween()
			twPicto = TweenMax.to(picto_mc, 0.3, {tint:Colors.VINTAGE_WHITE , ease:Quart.easeOut })
			twBg = TweenMax.to(bg_mc, 0.3, {tint:Colors.VINTAGE_RED , alpha:1, ease:Quart.easeOut })
			if(showBorder) twBrd = TweenMax.to(bLeft_mc, 0.3, {removeTint:true, alpha:1, ease:Quart.easeOut })
			TweenMax.to(_label, 0.3, {autoAlpha:1, ease:Quart.easeOut })
		}
		
		public function destroy():void
		{
			stopTween();
			twPicto = null
			twBg = null
			if(twBrd) twBrd = null
			
			while(numChildren > 0) removeChildAt(0);
		}
	}
}