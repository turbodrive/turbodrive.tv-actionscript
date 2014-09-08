package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.LineSegment;
	
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;

	public class TimelineDateLine
	{
		public var id:int
		
		private var _dot:Mesh;
		private var _dotW:Mesh;
		private var _line:LineSegment;
		private var _date:Mesh;
		private var _dateMaterial:ATMaterial
		
		public var lineLength:Number = 0
		private var interVector:Vector3D
		private var interVectorScaled:Vector3D
		private var targetScaleDot:Number = 0.7
		public var targetLineLength:Number = 1
			
		public var content:PlaneMesh;
		
		public function TimelineDateLine(dotW:Mesh, line:LineSegment, date:Mesh)
		{
			_dotW = dotW
			_dotW.scaleX = _dotW.scaleZ = 0.001
			_line = line
			
			interVector = _line.end.subtract(_line.start);
			updateLineLength();
				
			_date = date
			_dateMaterial = MaterialHelper.cloneATMaterial(ATMaterial(_date.material))
			_date.material = _dateMaterial
			_dateMaterial.alphaPremultiplied = false
			_dateMaterial.alpha = 0
		}
		
		public function set violetDot(dot:Mesh):void
		{
			_dot = dot
			_dot.scaleX = _dot.scaleZ = 0.001
		}
		
		public function play(targetScale:Number = -1):void
		{
			if(targetScale < 0) targetScale = targetLineLength
			var d:Number = 1.7+(0.2 * id)
			
			TweenMax.to(_dot, 0.2, {delay:d, scaleX : targetScaleDot, scaleZ: targetScaleDot, ease:Linear.easeNone})
			TweenMax.to(_dotW, 0.2, {delay:0.02+d, scaleX : targetScaleDot, scaleZ: targetScaleDot, ease:Linear.easeNone})
			TweenMax.to(this, 0.6, {delay:d+0.05, lineLength : targetScale, onUpdate:updateLineLength, ease:Quad.easeInOut})
			TweenMax.to(_dateMaterial, 0.3, {delay : 0.5+d, alpha : 1, ease:Quart.easeOut})
			TextureMaterial(content.material).alpha = 0
				
			var d2:Number = 2.5+(0.1 * id)
			TweenMax.to(TextureMaterial(content.material),0.5, {delay :d2, alpha : 1, ease:Quad.easeOut})
		}
		
		public function getEndVector(scaleLine:Number = -1):Vector3D
		{
			if(scaleLine < 0) scaleLine = targetLineLength
			interVectorScaled = interVector.clone()
			interVectorScaled.x *= scaleLine
			interVectorScaled.y *= scaleLine
			interVectorScaled.z *= scaleLine
			return _line.start.add(interVectorScaled)
		}
		
		public function updateLineLength():void{
			_line.end = getEndVector(lineLength)
		}
		
		public function hide():void
		{
			TweenMax.to(_dot, 0.2, {delay:0.3, scaleX : 0, scaleZ: 0, ease:Linear.easeNone})
			TweenMax.to(_dotW, 0.2, {delay:0.3, scaleX : 0, scaleZ: 0, ease:Linear.easeNone})
			TweenMax.to(this, 0.3, {delay:0.1, lineLength : 0, onUpdate:updateLineLength, ease:Quad.easeInOut})
			TweenMax.to(_dateMaterial, 0.3, {alpha : 0, ease:Quart.easeOut})
		}
	}
}