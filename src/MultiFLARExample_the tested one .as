package {
	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.parsers.DAE;
	import com.squidder.flar.FLARMarkerObj;
	import com.squidder.flar.PVFLARBaseApplication;
	import com.squidder.flar.events.FLARDetectorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	
//	 * @author Jon Reiling
//	 
	 
	public class MultiFLARExample extends PVFLARBaseApplication {

		private var _cubes:Array;
		private var _lightPoint:PointLight3D;
		static public var count:int;
		static public var _earth:DAE;
		public var temp:int=1;
		public var flag:int=0;
		private var plane:Plane;
		private var F:int=1;
		private var f:String=F.toString();
		private var bm:BitmapFileMaterial=new BitmapFileMaterial('./fscommand/tp_Page_'+f+'.jpg');
		private var bm2:BitmapFileMaterial;
		public var myTimer:Timer=new Timer(1000,100000);// 1 second


		//var dispObj : DisplayObject3D = new DisplayObject3D();
		public function MultiFLARExample() {

			_cubes = new Array();

			_markers = new Array();

			_markers.push(new FLARMarkerObj("mikko.pat",16,50,80));
			//_markers.push(new FLARMarkerObj("one.pat",16,50,80));
			_markers.push( new FLARMarkerObj( "assets/flar/crash.pat" , 16 , 50 , 80 ) );
//			_markers.push( new FLARMarkerObj( "assets/flar/kickdrum.pat" , 16 , 50 , 80 ) );
//			_markers.push( new FLARMarkerObj( "assets/flar/ride.pat" , 16 , 50 , 80 ) );
//			_markers.push( new FLARMarkerObj( "assets/flar/snare.pat" , 16 , 50 , 80 ) );
//			
			super( );
		}

		override protected function _init( event : Event ):void {

			super._init( event );
			count=1;

			_earth = new DAE();
			_earth.load('untitled.dae');

			plane=new Plane(bm,1000,1000,1,1);
			plane.rotationX=180;
			plane.rotationZ=180;
            plane.scale=0.5;
			_lightPoint = new PointLight3D( );
			_lightPoint.y=1000;
			_lightPoint.z=-1000;

			fscommand("exec","tutoriak_speech.exe");
			myTimer.addEventListener(TimerEvent.TIMER, runOnce);
			myTimer.start();

		}

		override protected function _detectMarkers():void {

			_resultsArray=_flarDetector.updateMarkerPosition(_flarRaster,80,.5);

			for (var i : int = 0; i < _resultsArray.length; i ++) {

				var subResults:Array=_resultsArray[i];

				for (var j:* in subResults) {

					_flarDetector.getTransmationMatrix( subResults[ j ], _resultMat );
					if (_cubes[i][j]!=null) {
						transformMatrix( _cubes[ i ][ j ] , _resultMat );
					}

				}


			}
		}

		override protected function _handleMarkerAdded( event : FLARDetectorEvent ):void {
			_addCube( event.codeId , event.codeIndex );


		}

		override protected function _handleMarkerRemove( event : FLARDetectorEvent ):void {

			_removeCube( event.codeId , event.codeIndex );

		}

		private function _addCube( id:int , index:int ):void {

			// up();
			_earth.scale=5;
			//_earth.x=20;
			//_earth.rotationZ+=count;

			if (_cubes[id]==null) {
				_cubes[ id ] = new Array();
			}

			if (_cubes[id][index]==null) {


				var fmat:FlatShadeMaterial=_getFlatMaterial(id);
				var dispObj : DisplayObject3D = new DisplayObject3D();

				var cube:Cube=new Cube(new MaterialsList({all:fmat}),40,40,40);
				cube.z=20;

				//addEventListener(Event.ENTER_FRAME, _update);

				if (id==0) {
					//plane=new Plane(bm,1000,1000,1,1);
					dispObj.addChild(plane);

				} else {
					dispObj.addChild(cube);

				}


				_baseNode.addChild( dispObj );

				_cubes[id][index]=dispObj;

			}


			_baseNode.addChild( _cubes[ id ][ index ] );

		}

		private function _removeCube( id:int , index:int ):void {

			if (_cubes[id]==null) {
				_cubes[ id ] = new Array();
			}

			if (_cubes[id][index]!=null) {

				if (id==1) {
					up();
					plane.scaleX+=count;
				}
				//{   _earth.scale+=10;


				//}
				//{
				//if(_cubes[0]==null)
				//_earth.scale+=5;

				_earth.scale+=10;
//				var dispObj : DisplayObject3D = new DisplayObject3D();
//				dispObj.addChild(_earth);
//				   _baseNode.addChild( dispObj );
//				     _cubes[ 0 ][ index ] = dispObj;
//				_baseNode.addChild( _cubes[ 0][ index ] );
				//}

				_baseNode.removeChild( _cubes[ id ][ index ] );
			}

			//_earth.load('untitled.dae');
		}

		private function _getFlatMaterial( id:int ):FlatShadeMaterial {

			if (id==0) {
				return new FlatShadeMaterial( _lightPoint , 0xff22aa , 0x75104e );
			} else if ( id == 1 ) {
				return new FlatShadeMaterial( _lightPoint , 0x00ff00 , 0x113311 );
			} else if ( id == 2 ) {
				return new FlatShadeMaterial( _lightPoint , 0x0000ff , 0x111133 );
			} else {
				return new FlatShadeMaterial( _lightPoint , 0x777777 , 0x111111 );
			}
		}
		private function up():void {
			count+=0.02;

		}





		/*var myTimer:Timer = new Timer(1000, 1); // 1 second
//		myTimer.addEventListener(TimerEvent.TIMER, runOnce);
//		myTimer.start();
*/		
	private function runOnce(event:TimerEvent):void {
		
		
		var str1:String=new String("back");
		var str2:String=new String("scale");
		var str3:String=new String("next");
		var str4:String=new String;
		var str5:String=new String;
		
		var urlRequest:URLRequest = new URLRequest("./fscommand/1.txt");
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
		urlLoader.load(urlRequest);
		 
		function urlLoader_complete(evt:Event):void {
		    
		str4=String(urlLoader.data.val);
		//str5=String(urlLoader.data.val2);
		
				
				
		if(str4==str2)
		{
			up();
			plane.scaleX+=0.2;
			plane.scaleY+=0.2;
		    trace("matchhh");
		}
		
		if(str4==str3)
		{   F++;
		    f="./fscommand/tp_Page_"+F.toString()+".jpg"
			bm=BitmapFileMaterial(f);
			plane=new Plane(bm,1000,1000,1,1);
			trace("change");
		
		
		}
		
		fscommand("exec","change.exe");
		
		}
		
		
		}
		
		


	}
}

