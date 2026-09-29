import 'package:flutter/foundation.dart';

enum ItemStatus { lost, found, claimed }

enum ItemCategory { electronics, keys, idCard, wallet, clothing, books, bag, other }

extension ItemCategoryExtension on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.electronics:
        return 'Electronics';
      case ItemCategory.keys:
        return 'Keys';
      case ItemCategory.idCard:
        return 'ID Card / Badge';
      case ItemCategory.wallet:
        return 'Wallet / Purse';
      case ItemCategory.clothing:
        return 'Clothing / Wearables';
      case ItemCategory.books:
        return 'Books & Stationery';
      case ItemCategory.bag:
        return 'Bag / Backpack';
      case ItemCategory.other:
        return 'Other Items';
    }
  }

  String get iconName {
    switch (this) {
      case ItemCategory.electronics:
        return 'devices';
      case ItemCategory.keys:
        return 'key';
      case ItemCategory.idCard:
        return 'badge';
      case ItemCategory.wallet:
        return 'account_balance_wallet';
      case ItemCategory.clothing:
        return 'checkroom';
      case ItemCategory.books:
        return 'menu_book';
      case ItemCategory.bag:
        return 'work';
      case ItemCategory.other:
        return 'category';
    }
  }
}

class UniversityCircle {
  final String id;
  final String name;
  final String passcode;
  final String campusLocation;
  final String logoBadge;
  final int memberCount;
  final String adminContact;

  UniversityCircle({
    required this.id,
    required this.name,
    required this.passcode,
    required this.campusLocation,
    required this.logoBadge,
    this.memberCount = 1,
    required this.adminContact,
  });
}

class LostFoundItem {
  final String id;
  final String title;
  final String description;
  final ItemCategory category;
  ItemStatus status;
  final String photoUrl;
  final DateTime dateReported;
  final String locationLostOrFound;
  final String currentLocationStorage;
  final String designatedContactName;
  final String designatedContactPhone;
  final String designatedContactEmail;
  final String universityCircleId;
  final String reporterStudentName;

  LostFoundItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.photoUrl,
    required this.dateReported,
    required this.locationLostOrFound,
    required this.currentLocationStorage,
    required this.designatedContactName,
    required this.designatedContactPhone,
    required this.designatedContactEmail,
    required this.universityCircleId,
    required this.reporterStudentName,
  });

  bool get isToday {
    final now = DateTime.now();
    return dateReported.year == now.year &&
        dateReported.month == now.month &&
        dateReported.day == now.day;
  }
}
