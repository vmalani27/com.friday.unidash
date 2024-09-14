// gmail_service.dart

import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart' as gMail;

class GmailService {
  late gMail.GmailApi gmailApi;

  Future<void> initializeGmailApi(String token) async {
    final authenticateClient = GoogleAuthClient(token);
    gmailApi = gMail.GmailApi(authenticateClient);
  }

  Future<List<gMail.Message>> fetchMessages() async {
    List<gMail.Message> messagesList = [];
    gMail.ListMessagesResponse results =
        await gmailApi.users.messages.list("me");
    if (results.messages != null) {
      for (gMail.Message message in results.messages!) {
        gMail.Message messageData =
            await gmailApi.users.messages.get("me", message.id!);
        messagesList.add(messageData);
      }
    }
    return messagesList;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final String token;
  final http.Client _client = http.Client();

  GoogleAuthClient(this.token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $token';
    return _client.send(request);
  }
}
