// ignore: unused_import
import 'functions/functions.dart';
import 'package:aspects/aspects.dart';

void main() {
  AspectEventEngine aspectEventEngine = AspectEventEngine();
  aspectEventEngine.aspectsStream.listen((event) async {
    dynamic result = await aspectEventEngine.listenRun(event);

  });

  aspectEventEngine.emit(AspectEvent("function", args: ["Fabio"]));
  aspectEventEngine.emit(AspectEvent("function2"));
}
