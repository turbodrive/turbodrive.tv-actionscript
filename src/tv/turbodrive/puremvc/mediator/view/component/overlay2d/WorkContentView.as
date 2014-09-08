package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectPageSkillsButton;
	import tv.turbodrive.puremvc.mediator.view.component.ProjectSkillsButtonInfo;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SkillsName;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.geom.RectangleRotation;

	public class WorkContentView extends SpriteDrivenBy3D
	{

		private var _cross:CrossHelper;

		private var title:TextField;

		private var menu:Sprite;
		
		public function WorkContentView(overlay:Overlay2DView)
		{			
			
			//_cross = new CrossHelper()
			//this.addChild(_cross);
			//rotation = -3
			super(overlay);
		}
		
		override public function buildContent(page:Page):void
		{	
			if(numChildren > 0) return
			MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT			
				
			title = Styles.createTextField("projects", "common/extraWorkTitle", {upperCase:false})
			placeElement(title,0)
			addChild(title)			
			menu = createMenuSkills(page.id)
			placeElement(menu, title.height + title.y + 20)
			
			alpha = 0
			TweenMax.to(this, 0.3, {alpha:1})
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{	
			if(_destroyed) return
			this.y = rect.y
			this.x = rect.x
			placeElement(menu, rect.height- menu.height - 25)
			placeElement(title, menu.y - 20 - title.height)
			title.x += 8
				
			this.rotation = rect.rotation -3			
		}
		
		private function createMenuSkills(pageId:String):Sprite
		{
			var content:Sprite = new Sprite();			
			var listButtons:Vector.<ProjectPageSkillsButton> = new Vector.<ProjectPageSkillsButton>();
			for(var i:int = 0; i< SkillsName.LIST.length; i++){
				var skillsName:String = SkillsName.LIST[i];
				var key:String = pageId+"/"+skillsName;
				if(XmlStringReader.getStringContent("projects",key) && XmlStringReader.getStringContent("projects",key) != ""){					
					var id:int = int(XmlStringReader.getStringContent("projects",key+"/position"))
					var title:String = XmlStringReader.getStringContent("projects",key+"/title")
					var textContent:String = XmlStringReader.getStringContent("projects",key+"/content")
					var info:ProjectSkillsButtonInfo = new ProjectSkillsButtonInfo(id, title, textContent)
					info.type = skillsName
					var button:ProjectPageSkillsButton = new ProjectPageSkillsButton(info, true);				
					placeElement(button, id*ProjectPageSkillsButton.H_BUTTON);
					listButtons.push(button)
					
					content.addChild(button)
				}
			}
			
			for(i = 0; i< listButtons.length ;i++){
				var btn:ProjectPageSkillsButton = listButtons[i] as ProjectPageSkillsButton
				content.setChildIndex(btn, btn.id)
			}
			
			addChild(content);			
			return content
		}
	}
}