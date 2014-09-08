package tv.turbodrive.utils
{
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ContentElement;
	import flash.text.engine.DigitCase;
	import flash.text.engine.DigitWidth;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.engine.LigatureLevel;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;
	import flash.text.engine.TypographicCase;

	public class FlashTextEngine
	{
		
		public static const RIGHT_ALIGN:String = "rightAlign"
		public static const LEFT_ALIGN:String = "LeftAlign"
		
		public static const DEFAULT_LINE_WIDTH:Number = 360
			
		public static function createSpriteSkewLines(element:ContentElement, spaceH:Number = 10, align:String = "LeftAlign", lineWidth:Number = -1):Sprite
		{   
			if(lineWidth < 0) lineWidth = DEFAULT_LINE_WIDTH
			var xInit:Number = (align == LEFT_ALIGN) ? 0 : lineWidth				
			var container:Sprite = new Sprite();
			container.mouseEnabled = container.mouseChildren = false
			var textBlock:TextBlock = new TextBlock();
			textBlock.content = element
			var yPos:Number = 0;		
			var textLine:TextLine = textBlock.createTextLine(null, lineWidth);
			
			while (textLine) {
				textLine.mouseChildren = textLine.mouseEnabled = false
				textLine.x = (align == LEFT_ALIGN) ? MathUtils.getSkewXPos(yPos) : (xInit - textLine.width) + MathUtils.getSkewXPos(yPos)
				textLine.y = yPos;
				yPos += textLine.height + spaceH
				container.addChild(textLine);
				textLine = textBlock.createTextLine(textLine, lineWidth);
			}			
			return container
		}	
		
		/** 
		 * Reads a set of style properties for a named style and then creates 
		 * a TextFormat object that uses the same properties. 
		 */ 
		public static function getElFormat(styleName:String, ss:StyleSheet):ElementFormat 
		{ 
			var style:Object = ss.getStyle(styleName); 
			if (style != null) 
			{ 
				var colorStr:String = style.color; 
				if (colorStr != null && colorStr.indexOf("#") == 0) 
				{ 
					style.color = colorStr.substr(1); 
				} 
				var fd:FontDescription = new FontDescription( 
					style.fontFamily, 
					FontWeight.NORMAL, 
					FontPosture.NORMAL, 
					FontLookup.EMBEDDED_CFF, 
					RenderingMode.CFF, 
					CFFHinting.NONE);
				
				if (style.hasOwnProperty("fontWeight"))         
				{                  
					fd.fontWeight = style.fontWeight; 
				}
				
				
				var format:ElementFormat = new ElementFormat(fd, 
					style.fontSize, 
					style.color, 
					1, 
					TextRotation.AUTO, 
					TextBaseline.ROMAN, 
					TextBaseline.USE_DOMINANT_BASELINE, 
					0.0, 
					Kerning.ON, 
					0.0, 
					0.0, 
					"en", 
					BreakOpportunity.AUTO, 
					DigitCase.DEFAULT, 
					DigitWidth.DEFAULT, 
					LigatureLevel.NONE, 
					TypographicCase.DEFAULT); 
				
				
				
				if (style.hasOwnProperty("letterSpacing"))         
				{                  
					format.trackingRight = style.letterSpacing; 
				} 
			} 
			return format; 
		}	
	}
}