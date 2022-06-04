class Conversations {
  late List<Chat> chats;
  late List<Team> teams;

  Conversations.fromJSON(Map<String, dynamic> json): 
    chats = (json['chats'] as List<dynamic>).map((element) => Chat.fromJSON(element)).toList(), 
    teams = (json['teams'] as List<dynamic>).map((element) => Team.fromJSON(element)).toList();
}

class Chat {
  late String id;
  late String title;

  Chat.fromJSON(Map<String, dynamic> json): id = json['id'], title = json['title'];
}

class Team {
  late String id;
  late String displayName;
  Team.fromJSON(Map<String, dynamic> json): id = json['id'], displayName = json['displayName'];
}