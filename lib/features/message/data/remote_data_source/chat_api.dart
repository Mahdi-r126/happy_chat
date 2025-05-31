import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ChatApi {
  final String apiBaseUrl = 'http://185.204.197.138/api/v1';
  final String mqttHost = '185.204.197.138';
  final int mqttPort = 1883;
  final String mqttUsername = 'challenge';
  final String mqttPassword = r'sdjSD12$5sd';

  final String userToken;
  final String contactToken;
  late MqttServerClient _mqttClient;

  ChatApi({
    required this.userToken,
    required this.contactToken,
  });

  Future<void> connectMqtt(
      void Function(String topic, String message) onMessage) async {
    _mqttClient = MqttServerClient(mqttHost, '');
    _mqttClient.port = mqttPort;
    _mqttClient.logging(on: false);
    _mqttClient.keepAlivePeriod = 20;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .authenticateAs(mqttUsername, mqttPassword)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _mqttClient.connectionMessage = connMess;

    try {
      await _mqttClient.connect();
    } catch (e) {
      _mqttClient.disconnect();
      rethrow;
    }

    final topic = 'challenge/user/$userToken/$contactToken/';
    _mqttClient.subscribe(topic, MqttQos.atLeastOnce);

    _mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final senderContactToken = topic.length >= 4 ? topic[3] : 'unknown';
      onMessage(senderContactToken, pt);
    });
  }

  void publishMessage(String message) {
    final topic = 'challenge/user/$contactToken/$userToken/';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect() {
    _mqttClient.disconnect();
  }
}
