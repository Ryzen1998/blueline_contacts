class ContactDetail {
  num? id;
  String nick;
  String number;

  ContactDetail({this.id, required this.nick, required this.number});
  factory ContactDetail.init(){
    return ContactDetail(nick: '', number: '');
  }

  Map<String, Object> toMap() {
    return {
      'ID': id ?? '0',
      'NICK': nick,
      'NUMBER': number,
    };
  }

  ContactDetail.fromMap(
    Map<String, dynamic> result,
  )   : id = result["ID"],
        nick = result['NICK'],
        number = result['NUMBER'];
}
