import 'package:flutter/material.dart';
import '../models/models.dart';

class ItemProvider extends ChangeNotifier {
  final List<LostFoundItem> _items = [
    // Today's Items
    LostFoundItem(
      id: 'item_1',
      title: 'Apple MacBook Air (Space Gray)',
      description: 'Found on 3rd floor study desk in the Central Library. Has a sticker of NASA on top lid.',
      category: ItemCategory.electronics,
      status: ItemStatus.found,
      photoUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
      dateReported: DateTime.now(),
      locationLostOrFound: 'Central Library, 3rd Floor',
      currentLocationStorage: 'Main Gate Security Desk',
      designatedContactName: 'Alex Rivera (Security Officer)',
      designatedContactPhone: '+1 (555) 019-2831',
      designatedContactEmail: 'alex.rivera@university.edu',
      universityCircleId: 'mit_circle',
      reporterStudentName: 'Alex Rivera',
    ),
    LostFoundItem(
      id: 'item_2',
      title: 'Blue Leather Wallet with Student ID',
      description: 'Lost somewhere between Science Block B and Student Dining Hall around lunch time.',
      category: ItemCategory.wallet,
      status: ItemStatus.lost,
      photoUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=500',
      dateReported: DateTime.now(),
      locationLostOrFound: 'Pathway near Science Block B',
      currentLocationStorage: 'With Student / Searching',
      designatedContactName: 'Sarah Jenkins',
      designatedContactPhone: '+1 (555) 014-9922',
      designatedContactEmail: 's.jenkins@student.edu',
      universityCircleId: 'mit_circle',
      reporterStudentName: 'Sarah Jenkins',
    ),
    LostFoundItem(
      id: 'item_3',
      title: 'Set of 4 Brass Keys with Red Keychain',
      description: 'Found near the Outdoor Basketball Courts after 5 PM game.',
      category: ItemCategory.keys,
      status: ItemStatus.found,
      photoUrl: 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=500',
      dateReported: DateTime.now(),
      locationLostOrFound: 'Sports Complex Basketball Court 2',
      currentLocationStorage: 'Sports Admin Desk (Room 102)',
      designatedContactName: 'Coach Michael',
      designatedContactPhone: '+1 (555) 018-4411',
      designatedContactEmail: 'm.coach@university.edu',
      universityCircleId: 'stanford_circle',
      reporterStudentName: 'David Chen',
    ),
    LostFoundItem(
      id: 'item_4',
      title: 'Calculus & Physics Textbooks in Nike Backpack',
      description: 'Black Nike backpack containing 2 textbooks and a blue pencil pouch.',
      category: ItemCategory.bag,
      status: ItemStatus.claimed,
      photoUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      dateReported: DateTime.now().subtract(const Duration(days: 1)),
      locationLostOrFound: 'Engineering Auditorium 101',
      currentLocationStorage: 'Returned to Owner',
      designatedContactName: 'Jessica Wu',
      designatedContactPhone: '+1 (555) 012-7744',
      designatedContactEmail: 'j.wu@student.edu',
      universityCircleId: 'mit_circle',
      reporterStudentName: 'Jessica Wu',
    ),
  ];

  String _searchQuery = '';
  String _selectedStatusFilter = 'ALL'; // ALL, LOST, FOUND, CLAIMED
  bool _onlyToday = false;
  ItemCategory? _selectedCategory;

  String get searchQuery => _searchQuery;
  String get selectedStatusFilter => _selectedStatusFilter;
  bool get onlyToday => _onlyToday;
  ItemCategory? get selectedCategory => _selectedCategory;

  List<LostFoundItem> getItemsForCircle(String circleId) {
    return _items.where((item) {
      if (item.universityCircleId != circleId && circleId.isNotEmpty) {
        return false;
      }
      if (_onlyToday && !item.isToday) {
        return false;
      }
      if (_selectedStatusFilter == 'LOST' && item.status != ItemStatus.lost) {
        return false;
      }
      if (_selectedStatusFilter == 'FOUND' && item.status != ItemStatus.found) {
        return false;
      }
      if (_selectedStatusFilter == 'CLAIMED' && item.status != ItemStatus.claimed) {
        return false;
      }
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchLoc = item.locationLostOrFound.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchLoc) {
          return false;
        }
      }
      return true;
    }).toList()
      ..sort((a, b) => b.dateReported.compareTo(a.dateReported));
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void toggleOnlyToday(bool value) {
    _onlyToday = value;
    notifyListeners();
  }

  void setCategoryFilter(ItemCategory? cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void addItem(LostFoundItem item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void markAsClaimed(String itemId) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      _items[index].status = ItemStatus.claimed;
      notifyListeners();
    }
  }
}
