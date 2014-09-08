package tv.turbodrive.away3d.elements.entities
{
	import away3d.containers.View3D;
	
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.geom.RectangleRotation;

	public class GroupTps3D
	{
		public var page:Page
		private var _subPageName:String;
		private var _tps3D:Vector.<TriPosSprite3D>;
		private var _rectangle:Vector.<RectangleRotation>;
		
		public function GroupTps3D(subPageName:String, tps3D:Vector.<TriPosSprite3D>)
		{
			_subPageName = subPageName
			_tps3D = tps3D
		}
		
		public function get subPageName():String
		{
			return _subPageName
		}
		
		public function get tps3D():Vector.<TriPosSprite3D>
		{
			return _tps3D
		}
		
		public function get rectangles():Vector.<RectangleRotation>
		{
			return _rectangle
		}
		
		public function processRectangles(view:View3D):Boolean
		{
			_rectangle = new Vector.<RectangleRotation>();
			for(var i:int = 0; i<_tps3D.length; i++){
				if(_tps3D[i].activated){
					var rectangle:RectangleRotation = TriPosSprite3D(_tps3D[i]).processRectangle(view)
					if(rectangle) _rectangle.push(rectangle)
				}else{
					_rectangle.push(new RectangleRotation());
				}
				
			}
			
			return _rectangle.length > 0
		}
	}
}