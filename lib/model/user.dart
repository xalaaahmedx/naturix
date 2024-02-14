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

  // Add a factory constructor to create UserModels from a Map
  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      whoAmI: map['whoAmI'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      profile: map['profile'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      // Add other parameters if needed
    );
  }
}
