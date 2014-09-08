package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3DName;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.GenButton;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.StylesSingleton;
	import tv.turbodrive.utils.geom.RectangleRotation;

	public class ExtraContentView extends SpriteDrivenBy3D
	{		
		private var _credits:Sprite
		private var _description:Sprite
		private var _page:Page;
		private var _cross:CrossHelper
		
		private var buttonVimeo:GenButton;
		public function ExtraContentView(overlay:Overlay2DView)
		{			
			//this.mouseEnabled = this.mouseChildren = false
			_cross = new CrossHelper();
			//this.addChild(_cross);
			rotation = -3
			super(overlay);
		}
		
		override public function buildContent(page:Page):void
		{
			MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT
			
			_page = page
			
			addChild(createDescription(page.id));
			addChild(createCredits(page.id));
			
			placeElement(_description,95)
			_description.x -= 18
				
			alpha = 0
			TweenMax.to(this, 0.3, {alpha:1})
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number=0):void
		{	
			if(_destroyed) return
			if(width <= 0) return
			
			this.x = rect.x
			this.y = rect.y
			this.rotation = -3
			
			var ts3dAwards:TriPosSprite3D = _overlay.getTriPosSprite3d(TriPosSprite3DName.AWARDS)
			var ts3dExtra:TriPosSprite3D = _overlay.getTriPosSprite3d(TriPosSprite3DName.EXTRA)
				
			if(ts3dAwards && ts3dAwards.activated){
				var w1:Number = ts3dExtra.rectangle.width - ts3dAwards.rectangle.width - (ts3dAwards.rectangle.x - ts3dExtra.rectangle.x)
				_cross.x = ts3dAwards.rectangle.x-this.x + ts3dAwards.rectangle.width
				_cross.y = -this.y + ts3dAwards.rectangle.y
				_cross.width = w1
			}else if(ts3dExtra && ts3dExtra.activated){
				//_cross.x = ts3dAwards.rectangle.x-this.x + ts3dAwards.rectangle.width
				_cross.y = _description.y + _description.height
				_cross.width = ts3dExtra.rectangle.width
				_cross.x = _description.x - (rect.x - ts3dExtra.rectangle.x)
			}
			_credits.y = _description.y + _description.height + 120
			_credits.x = _cross.x + (_cross.width-_credits.width)*0.5
			if(_page.id == PagesName.IKAF2){
				_credits.x +=60
				_credits.y -= 20
			}else if(_page.id == PagesName.GS){
				_credits.y -= 60
			}else if(_page.id == PagesName.BORGIA){
				//_credits.x -= 160
				_credits.y -= 50
			}else if(_page.id == PagesName.TL){
				_credits.x += 10
				_credits.y -= 20
			}else if(_page.id == PagesName.GREETINGS){

				_credits.y -= 50
			}
			
		}
		
		private function createDescription(pageId:String):Sprite
		{
			_description = new Sprite();
			var title:TextField = Styles.createTextField("projects","common/extraDescTitle", {upperCase:true})
			_description.addChild(title)
			//var descText:TextField = Styles.createButtonField("<regularLight11WhiteBg>"+XmlStringReader.getStringContent("projects",pageId+"/desc")+"</regularLight11WhiteBg>", false)
			
			var descText:TextField = new TextField();
			descText.embedFonts = true;
			descText.selectable = false;
			descText.condenseWhite = false;
			var tf:TextFormat = new TextFormat();
			descText.multiline = true;			
			descText.styleSheet = Styles.sheet
			descText.wordWrap = true
			descText.autoSize = TextFieldAutoSize.LEFT
			if(_page.id == PagesName.GREETINGS || _page.id == PagesName.GS || _page.id == PagesName.BORGIA){
				descText.width = 365
			}else{
				descText.width = 450
			}
			
			descText.htmlText = "<regularLight11WhiteBg>"+XmlStringReader.getStringContent("projects",pageId+"/desc")+"</regularLight11WhiteBg>"
			Styles.applyAntialiasing(descText, StylesSingleton.THICKNESS_200)
				
			//Styles.createTextField("projects",pageId+"/desc", {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
			_description.addChild(descText)
			descText.y = title.y + title.height + 10
			if(_page.project && _page.project.caseVimeo){
				buttonVimeo = new GenButton(XmlStringReader.getStringContent("projects","common/vimeoButton"),GenButton.PLAIN_RED, GenButton.RIGHT, GenButton.EXTERNAL_LINK_PICTOGRAM);
				buttonVimeo.addEventListener(MouseEvent.CLICK, clickVimeoHandler)
				_description.addChild(buttonVimeo)
				buttonVimeo.y = descText.y + descText.height +25
				buttonVimeo.x = descText.width - buttonVimeo.width
			}
			
			return _description
		}
		
		protected function clickVimeoHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(_page.project.caseVimeo), "_blank");
		}
		
		override public function destroy():void
		{
			if(buttonVimeo) buttonVimeo.removeEventListener(MouseEvent.CLICK, clickVimeoHandler)
			super.destroy();
		}
		
		private function createCredits(pageId:String):Sprite
		{
			_credits = new Sprite();
			var title:TextField = Styles.createTextField("projects","common/extraCreditsTitle", {upperCase:true})
			_credits.addChild(title)
			
			var subTitle:TextField
			var namesText:TextField
			var functionsText:TextField				
							
			if(pageId == PagesName.IKAF2){
				var xPos:int = 0
				for(var i:int = 1; i <= 3 ; i++ ){
					subTitle = Styles.createTextField("projects",pageId+"/creditsT"+i, {upperCase:true})
					functionsText = Styles.createTextField("projects",pageId+"/creditsF"+i, {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
					namesText = Styles.createTextField("projects",pageId+"/creditsN"+i, {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
					subTitle.y = title.y + title.height + 10
					functionsText.y = subTitle.y + subTitle.height + 15
					subTitle.x = functionsText.x = xPos					
					namesText.y = functionsText.y
					namesText.x = functionsText.x + functionsText.width + 18
					xPos = namesText.x + namesText.width + 30
					_credits.addChild(functionsText)
					_credits.addChild(namesText)
					_credits.addChild(subTitle)
				}
				
			}else{				
				namesText = Styles.createTextField("projects",pageId+"/creditsNames", {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
				_credits.addChild(namesText)
				functionsText = Styles.createTextField("projects",pageId+"/creditsFunctions", {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
				_credits.addChild(functionsText)
				functionsText.y = title.y + title.height + 10
				namesText.y = functionsText.y
				namesText.x = functionsText.x + functionsText.width + 22
			}
				
			return _credits
		}
	}
}