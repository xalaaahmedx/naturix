class UserModels {
  final String whoAmI;
  final String email;
  final String username;
  final String profile;
  final List<String> followers;
  final List<String> following;

  UserModels({
    required this.whoAmI,
    required this.email,
    required this.username,
    required this.profile,
    required this.followers,
    required this.following,
    // Add other parameters if needed
  });
}

