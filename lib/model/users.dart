class Users {
  String username = "";
  String avatar = ""; // TODO std Avatar einfügen (Link?)
  int levelXP = 0;
  int numCoins = 0;
  int numTickets = 0;

  Users(String username, {String? avatar}) {
    this.username = username;
    if (avatar != null) this.avatar = "assets/sadcat.jpeg";
  }

  Users? getInstance(String username) {
    if (true) // username schon vorhanden
      return null;
    //return new Users(username);
  }

  bool isUsernameTaken(String username) {
    // TODO
    // Datenbank durchschauen, ob es schon User mit Username gibt

    return true;
  }

  /*
  void createUser() {
    if ()
  }*/
}
