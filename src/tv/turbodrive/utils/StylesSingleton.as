package tv.turbodrive.utils
{
	
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import tv.turbodrive.loader.AssetsManager;
	import tv.turbodrive.text.XmlStringReader;

	public class StylesSingleton
	{
		public var onComplete:Function
		
		public static const THICKNESS_200:String = "AntialiasThickness200"
		public static const THICKNESS_50:String = "AntialiasThickness50"
		public static const READABILITY:String = "AntialiasReadability"
		public static const NORMAL:String = "AntialiasNormal"
		
		private var _defaultFormat:TextFormat = new TextFormat("ITC Avant Garde Std Md",12,0xFFFFFF)
		private var _sheet:StyleSheet = new StyleSheet();
		private var _regular11:TextFormat = new TextFormat("ITC Avant Garde Gothic Std Extra Light",11, 0xCECEC4, false, false, false)
		private var _regular15:TextFormat = new TextFormat("ITC Avant Garde Gothic Std Extra Light",15, 0xCECEC4, false, false, false)
			
		private var _clientNameFormat:TextFormat = new TextFormat("ITC Avant Garde Std Bk",15, 0xEFECE1, true, false, false)
		private var _projectNameFormat:TextFormat = new TextFormat("ITC Avant Garde Std Md",30, 0xEFECE1, true, false, false)
		
		public function StylesSingleton(){
			_regular11.letterSpacing = 1
			_regular11.leading = 5
				
			_clientNameFormat.letterSpacing = -.5
			_projectNameFormat.letterSpacing = -1
			_projectNameFormat.leading = -6
		}
		
		public function init():void
		{		
			_defaultFormat.kerning = true;
			//_defaultFormat.leading = 0
			_defaultFormat.letterSpacing = 0//-0.1;
			_sheet.parseCSS(String(AssetsManager.getContent(AssetsManager.CSS)));
		}
		
		public function get sheet():StyleSheet
		{
			return _sheet
		}
		
		public function getDefaultTextField():TextField
		{
			var txField:TextField = new TextField();
			txField.defaultTextFormat = _defaultFormat;
			txField.antiAliasType = AntiAliasType.NORMAL;
			txField.embedFonts = true;
			txField.selectable = false;
			txField.autoSize = "left";
			txField.wordWrap = false;
			txField.condenseWhite = true;
			txField.multiline = true;
			txField.styleSheet = _sheet;
			txField.mouseWheelEnabled = false
			txField.mouseEnabled = false
			
			return txField;
		}
		
		public function createTextField(page:String, path:String, options:Object = null):TextField
		{	
			var upperCase:Boolean = false
			if(options && options.upperCase != null) upperCase = options.upperCase
			
			var txt:String = XmlStringReader.getStringContent(page,path)
			var txtField:TextField = createButtonField(txt, upperCase);
			
			if(!isNaN(options.x)) txtField.x = options.x
			if(!isNaN(options.y)) txtField.y = options.y
			if(!isNaN(options.width)) txtField.width = options.width
			if(!isNaN(options.height)) txtField.height = options.height
			if(options.parent) DisplayObjectContainer(options.parent).addChild(txtField)
			if(options.antialiasing){
				applyAntialiasing(txtField, options.antialiasing)
			}
				
			return txtField
		}
		
		public function applyAntialiasing(txtField:TextField, antialias:String):void
		{
			txtField.antiAliasType = AntiAliasType.ADVANCED				
			if(antialias == THICKNESS_200){
				txtField.sharpness = 100
				txtField.thickness = 200
			}else if(antialias == THICKNESS_50){
				txtField.sharpness = 100
				txtField.thickness = 50
			}else if(antialias == READABILITY){
				txtField.sharpness = 0
				txtField.thickness = 0
			}else if(antialias == NORMAL){
				txtField.antiAliasType = AntiAliasType.NORMAL
			}
		}
		
		public function replaceTextField(field:TextField, page:String, path:String, attribute:String = null, upperCase:Boolean = true):void
		{
			var newP:DisplayObjectContainer
			if(field.parent){
				newP = field.parent
				field.parent.removeChild(field)
			}
			var newField:TextField = createTextField(page, path, upperCase);
			newField.x = field.x
			newField.y = field.y
			newField.width = field.width
			newField.height = field.height
			newP.addChild(newField)	
		}
		
		public function get regular10TextFormat():TextFormat
		{		
			return _regular11
		}
		
		public function get regular15TextFormat():TextFormat
		{		
			return _regular15
		}
		
		public function get clientNameTextFormat():TextFormat
		{		
			return _clientNameFormat
		}
		
		public function get projectNameTextFormat():TextFormat
		{		
			return _projectNameFormat
		}
		
		public function createButtonField(htmlText:String, upperCase:Boolean = true):TextField
		{			
			var txField:TextField = getDefaultTextField();
			txField.htmlText = htmlText;
			
			if (upperCase) {
				txField.htmlText = txField.htmlText.toUpperCase();
			}
			
			if(txField.getTextFormat().size < 13){
				txField.antiAliasType = AntiAliasType.ADVANCED
				txField.sharpness = 100
				txField.thickness = 50
			}
			
			return txField;
		}
	}
}