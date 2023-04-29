import 'contact_detail.dart';

class Contact {
  //fields
  num? id;
  String firstName;
  String lastName;
  String email;
  List<ContactDetail>? contactDetail;

  factory Contact.init() {
    return Contact(firstName: '', lastName: '', email: '', contactDetail: []);
  }
  //constructor
  Contact(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.contactDetail});

  Contact.fromMap(
    Map<String, dynamic> result,
  )   : id = result["ID"],
        firstName = result['FIRSTNAME'],
        lastName = result['LASTNAME'],
        email = result['EMAIL'],
        contactDetail = [];

  Map<String, Object> toMap() {
    return {
      //'id': id ?? 0,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          contactDetail == other.contactDetail;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      contactDetail.hashCode;

  @override
  String toString() {
    return 'Contact{id: $id, firstName: $firstName, lastName: $lastName, email: $email}';
  }
}
