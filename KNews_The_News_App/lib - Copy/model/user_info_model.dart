class NewUser {
  final String userName;
  final String password;
  final String contact;
  NewUser(
      {required this.userName, required this.password, required this.contact});
  Map<String, dynamic> userMap() {
    return {
      'userName': userName,
      'password': password,
      'contact': contact,
    };
  }
}
