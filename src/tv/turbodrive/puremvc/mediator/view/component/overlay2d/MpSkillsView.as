package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectPageSkills;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectSkillsButtonInfo;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SkillsName;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	public class MpSkillsView extends SpriteDrivenBy3D
	{
		private var _cross:CrossHelper;
		private var _page:Page;
		private var _menuSkills:ProjectPageSkills;

		private var _hitShape:Sprite;
		
		public function MpSkillsView(overlay:Overlay2DView)
		{
			super(overlay);
			_cross = new CrossHelper();
			mouseEnabled = false
		}
		
		override public function buildContent(page:Page):void
		{
			_page = page
			createMenuSkills(_page.id);
			createHitArea()
				
			//TweenMax.to(this, 0.5, {delay:0.1, autoAlpha:1})
			_menuSkills.animate(0.1)
		}
		
		private function createMenuSkills(pageName:String):void
		{
			var listActivSkills:Vector.<ProjectSkillsButtonInfo> = new Vector.<ProjectSkillsButtonInfo>();
			
			for(var i:int = 0; i< SkillsName.LIST.length; i++){
				var skillsName:String = SkillsName.LIST[i];
				var key:String = pageName+"/"+skillsName;
				if(XmlStringReader.getStringContent("secondaryProjects",key)){
					var id:int = int(XmlStringReader.getStringContent("secondaryProjects",key+"/position"))
					var title:String = XmlStringReader.getStringContent("secondaryProjects",key+"/title")
					var content:String = XmlStringReader.getStringContent("secondaryProjects",key+"/content")
					var info:ProjectSkillsButtonInfo = new ProjectSkillsButtonInfo(id, title, content)
					info.type = skillsName
					listActivSkills.push(info)
				}
			}
			_menuSkills = new ProjectPageSkills(listActivSkills)
			addChild(_menuSkills)	
		}
		
		private function createHitArea():void
		{	
			MathUtils.ANGLE_SKEW_DEGREES = 80
			_hitShape = getSkewShape(10,-100)
			_hitShape.x -= 30
			addChildAt(_hitShape,0)
			//_menuSkills.setHitShape(_hitShape)			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false);
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			_menuSkills.panelRollOut()
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			_menuSkills.panelRollOver(-1)	
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{
			if(_destroyed) return
			//trace("rest >> " + rect.x + " - " + rect.y)
			x = rect.x + 235//- (rect.width/2) + 185
			y = rect.y + 50//- (rect.height/2) + 28	
			rotation = extraRotation
		}
		
		override public function hideAndRemove():Boolean
		{
			TweenMax.to(this, 0.25, {alpha:0, onComplete:destroy})
			return true
		}
	}
}