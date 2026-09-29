import 'package:flutter/material.dart';
import '../models/models.dart';

class CircleProvider extends ChangeNotifier {
  final List<UniversityCircle> _availableCircles = [
    UniversityCircle(
      id: 'mit_circle',
      name: 'MIT Campus Circle',
      passcode: 'MIT-FOUND',
      campusLocation: 'Cambridge, MA',
      logoBadge: '🏛️',
      memberCount: 4250,
      adminContact: 'lostandfound@mit.edu',
    ),
    UniversityCircle(
      id: 'stanford_circle',
      name: 'Stanford University',
      passcode: 'STANFORD-2026',
      campusLocation: 'Stanford, CA',
      logoBadge: '🌲',
      memberCount: 6100,
      adminContact: 'security@stanford.edu',
    ),
    UniversityCircle(
      id: 'oxford_circle',
      name: 'University of Oxford',
      passcode: 'OXFORD-101',
      campusLocation: 'Oxford, UK',
      logoBadge: '🎓',
      memberCount: 3890,
      adminContact: 'support@oxford.ac.uk',
    ),
  ];

  UniversityCircle? _activeCircle;
  String? _errorMessage;

  UniversityCircle? get activeCircle => _activeCircle;
  List<UniversityCircle> get availableCircles => List.unmodifiable(_availableCircles);
  String? get errorMessage => _errorMessage;

  bool joinCircle(String passcode) {
    final cleanCode = passcode.trim().toUpperCase();
    final found = _availableCircles.firstWhere(
      (c) => c.passcode.toUpperCase() == cleanCode,
      orElse: () => UniversityCircle(
        id: '',
        name: '',
        passcode: '',
        campusLocation: '',
        logoBadge: '',
        adminContact: '',
      ),
    );

    if (found.id.isNotEmpty) {
      _activeCircle = found;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid Passcode! Please check with your University Admin.';
      notifyListeners();
      return false;
    }
  }

  UniversityCircle createCircle({
    required String name,
    required String passcode,
    required String location,
    required String adminEmail,
  }) {
    final newCircle = UniversityCircle(
      id: 'circle_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      passcode: passcode.trim().toUpperCase(),
      campusLocation: location,
      logoBadge: '🏫',
      memberCount: 1,
      adminContact: adminEmail,
    );

    _availableCircles.add(newCircle);
    _activeCircle = newCircle;
    _errorMessage = null;
    notifyListeners();
    return newCircle;
  }

  void leaveCircle() {
    _activeCircle = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
