import 'package:flutter/material.dart';

class Reward {
  Reward({
    required this.name,
    required this.id,
    required this.isSelfRemoving,
  });

  String? name;
  String? description;
  String? id;
  bool? isSelfRemoving;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
      name: json["name"] as String?,
      id: json["id"] as String?,
      isSelfRemoving: json["isSelfRemoving"] as bool?);

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "isSelfRemoving": isSelfRemoving,
      };
}

enum RewardInterval { once, regular, sometimes }
