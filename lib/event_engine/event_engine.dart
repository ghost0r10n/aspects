part of aspects;

class AspectEventEngine{

	late AspectProcessors aspectProcessors;
	StreamController streamController = StreamController.broadcast();

	AspectEventEngine(){
		aspectProcessors = AspectProcessors();
	}


	void emit(String methodName){
		streamController.add(methodName);
	}

	Stream get aspectsStream => streamController.stream;
	

	void listenRun(String methodName){
		aspectProcessors.engineRun(methodName);	
	}
}
