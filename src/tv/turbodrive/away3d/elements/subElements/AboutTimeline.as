package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.LineSegment;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.transitions.timeline.TimelineCamName;
	import tv.turbodrive.away3d.transitions.timeline.TimelineCamera;

	public class AboutTimeline extends EventDispatcher
	{
		private var _timelineConstant:Mesh
		
		private static var _whiteBlockMat:ColorMaterial;
		private static var _violetBlock:ColorMaterial;
		private var multDepth:int = -2		
		private var timelineDates:Array = ["1997", "1999", "2001", "2004", "2006", "2012", "Now"]
		private var contentPositions:Array = [new Vector3D(369,-177,100*multDepth), new Vector3D(301,-110, 80*multDepth), new Vector3D(98,-52 , 60*multDepth),new Vector3D(131, 15, 40*multDepth), new Vector3D(30,70, 20*multDepth), new Vector3D(-202, 153, 0*multDepth), new Vector3D(-280, 240 , -20*multDepth)]
			
		private static var tmleDateLines:Array
		private static var _timelineConstant:Mesh
		private static var timelineXp:ObjectContainer3D;
		private var violetDot:Array = []
		
		public static const CLICK_BACK:String = "backToIntro";

		private static var contentTimelineContainer:ObjectContainer3D;
		private static var timelineBlocks:ObjectContainer3D;
		private var _globalContainer:ObjectContainer3D;
		private static var _animatedTimeline:AnimatedTimeline;
		private static var _title:PlaneMesh;
		
		
		public function AboutTimeline(globalRotation:Number, globalContainer:ObjectContainer3D, mainATMaterial:ATMaterial)
		{	
			_globalContainer = globalContainer
			
			if(!timelineXp){
				timelineXp = AssetLibrary.getAsset("timelineContainer") as ObjectContainer3D
				timelineXp.rotationZ = globalRotation
			}
				
			if(!_timelineConstant){
				_timelineConstant = AssetLibrary.getAsset("ConstantZoe") as Mesh
				_timelineConstant.material = MaterialHelper.cloneATMaterial(mainATMaterial)
			}
			_constantDateGridMat.alpha = 0
			
			if(!contentTimelineContainer){
				contentTimelineContainer = new ObjectContainer3D();
				contentTimelineContainer.transform = TimelineCamera.getEndTransform(TimelineCamName.INTERNAL_ABOUT_TIMELINE)
			}				
			
			if(!tmleDateLines){
				var segmentSet:SegmentSet = new SegmentSet()
				var dotGroup:ObjectContainer3D = AssetLibrary.getAsset("dotGroup") as ObjectContainer3D		
				tmleDateLines = []			
				
				for(var i:int = 0; i< dotGroup.numChildren; i++){
					var d:Mesh = dotGroup.getChildAt(i) as Mesh
					if(!d) break;
					
					MeshHelper.recenter(d)				
					var end:Vector3D = d.position.clone();
					d.scaleY = 0.01
					if(d.name.search("dotsW") > -1)	{					
						var id:int = int(d.name.slice(5))
						var nameDate:String = timelineDates[id]
						end.z -= 100
						end.y += 130
						var line:LineSegment = new LineSegment(d.position, end, 0xFFFFFF,0xFFFFFF,0.4)
						segmentSet.addSegment(line)
						var _atlasArea:Rectangle = ATMaterial(mainATMaterial).coordinates["d"+nameDate]
						var scaleTex:Number = id == 6 ? 1.6 : 1.5
						_atlasArea.width *= scaleTex
						_atlasArea.height *= scaleTex
						var date:Mesh = new Mesh(new PlaneGeometry(_atlasArea.width, _atlasArea.height,1,1,true), mainATMaterial)
						var subMesh:SubMesh = date.subMeshes[0] as SubMesh
						subMesh.scaleU = _atlasArea.width / mainATMaterial.width / scaleTex
						subMesh.scaleV = _atlasArea.height / mainATMaterial.height /scaleTex
						subMesh.offsetU = (_atlasArea.x) / mainATMaterial.width
						subMesh.offsetV = (_atlasArea.y) / mainATMaterial.height						
					
						var tmleLine:TimelineDateLine = new TimelineDateLine(d,line, date)
						tmleLine.id = id
						tmleDateLines.push(tmleLine)
						if(nameDate == "2012") tmleLine.targetLineLength = 0.9
						if(nameDate == "Now") tmleLine.targetLineLength = 1.4
						if(nameDate == "2006") tmleLine.targetLineLength = 1.1
						
						var pos:Vector3D = tmleLine.getEndVector()
						pos.x -= 10	
						date.position = pos
						date.moveUp(_atlasArea.height)
						date.rotationX = -70
						date.rotationY = 120
						date.rotationZ = -20
						date.moveRight(_atlasArea.width >> 1)
						dotGroup.addChild(date)
							
						var contentName:String = "content" + nameDate
						var copyMaterial:ATMaterial = MaterialHelper.cloneATMaterial(mainATMaterial)
						var content:PlaneMesh = new PlaneMesh(copyMaterial, contentName)
						content.position = Vector3D(contentPositions[id]);
						contentTimelineContainer.addChild(content)
						tmleLine.content = content
						
					}else if(d.name.search("dots") > -1){
						var index:int = int(d.name.slice(4))
						violetDot[index] = d
					}
				}
				dotGroup.addChild(segmentSet)
				
				tmleDateLines.sortOn("id")
				for(i = 0; i< tmleDateLines.length ; i++){
					tmleLine = tmleDateLines[i]
					tmleLine.violetDot = violetDot[tmleLine.id]
				}
			}
						
			_globalContainer.addChild(timelineXp)
			
			if(!timelineBlocks){
				timelineBlocks = AssetLibrary.getAsset("timelineBlocks") as ObjectContainer3D
				timelineBlocks.rotationZ = globalRotation
					
				var whiteBlock:Mesh = AssetLibrary.getAsset("whiteBlock") as Mesh
				whiteBlock.geometry = new CubeGeometry(4000,200,600)
				whiteBlock.z += 150
				_whiteBlockMat = AssetLibrary.getAsset("WhiteLightMaterial") as ColorMaterial
				whiteBlock.material = _whiteBlockMat
				_whiteBlockMat.alpha = 0
				timelineBlocks.addChild(whiteBlock)
					
				var violetBlock:Mesh = AssetLibrary.getAsset("violetBlock") as Mesh
				violetBlock.geometry = new CubeGeometry(4000,100,600)
				violetBlock.z -= 200
				_violetBlock = AssetLibrary.getAsset("violetlightMat") as ColorMaterial
				_violetBlock.alpha = 0
				violetBlock.material = _violetBlock
				ColorMaterial(violetBlock.material).color = 0x201026
				violetBlock.material.lightPicker = whiteBlock.material.lightPicker
				timelineBlocks.addChild(violetBlock)
			}
				
			_globalContainer.addChild(timelineBlocks)			
			
			if(!_animatedTimeline) _animatedTimeline = new AnimatedTimeline();
			if(!_title){
				copyMaterial = MaterialHelper.cloneATMaterial(mainATMaterial)
				_title = new PlaneMesh(copyMaterial,"title");
				_title.position = new Vector3D(350,220, -200)
				contentTimelineContainer.addChild(_title)
			}
				
			_globalContainer.parent.addChild(contentTimelineContainer)
		}
		
		protected function closeTimelineHandler(event:Event):void
		{
			dispatchEvent(new Event(AboutTimeline.CLICK_BACK))
		}
		
		public function get _constantDateGridMat():TextureMaterial
		{
			return TextureMaterial(_timelineConstant.material)
		}
		
		public function show():void
		{
			
			_animatedTimeline.play();
			
			for(var i:int = 0; i< tmleDateLines.length ; i++){
				var tmleLine:TimelineDateLine = TimelineDateLine(tmleDateLines[i])
				tmleLine.play();
			}
			
			TweenMax.to(_violetBlock, 1, {alpha:1, delay:2})
			TweenMax.to(_whiteBlockMat, 1, {alpha:1, delay:2.5})			
		}
		
		public function hide():void
		{
			for(var i:int = 0; i< tmleDateLines.length ; i++){
				var tmleLine:TimelineDateLine = TimelineDateLine(tmleDateLines[i])
				tmleLine.hide();
			}
			
			_animatedTimeline.hide()
			TweenMax.to(_violetBlock, 1, {alpha:0, delay:0.2})
			TweenMax.to(_whiteBlockMat, 1, {alpha:0, delay:0.2})
		}
		
		public function dispose():void
		{
			if(_globalContainer){
				if(_globalContainer.parent && _globalContainer.parent.contains(contentTimelineContainer)) _globalContainer.parent.removeChild(contentTimelineContainer)
				_globalContainer.removeChild(timelineXp)
				_globalContainer.removeChild(timelineBlocks)
				_globalContainer = null
			}
		}
	}
}