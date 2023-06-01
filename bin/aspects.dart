import 'functions/functions.dart';
import 'package:aspects/aspects.dart';



void main(){
	AspectEventEngine aspectEventEngine = AspectEventEngine();
	print( "Start listening for events...");	
	 aspectEventEngine.aspectsStream.listen((event) {
	 	print("EVENT $event received");
		aspectEventEngine.listenRun(event);
	});


	aspectEventEngine.emit("function");
}






