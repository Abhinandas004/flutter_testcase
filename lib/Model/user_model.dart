class UserModel {
  final String name;
  final int age;
  final String? imagePath;

  UserModel({
    required this.name,
    required this.age,
    this.imagePath,
  });
}
