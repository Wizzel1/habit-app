class Reward {
  Reward({
    this.name,
    this.description,
    this.id,
    this.isSelfRemoving,
  });

  String name;
  String description;
  String id;
  bool isSelfRemoving;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
      name: json["name"],
      description: json["description"],
      id: json["id"],
      isSelfRemoving: json["isSelfRemoving"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "id": id,
        "isSelfRemoving": isSelfRemoving,
      };
}

enum RewardInterval { ONCE, REGULAR, SOMETIMES }
