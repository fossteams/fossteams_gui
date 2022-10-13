class Conversation {
  late List<Message> messages;

  Conversation.fromJSON(Map<String, dynamic> json):
    messages = (json['messages'] as List<dynamic>).map((element) => Message.fromJSON(element)).toList();
}

class Message {
  late String id;
  late String content;
  late String from;
  late String type;
  late String? subject;
  late String imDisplayName;
  late String originalArrivalTime;
  late Map<String, dynamic> reactions;
  late List<Message> replies;

  Message.fromJSON(Map<String, dynamic> json){
    id = json['id'] as String;
    content = json['content'] as String;
    from = json['from'] as String;
    subject = json['subject'] as String?;
    imDisplayName = json['imDisplayName'] as String;
    originalArrivalTime = json['originalArrivalTime'] as String;
    reactions = parseReactions(json['reactions']);
    type = json['type'] as String;
    replies = parseReplies(json['replies']);
  }

  List<Message> parseReplies(dynamic input) {
    if (input == null) {
      return List.empty();
    }
    return (input as List<dynamic>).map((element) => Message.fromJSON(element)).toList();
  }

  Map<String, dynamic> parseReactions(dynamic reactions) {
    if(reactions == null) {
      return {};
    }
    return reactions as Map<String, dynamic>;
  }
}