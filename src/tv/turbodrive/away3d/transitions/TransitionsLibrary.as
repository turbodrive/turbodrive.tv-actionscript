package tv.turbodrive.away3d.transitions
{
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.utils.Dictionary;
	
	import tv.turbodrive.away3d.transitions.timeline.TimelineCamName;
	import tv.turbodrive.away3d.transitions.timeline.TimelineCameraData;
	import tv.turbodrive.away3d.transitions.timeline.TimelineData;
	import tv.turbodrive.away3d.transitions.timeline.vo.RiggedCamVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.utils.easing.CameraEase;
	import tv.turbodrive.utils.easing.FromReelEase;

	public class TransitionsLibrary
	{	
		
		public var timelinesCamera:Array = []
		public static var lib:Dictionary = new Dictionary()
		
		public function TransitionsLibrary()
		{	
			/** TIMELINECAMERA **/
			
			var delayVar:Number = 0
			var timeVar:Number = 0
			var timeMult:Number = 1
			
			var genericTransition:TimelineCameraData = new TimelineCameraData(TimelineCamName.GENERIC_TRANSITION,TimelineCameraData.RIGGED_CAM,true)
			genericTransition.x.setParams([4800],[80] , null, [20]);
			genericTransition.y.setParams([7000],[80], null , [20]);
			genericTransition.z.setParams([-1500,400], [32,72]);
			genericTransition.rotationY.setParams([-180],[80], null, [20]);
			genericTransition.rotationZ.setParams([235.5],[72], null, [20]);
			timelinesCamera.push(genericTransition)
			
			delayVar = 15
			timeMult = 1
			var fromReel:TimelineCameraData = new TimelineCameraData(TimelineCamName.FROM_REEL,TimelineCameraData.RIGGED_CAM,true,true)
			fromReel.startValues = new RiggedCamVO({x:0, y:0, z:6600, rotationX:0, rotationY:0, rotationZ:0, rigDistance:-7595.6});
			//fromReel.startValues = new RiggedCamVO({x:0, y:0, z:6600, rotationX:0, rotationY:0, rotationZ:0, rigDistance:-995.6});
			fromReel.x.setParams([2300],[99*timeMult], [FromReelEase.px], [delayVar*timeMult]);
			fromReel.y.setParams([-1640,0],[45*timeMult,99*timeMult], [FromReelEase.py1, FromReelEase.py2], [delayVar*timeMult]);
			fromReel.z.setParams([6600, -6800, -40000], [0.5, 80*timeMult, 20 ], [Linear.easeNone, FromReelEase.pz, Quad.easeOut], [0,(delayVar)*timeMult]);			
			fromReel.rotationY.setParams([-180],[99*timeMult], [FromReelEase.ry], [delayVar*timeMult]);
			fromReel.rotationX.setParams([10,0],[45*timeMult,85*timeMult], [FromReelEase.rx1, FromReelEase.rx2], [delayVar*timeMult]);
			fromReel.rigDistance.setParams([-7595.6, -15000,-995.6],[0.5, 45*timeMult,85*timeMult], [Linear.easeNone, FromReelEase.rig, FromReelEase.rig2], [0, delayVar*timeMult]);
			fromReel.rotationZ.setParams([12],[45*timeMult], [FromReelEase.rz], [delayVar*timeMult]);
			timelinesCamera.push(fromReel)
		
			
			var simpleTrs:TimelineCameraData = new TimelineCameraData(TimelineCamName.SIMPLE_TRANSITION,TimelineCameraData.RIGGED_CAM,true)
			simpleTrs.x.setParams([1200],[60]);
			simpleTrs.y.setParams([-900],[60]) ;
			simpleTrs.z.setParams([2000], [60]);
			simpleTrs.rotationX.setParams([25],[60]);
			simpleTrs.rotationY.setParams([90],[60]);
			simpleTrs.rotationZ.setParams([-90],[60]);
			timelinesCamera.push(simpleTrs);
			
		/*var simpleReelTrs:TimelineCameraData = new TimelineCameraData(TimelineCamName.SIMPLE_TO_REEL_TRANSITION,TimelineCameraData.RIGGED_CAM,true)
			simpleReelTrs.x.setParams([1200],[50]);
			simpleReelTrs.y.setParams([-900],[60]) ;
			simpleReelTrs.z.setParams([3200], [60]);
			simpleReelTrs.rotationX.setParams([-25],[50]);
			simpleReelTrs.rotationY.setParams([-125],[60]);
			simpleReelTrs.rigDistance.setParams([-3000,Tools3d.DISTANCE_Z_1280],[27,33]);
			timelinesCamera.push(simpleReelTrs);*/
			
			var scToScAuto:TimelineCameraData = new TimelineCameraData(TimelineCamName.SELECTEDCASES_TO_SELECTEDCASES, TimelineCameraData.RIGGED_CAM, false,false)
			scToScAuto.endValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			//scToScAuto.timelineTargetData.commonDuration = 2
			scToScAuto.commonEase = Quart.easeInOut
			scToScAuto.commonDelay = 0// .5
			scToScAuto.commonDuration = 1.5
			scToScAuto.rollCamera = true
			timelinesCamera.push(scToScAuto);
			
			var mpToMpAuto:TimelineCameraData = new TimelineCameraData(TimelineCamName.MP_TO_MP, TimelineCameraData.RIGGED_CAM, false,false)
			mpToMpAuto.endValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			//mpToMpAuto.timelineTargetData.commonDuration = 2
			mpToMpAuto.commonEase = Quart.easeInOut
			mpToMpAuto.commonDelay = 0
			mpToMpAuto.commonDuration = 1.5
			mpToMpAuto.rollCamera = true
			timelinesCamera.push(mpToMpAuto);
			
			var reelIn:TimelineCameraData = new TimelineCameraData(TimelineCamName.REEL_IN,TimelineCameraData.RIGGED_CAM,false)
			reelIn.startValues = new RiggedCamVO({x:0, y:0, z:0, rotationX:0, rotationY:0, rotationZ:0});
			reelIn.z.setParams([30000], [1], [Linear.easeNone]);
			reelIn.autoPlay = true
			timelinesCamera.push(reelIn);
			
			timeMult = 0.8
			var aboutIn:TimelineCameraData = new TimelineCameraData(TimelineCamName.ABOUT_IN,TimelineCameraData.RIGGED_CAM,false)
			aboutIn.startValues = new RiggedCamVO({x:2500, y:500, z:450, rotationX:0, rotationY:270, rotationZ:-47});
			aboutIn.x.setParams([0],[4*timeMult], [CameraEase.aboutIntroPx]);
			aboutIn.y.setParams([0],[4*timeMult], [CameraEase.aboutIntroPy]) ;
			aboutIn.z.setParams([0], [4*timeMult], [CameraEase.aboutIntroPz]);
			aboutIn.rotationX.setParams([0],[3.5*timeMult], [CameraEase.aboutIntroRx], [0.5*timeMult]);
			aboutIn.rotationY.setParams([0],[3.5*timeMult], [CameraEase.aboutIntroRy], [0.5*timeMult]);
			aboutIn.rotationZ.setParams([22.5],[3.5*timeMult], [CameraEase.aboutIntroRz], [0.5*timeMult]);
			aboutIn.autoPlay = true
			timelinesCamera.push(aboutIn);
			
			timeVar = 1.8 //2.5
			var aboutOut:TimelineCameraData = new TimelineCameraData(TimelineCamName.ABOUT_OUT,TimelineCameraData.RIGGED_CAM,false)
			aboutOut.commonEase = Quart.easeInOut
			aboutOut.x.setParams([-13000],[timeVar]);
			aboutOut.y.setParams([0],[timeVar]);
			aboutOut.z.setParams([700], [timeVar]);
			aboutOut.rotationX.setParams([0],[timeVar]);
			aboutOut.rotationY.setParams([-90],[timeVar]);
			aboutOut.rotationZ.setParams([0],[timeVar]);
			//aboutOut.isTargetCamera = false
			timelinesCamera.push(aboutOut);
			
			delayVar = 0
			timeMult = 0.6
			var selectedCasesIn:TimelineCameraData = new TimelineCameraData(TimelineCamName.SC_IN,TimelineCameraData.RIGGED_CAM,false,false)		
			selectedCasesIn.startValuesType = TimelineData.PORTAL_IN_ONTHEFLY // rotationZ : 100 in c4d (>> invert)
			selectedCasesIn.endValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY // rotationZ : 100 in c4d (>> invert)
			selectedCasesIn.commonEase = Quad.easeOut
			selectedCasesIn.commonDuration = 5*timeMult
			/*selectedCasesIn.rotationX.setParams([0],[5*timeMult], [CameraEase.aboutIntroRx], [0]);
			selectedCasesIn.rotationY.setParams([0],[5*timeMult], [CameraEase.aboutIntroRy], [0]);
			selectedCasesIn.rotationZ.setParams([0],[5*timeMult], [CameraEase.aboutIntroRz], [0]);*/
			selectedCasesIn.autoPlay = true
			timelinesCamera.push(selectedCasesIn);
			
			var selectedCasesOut:TimelineCameraData = new TimelineCameraData(TimelineCamName.SC_OUT, TimelineCameraData.RIGGED_CAM, false, false)
			selectedCasesOut.commonEase = Quart.easeInOut
			selectedCasesOut.commonDelay = 0.2 // 0.5
			selectedCasesOut.commonDuration = 1.5;
			selectedCasesOut.endValuesType = TimelineData.PORTAL_OUT_ONTHEFLY			
			selectedCasesIn.autoPlay = true
			timelinesCamera.push(selectedCasesOut);
						
			var toHyperDrive:TimelineCameraData = new TimelineCameraData(TimelineCamName.TO_HYPERDRIVE, TimelineCameraData.RIGGED_CAM, true)
			toHyperDrive.commonEase = Quad.easeIn
			//toHyperDrive.needEndTransition = true
			toHyperDrive.x.setParams([-1500],[60]);
			toHyperDrive.y.setParams([-900],[60]);
			toHyperDrive.z.setParams([3200], [60]);
			toHyperDrive.rotationY.setParams([-90],[60]);
			toHyperDrive.rotationZ.setParams([90],[60]);
			timelinesCamera.push(toHyperDrive);
			
			var toReel:TimelineCameraData = new TimelineCameraData(TimelineCamName.TO_REEL,TimelineCameraData.RIGGED_CAM,true)
			toReel.commonEase = Quart.easeIn
			toReel.z.setParams([40000], [25]);
			toReel.rotationZ.setParams([-20],[25]);
			timelinesCamera.push(toReel);
			
			var nothing:TimelineCameraData = new TimelineCameraData(TimelineCamName.NOTHING,TimelineCameraData.AUTO,true, false)
			nothing.commonEase = Linear.easeNone
			/*nothing.timelineTargetData = new TimelineData("target");
			nothing.timelineTargetData.endValues = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			nothing.timelineTargetData.commonDuration = 0*/
			nothing.endValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			nothing.commonDuration = 0
			nothing.commonDelay = 0
			//nothing.z.setParams([0],[0]);
			timelinesCamera.push(nothing);
			
			var waiter:TimelineCameraData = new TimelineCameraData(TimelineCamName.WAITER,TimelineCameraData.AUTO,true, false)
			waiter.commonEase = Linear.easeOut
			/*nothing.timelineTargetData = new TimelineData("target");
			nothing.timelineTargetData.endValues = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			nothing.timelineTargetData.commonDuration = 0*/
			//waiter.startValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			waiter.endValuesType = TimelineData.GP3D_AS_TARGET_ONTHEFLY
			waiter.commonDuration = 1
			waiter.commonDelay = 2
			//nothing.z.setParams([0],[0]);
			timelinesCamera.push(waiter);
			
			/*** Internal Transitions ****/
			var scInternalLoader:TimelineCameraData = new TimelineCameraData(TimelineCamName.INTERNAL_LOADER,TimelineCameraData.AUTO,false, false)
			scInternalLoader.commonEase = Quad.easeInOut
			scInternalLoader.commonDuration = 1
			scInternalLoader.commonDelay = 0
			scInternalLoader.rollCamera = true
			scInternalLoader.endValuesType = TimelineData.LOADER_ON_THE_FLY // get values passed as parameters
			timelinesCamera.push(scInternalLoader);
			
			
			var internalSubPage:TimelineCameraData = new TimelineCameraData(TimelineCamName.INTERNAL,TimelineCameraData.AUTO,false, false)
			internalSubPage.commonEase = Quad.easeInOut
			internalSubPage.commonDuration = 1
			internalSubPage.commonDelay = 0
			internalSubPage.endValuesType = TimelineData.GP3D_INTERNAL // get values passed as parameters
			timelinesCamera.push(internalSubPage);
			
			timeMult = 1//0.6			
			var internalTimeline:TimelineCameraData = new TimelineCameraData(TimelineCamName.INTERNAL_ABOUT_TIMELINE,TimelineCameraData.RIGGED_CAM,true, true)
			internalTimeline.x.setParams([-516],[90*timeMult], null);
			internalTimeline.y.setParams([-99],[90*timeMult], null) ;
			internalTimeline.z.setParams([754,446], [36*timeMult,54*timeMult],  null);
			internalTimeline.rotationX.setParams([-61.6,-55],[36*timeMult,54*timeMult],null);
			internalTimeline.rotationY.setParams([-220],[90*timeMult],null);
			internalTimeline.rotationZ.setParams([5],[90*timeMult], null);
			timelinesCamera.push(internalTimeline);

			
			/***************************/
			
			// TRANSITIONS			
			lib[TransitionsName.INTRO_FOLIO] = [TimelineCamName.NOTHING, TimelineCamName.NOTHING]
			//lib[TransitionsName.CHANGE_SELECTED_CASES] = [TimelineCamName.TO_HYPERDRIVE,TimelineCamName.TO_REEL]
			
			//lib[TransitionsName.SELECTED_CASES_SIMPLE] = [TimelineCamName.SIMPLE_TRANSITION]						
			lib[TransitionsName.SC_TO_REEL] = [TimelineCamName.SC_OUT, TimelineCamName.REEL_IN]
			lib[TransitionsName.MP_TO_REEL] = [TimelineCamName.SC_OUT, TimelineCamName.REEL_IN]
			lib[TransitionsName.ABOUT_TO_REEL] = [TimelineCamName.ABOUT_OUT, TimelineCamName.REEL_IN]
				
			lib[TransitionsName.REEL_TO_SC] = [TimelineCamName.FROM_REEL, TimelineCamName.SC_IN]
			lib[TransitionsName.REEL_TO_MP] = [TimelineCamName.FROM_REEL, TimelineCamName.SC_IN]
			lib[TransitionsName.REEL_TO_ABOUT] = [TimelineCamName.FROM_REEL, TimelineCamName.ABOUT_IN]
			/*lib[TransitionsName.TO_ABOUT] = [TimelineCamName.TO_HYPERDRIVE, TimelineCamName.ABOUT_IN]
			lib[TransitionsName.CHANGE_CATEGORY] = [TimelineCamName.TO_HYPERDRIVE, TimelineCamName.SIMPLE_TRANSITION]*/
				
			lib[TransitionsName.SC_TO_SC] = [TimelineCamName.SELECTEDCASES_TO_SELECTEDCASES]
			lib[TransitionsName.MORE_PROJECTS_SIMPLE] = [TimelineCamName.MP_TO_MP]
			lib[TransitionsName.ABOUT_TO_SELECTED_CASES] = [TimelineCamName.ABOUT_OUT, TimelineCamName.SC_IN]
			lib[TransitionsName.SC_TO_ABOUT] = [TimelineCamName.SC_OUT,TimelineCamName.ABOUT_IN]
				
			lib[TransitionsName.SC_TO_MP] = [TimelineCamName.SC_OUT, TimelineCamName.SC_IN]
			lib[TransitionsName.ABOUT_TO_MP] = [TimelineCamName.ABOUT_OUT,TimelineCamName.SC_IN]
				
			lib[TransitionsName.MP_TO_SC] = [TimelineCamName.SC_OUT, TimelineCamName.SC_IN]
			lib[TransitionsName.MP_TO_ABOUT] = [TimelineCamName.SC_OUT,TimelineCamName.ABOUT_IN]				
				
			lib[TransitionsName.INTERNAL] = [TimelineCamName.INTERNAL]
			lib[TransitionsName.INTERNAL_ABOUT_TIMELINE] = [TimelineCamName.INTERNAL_ABOUT_TIMELINE]
			lib[TransitionsName.SC_INTERNAL_LOADER] = [TimelineCamName.INTERNAL_LOADER, TimelineCamName.SELECTEDCASES_TO_SELECTEDCASES]
		}
	}
}