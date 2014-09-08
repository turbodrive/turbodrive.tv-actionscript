package tv.turbodrive.away3d.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MaterialBuilder
	{
		public function MaterialBuilder(){}
		
		public static function getPow2Size(size:int):int
		{
			var initSize:int = 2;
			var pow:int = 2;
			while(initSize < size){
				pow ++
				initSize = Math.pow(2,pow);
			}
			return initSize
		}
		
		/**
		 * options : {size:int, tileX:Boolean, tileY:Boolean, rotation:Number}
		 **/
		public static function getATMaterialFromFrameSpriteSheet(source:BitmapData, area:Rectangle, options:Object):BitmapData
		{
			//size:int, tileX:Boolean, tileY:Boolean, rotation:Number
			var finalWidth:int = options.width
			var finalHeight:int = options.height			
			var rotation:Number = options.rotation ? options.rotation : 0
					
			// crop
			var croppedElement:BitmapData = new BitmapData(area.width,area.height,true, 0x00000000);
			croppedElement.copyPixels(source,area,new Point(0,0));
			
			// rotate
			var m:Matrix = new Matrix()
			if(rotation!=0){
				if(options.rotation == 90){
					m = new Matrix(0, -1, 1, 0, 0, area.width);
				}else if(options.rotation == -90){
					m = new Matrix(0, 1, -1, 0, area.height, 0);
				}
			}		
		
			var tempSize:int = getPow2Size(area.width)				
			var tempBdata:BitmapData = new BitmapData(tempSize,tempSize,true,0x00000000);
			tempBdata.draw(croppedElement,m,null,null,null,true);
			
			// tileX
			for(var i:int = area.height; i<tempSize; i+=area.height){
				tempBdata.copyPixels(tempBdata,new Rectangle(0,0,area.height,tempSize),new Point(i,0));
			}
			
			croppedElement.dispose();			
			// rescale
			var scale:Number =  finalWidth/tempSize
			m = new Matrix();
			m.scale(scale ,scale)
			
			croppedElement = new BitmapData(finalWidth, finalHeight, true, 0x00000000)
			croppedElement.draw(tempBdata, m)
			tempBdata.dispose()
				
			return croppedElement
		}
	}
}