import 'package:event_bus/event_bus.dart' as bus;

final bus.EventBus _instance = bus.EventBus();

class EventBus {

  static Stream<T> on<T>() => _instance.on<T>();

  static void send(event) => _instance.fire(event);
}