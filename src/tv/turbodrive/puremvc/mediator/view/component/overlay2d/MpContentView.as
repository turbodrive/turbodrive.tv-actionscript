package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.mediator.view.component.GenButton;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.StylesSingleton;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	public class MpContentView extends SpriteDrivenBy3D
	{
		private var _cross:CrossHelper;
		private var _description:Sprite;
		private var _page:Page;
		
		public function MpContentView(overlay:Overlay2DView)
		{
			visible = false
			alpha = 0
			super(overlay);
			_cross = new CrossHelper();
		}
		
		override public function buildContent(page:Page):void
		{
			_page = page
			addChild(createDescription(page.id))
			
			TweenMax.to(this, 0.5, {delay:0.1, autoAlpha:1})
		}
		
		private function createDescription(pageId:String):Sprite
		{
			_description = new Sprite();
			//var title:TextField = Styles.createTextField("projects","common/extraDescTitle", {upperCase:true})
			//_description.addChild(title)
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
			descText.width = 250
			
			descText.htmlText = "<regularLight11WhiteBg>"+XmlStringReader.getStringContent("secondaryProjects",pageId+"/desc")+"</regularLight11WhiteBg>"
			Styles.applyAntialiasing(descText, StylesSingleton.THICKNESS_200)
			
			//Styles.createTextField("projects",pageId+"/desc", {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
			_description.addChild(descText)
			descText.y = 90
			descText.x = 30
			if(_page.project && _page.project.caseVimeo){
				var buttonVimeo:GenButton = new GenButton(XmlStringReader.getStringContent("projects","common/vimeoButton"),GenButton.PLAIN_RED, GenButton.RIGHT, GenButton.EXTERNAL_LINK_PICTOGRAM);
				_description.addChild(buttonVimeo)
				buttonVimeo.y = descText.y + descText.height + 25
				buttonVimeo.x = descText.x
			}
			
			return _description
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{
			if(_destroyed) return
			//trace("pageId >> " + _page.id + "rotation 1 >> " + rect.rotation)
			super.updatePosition(rect, gps3d, -8)
		}
		
		override public function hideAndRemove():Boolean
		{
			TweenMax.to(this, 0.35, {alpha:0, onComplete:destroy})
			return true
		}
	}
}