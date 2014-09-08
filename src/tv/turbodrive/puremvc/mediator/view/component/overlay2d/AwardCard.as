package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.google.analytics.debug.Style;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.StylesSingleton;
	
	public class AwardCard extends Sprite
	{
		private var cdaL:BitmapData = new cdaLogo();
		private var lionL:BitmapData = new lionLogo();
		private var mobiusL:BitmapData = new mobiusLogo();
		private var fwaL:BitmapData = new fwaLogo();
		private var w3L:BitmapData = new w3Logo();
		private var webbyL:BitmapData = new webbyLogo();
		private var epicaL:BitmapData = new epicaLogo();
		
		
		private var textContainer:Sprite = new Sprite();
		private var logoImg:Bitmap;
		
		public function AwardCard(page:String, path:String)
		{
			var logoName:String = XmlStringReader.getStringContent(page, path+"/logo");
			
			var logoClass:Class = getDefinitionByName(logoName+"Logo") as Class
			var bData:BitmapData = new logoClass() as BitmapData
			logoImg = new Bitmap(bData,"auto", true);
			
			var title:TextField = Styles.createTextField(page, path+"/title", {upperCase:true})
			var type:TextField = Styles.createTextField(page, path+"/type", {upperCase:true})
			var content:TextField = Styles.createTextField(page, path+"/content", {upperCase:false, antialiasing:StylesSingleton.THICKNESS_200})
			textContainer.addChild(title)
			textContainer.addChild(type)
			textContainer.addChild(content)
			type.y = title.y + 25
			content.y = type.y + 20
			
			textContainer.x = logoImg.x + logoImg.width + 25	
			if(logoImg.height > textContainer.height){
				textContainer.y = (logoImg.height - textContainer.height) >> 1
			}else{
				logoImg.y = (textContainer.height - logoImg.height) >> 1
			}
			
			addChild(logoImg)
			addChild(textContainer);
			
			super();
		}
	}
}