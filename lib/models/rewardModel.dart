class Reward {
  Reward({
    this.name,
    this.description,
    this.id,
    this.isOneTime,
  });

  String name;
  String description;
  String id;
  bool isOneTime;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
      name: json["name"],
      description: json["description"],
      id: json["id"],
      isOneTime: json["isOneTime"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "id": id,
        "isOneTime": isOneTime,
      };
}

enum RewardInterval { ONCE, REGULAR, SOMETIMES }
