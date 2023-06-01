part of aspects;

class AspectEventEngine{

	late AspectProcessors aspectProcessors;
	StreamController streamController = StreamController.broadcast();

	AspectEventEngine(){
		aspectProcessors = AspectProcessors();
	}


	void emit(String methodName){
		print("Emitting event for  => $methodName");
		streamController.add(methodName);
	}

	Stream get aspectsStream => streamController.stream;
	

	void listenRun(String methodName){
		print("EVENT $methodName arrived to engine");
		aspectProcessors.engineRun(methodName);	
	}
}
