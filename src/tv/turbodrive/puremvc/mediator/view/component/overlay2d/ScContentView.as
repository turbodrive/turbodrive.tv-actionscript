package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	
	import away3d.core.math.MathConsts;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.GenButton;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectPageSkills;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectSkillsButtonInfo;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.SkillsName;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.FlashTextEngine;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	public class ScContentView extends SpriteDrivenBy3D
	{
		private var _yOffset:int = 50;
		private var yOpenContent:int = 155
		private var yOpenMenuSkills:int = 50
		
		private var _menuSkills:ProjectPageSkills
		
		private var _hitShape:Sprite;
		private var _content:Sprite = new Sprite();
		
		//private var workTitle:TextField;
		//private var descTitle:TextField;
		
		private var button:GenButton;
		private var _helperRectangleRotation:Shape = new Shape();
		private var _leftLayout:Boolean = false;
		private var _borgiaLayout:Boolean = false
		
		public function ScContentView(overlay:Overlay2DView)
		{		
			//this.addChild(new CrossHelper())
			super(overlay);
		}
		
		override public function buildContent(page:Page):void
		{	
			if(page.id == PagesName.GS || page.id == PagesName.BORGIA  || page.id == PagesName.TL ){
				MathUtils.ANGLE_SKEW_DEGREES = 0//Overlay2DView.ANGLE_LEFT
				_leftLayout = true
				_xOffset = 5
			}else{
				MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT
				_leftLayout = false
				_xOffset = -15
				//_yOffset = 75
			}
			if(page.id == PagesName.BORGIA) _borgiaLayout = true
			
			yOpenContent += _yOffset
			yOpenMenuSkills += _yOffset
			
						
			addChild(_content)
			_content.mouseEnabled = false
			this.mouseEnabled = false
			if(_borgiaLayout){
				_content.x = _xOffset
				_content.y = yOpenMenuSkills
			}else if(_leftLayout){ 
				_content.x = _xOffset
				_content.y = yOpenContent
			}else{
				placeElement(_content, yOpenContent-15)
			}
			
			var yPos:Number = createSkewText(page.id);
			
			createMenuSkills(page.id)
			createHitArea()
			createExtraButton(XmlStringReader.getStringContent("projects","common/moreButton"), yPos);
			
			addChild(_helperRectangleRotation)
			
			//alpha = 0
			_content.alpha = 0
			TweenMax.to(_content, 0.3, {delay:0.5, alpha:1})
			_menuSkills.animate()
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{	
			if(_destroyed) return
			this.x = rect.x
			this.y = rect.y
			this.rotation = /*rect.rotation */-3			
		}
						
		public function createSkewText(pageId:String):Number
		{
			// main Content
			var textContainer:Sprite
			var mainContent:TextElement = new TextElement(XmlStringReader.getStringContent("projects",pageId+"/desc"), FlashTextEngine.getElFormat("regularSkewContent",Styles.sheet));
			if(XmlStringReader.getStringContent("projects",pageId+"/copyright") && XmlStringReader.getStringContent("projects",pageId+"/copyright")){			
				var copyright:TextElement = new TextElement(XmlStringReader.getStringContent("projects",pageId+"/copyright"), FlashTextEngine.getElFormat("copyrightSkewContent",Styles.sheet));
				var group:GroupElement = new GroupElement(new <ContentElement>[mainContent, copyright]);
				textContainer = FlashTextEngine.createSpriteSkewLines(group); 
			}else {
				textContainer = FlashTextEngine.createSpriteSkewLines(mainContent)
			}
			
			_content.addChild(textContainer)
			return textContainer.height; 
		}	
		
		private function createHitArea():void
		{	
			if(_leftLayout){
				MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_LEFT
				_hitShape = getSkewShape(920,-200)
				_hitShape.x = 100
			}else{
				MathUtils.ANGLE_SKEW_DEGREES =  Overlay2DView.ANGLE_RIGHT
				_hitShape = getSkewShape(920,-200)
				_hitShape.x = -25
			}			
				
			addChildAt(_hitShape,0)
			_hitShape.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false);
			_hitShape.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false);
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			_menuSkills.panelRollOut()
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			_menuSkills.panelRollOver(-1)	
		}
		
		private function createExtraButton(labelButton:String, pY:Number):void
		{
			button = new GenButton(labelButton,GenButton.PLAIN_RED, GenButton.RIGHT, GenButton.ARROW_PICTOGRAM);
			button.addEventListener(MouseEvent.ROLL_OVER, rollOverButtonExtraHandler)
			button.addEventListener(MouseEvent.CLICK, clickGetMoreHandler)
			
			
			if(_leftLayout){
				button.x = 0//(_content.width - button.width)
				button.y = pY+15
			}else{
				placeElement(button, pY+15)
				button.x += 30
			}
			_content.addChild(button)
		}
		
		protected function rollOverButtonExtraHandler(event:MouseEvent):void
		{
			_menuSkills.panelRollOver(-1)
		}
		
		protected function clickGetMoreHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Overlay2DView.NAVIGATE_TO_SUBPAGE, this, SubPageNames.EXTRACONTENT))
		}
		
		private function createMenuSkills(pageName:String):void
		{
			var listActivSkills:Vector.<ProjectSkillsButtonInfo> = new Vector.<ProjectSkillsButtonInfo>();
			
			for(var i:int = 0; i< SkillsName.LIST.length; i++){
				var skillsName:String = SkillsName.LIST[i];
				var key:String = pageName+"/"+skillsName;
				if(XmlStringReader.getStringContent("projects",key) && XmlStringReader.getStringContent("projects",key) != ""){
					var id:int = int(XmlStringReader.getStringContent("projects",key+"/position"))
					var title:String = XmlStringReader.getStringContent("projects",key+"/title")
					var content:String = XmlStringReader.getStringContent("projects",key+"/content")
					var info:ProjectSkillsButtonInfo = new ProjectSkillsButtonInfo(id, title, content)
					info.type = skillsName
					listActivSkills.push(info)
				}
			}
			_menuSkills = new ProjectPageSkills(listActivSkills)
			addChild(_menuSkills)
			if(_borgiaLayout){
				//placeElement(_menuSkills, -7)
				_menuSkills.y = -10
				_menuSkills.x = 190
			}else if(_leftLayout){
				_menuSkills.x = _xOffset - 25
				_menuSkills.y = yOpenMenuSkills
			}else{
				MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT
				placeElement(_menuSkills, yOpenMenuSkills - 10)
			}				
		}
		
		override public function hideAndRemove():Boolean
		{
			TweenMax.to(this, 0.25, {alpha:0, onComplete:destroy})
			return true
		}
		
		override public function destroy():void
		{
			_destroyed = true
			if(parent) parent.removeChild(this)
			
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false);
			if(button) button.removeEventListener(MouseEvent.CLICK, clickGetMoreHandler)
			if(_menuSkills) _menuSkills.destroy();
			
			while(_content.numChildren > 0) _content.removeChildAt(0);
			super.destroy();			
		}
	}
}