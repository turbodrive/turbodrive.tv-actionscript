package tv.turbodrive.puremvc.mediator.view.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.Styles;

	public class PrevButtonView extends PreviousButton
	{
		private var _clientName:TextField;
		private var _projectName:TextField;
		public function PrevButtonView()
		{
			var containerText:Sprite = new Sprite()
			containerText.mouseChildren = containerText.mouseEnabled = false
			containerText.x = 60
			containerText.y = -168
			containerText.rotation = -3
			
			_clientName = new TextField()
			_clientName.autoSize = TextFieldAutoSize.LEFT
			_clientName.multiline = true
			_clientName.embedFonts = true
			_clientName.wordWrap = false
			_clientName.selectable = false
			_clientName.alpha = 0.5
			_clientName.x = 1 
			_clientName.y = 0
			_clientName.defaultTextFormat = Styles.clientNameTextFormat
			containerText.addChild(_clientName)
			
			_projectName = new TextField()
			_projectName.autoSize = TextFieldAutoSize.LEFT
			_projectName.multiline = true
			_projectName.embedFonts = true
			_projectName.wordWrap = false
			_projectName.selectable = false
			_projectName.x = 0
			_projectName.y = 20
			_projectName.defaultTextFormat = Styles.projectNameTextFormat
			containerText.addChild(_projectName)
			
			addChild(containerText)
		}
		
		public function updatePageInfo(page:Page):void
		{
			_clientName.htmlText = page.project.htmlClient.toUpperCase()
			_projectName.htmlText = page.project.htmlName.toUpperCase()
		}
	}
}