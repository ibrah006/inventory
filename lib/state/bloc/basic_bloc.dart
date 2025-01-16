import 'dart:async';

class BasicBloc<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  StreamSink<T> get sink => _controller.sink;
  Stream<T> get stream => _controller.stream;

  updateState({T? event}) {
    sink.add(event ?? event as dynamic);
  }
}
