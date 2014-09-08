package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class ProjectPageSkills extends Sprite
	{
		
		private var buttons:Array = []
		private var _isOver:Boolean;		
		private var _shade:ShadeButtonSkills = new ShadeButtonSkills();
		private var _timeGlobalRollout:Number;
		private var twShade:TweenMax;
		//private var twGrid:TweenMax;
		private var _activatedButtons:int = 0;
		private var _enabledMenu:Boolean = false;
		
		public function ProjectPageSkills(skills:Vector.<ProjectSkillsButtonInfo>)
		{
			addChild(_shade);
			_shade.buttonMode = _shade.mouseChildren = _shade.mouseEnabled = false
			this.mouseEnabled = false
			_shade.visible = false
			_shade.alpha = 0
			_shade.x = 1
			_shade.shade_mc.x += 75 
			//_shade.grid_mc.alpha = 0
			
			
			var x:int = 0			
			for(var i:int = 0; i< skills.length; i++){
				var id:int = skills[i].id
				var btn:ProjectPageSkillsButtonBr = new ProjectPageSkillsButtonBr(skills[i])
				btn.addEventListener(MouseEvent.ROLL_OVER, rollOverButtonHandler, false);
				btn.addEventListener(MouseEvent.ROLL_OUT, rollOutButtonHandler);
				btn.addEventListener(ProjectPageSkillsButtonBr.ACTIVATED, activatedButtonHandler);
				addChild(btn)				
				btn.x = id*ProjectPageSkillsButtonBr.W_BUTTON
				buttons.push(btn)
			}			
		}
		
		protected function activatedButtonHandler(event:Event):void
		{
			_activatedButtons ++
			if(_activatedButtons >= buttons.length){
				_enabledMenu = true
			}
		}
		
		protected function rollOutButtonHandler(event:MouseEvent):void
		{
			if(!_enabledMenu) return
			_timeGlobalRollout = setTimeout(panelRollOut,50)
		}
		
		protected function rollOverButtonHandler(event:MouseEvent):void
		{	
			if(!_enabledMenu) return
			if(_timeGlobalRollout) clearTimeout(_timeGlobalRollout)
			for(var i:int = 0; i< buttons.length; i++){
				if(event && event.currentTarget == buttons[i]){
					ProjectPageSkillsButtonBr(buttons[i]).rollOver()
				}else{
					ProjectPageSkillsButtonBr(buttons[i]).rollOut()
				}
			}
			
			if(twShade) twShade.pause()
			//if(twGrid) twGrid.pause()
			twShade = TweenMax.to(_shade, 0.3, {autoAlpha:1})
			//twGrid = TweenMax.to(_shade, 0.3, {autoAlpha:0.4})
		}
		
		
		public function panelRollOut():void
		{
			if(!_enabledMenu) return
			for(var i:int = 0; i< buttons.length; i++){
				ProjectPageSkillsButtonBr(buttons[i]).panelRollOut()
			}
			
			if(twShade) twShade.pause()
			//if(twGrid) twGrid.pause()
			twShade = TweenMax.to(_shade, 0.3, {delay:0.1, autoAlpha:0})
			//twGrid = TweenMax.to(_shade.grid_mc, 0.3, {delay:0.1, autoAlpha:0})
		}
		
		public function animate(delay:Number = 0):void
		{
			for(var i:int = 0; i< buttons.length; i++){
				ProjectPageSkillsButtonBr(buttons[i]).animate(delay)
			}
		}
		
		public function panelRollOver(delay:Number = 0):void
		{
			if(!_enabledMenu) return
			if(_timeGlobalRollout) clearTimeout(_timeGlobalRollout)
			if(_isOver && delay < 0) return
			if(delay < 0) delay = 0
			for(var i:int = 0; i< buttons.length; i++){
				ProjectPageSkillsButtonBr(buttons[i]).panelRollOver(delay)
			}
			
			if(twShade) twShade.pause()
			//if(twGrid) twGrid.pause()
			twShade = TweenMax.to(_shade, 0.3, {delay:0.1, autoAlpha:0})
			//twGrid = TweenMax.to(_shade.grid_mc, 0.3, {delay:0.1, autoAlpha:0})
			
		}

		
		public function setHitShape(hitShape:Sprite):void
		{
			addChildAt(hitShape,0)
		}		
		
		public function destroy():void
		{
			
			_enabledMenu = false
			for(var i:int = 0; i< buttons.length; i++){
				var btn:ProjectPageSkillsButtonBr = ProjectPageSkillsButtonBr(buttons[i])
				btn.removeEventListener(MouseEvent.ROLL_OVER, rollOverButtonHandler);
				btn.removeEventListener(MouseEvent.ROLL_OUT, rollOutButtonHandler);
				btn.removeEventListener(ProjectPageSkillsButtonBr.ACTIVATED, activatedButtonHandler);
				btn.destroy();
			}
			
			buttons = []			
			while(numChildren > 0) removeChildAt(0)
		}
	}
}