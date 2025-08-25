abstract class NavigationUser {
  int get id;
  String? get lastName;
  String? get firstName;
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}';
}