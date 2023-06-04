part of aspects;

class AspectEventEngine {
  late AspectProcessors aspectProcessors;
  StreamController streamController = StreamController.broadcast();

  AspectEventEngine() {
    aspectProcessors = AspectProcessors();
  }

  void emit(AspectEvent methodName) {
    print("Emitting event for  => $methodName");
    streamController.add(methodName);
  }

  Stream get aspectsStream => streamController.stream;

  dynamic listenRun(AspectEvent aspectEvent) {
    return aspectProcessors.engineRun(aspectEvent);
  }
}
