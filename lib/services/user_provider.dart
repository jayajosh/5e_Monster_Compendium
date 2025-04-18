import 'package:flutter/material.dart';
import 'package:monster_compendium/services/user_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  UserStore? _user;
  UserStore? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAndSetUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners that users is starting to load data

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (!userDoc.exists) {
        _errorMessage = 'User not found.';
        _isLoading = false;
        notifyListeners();
        return;
      }
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?; // Handle null
      if (userData == null) {

        _errorMessage = 'User data is null.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _user = UserStore.fromMap(userData);

      _isLoading = false;
      notifyListeners(); // Notify listeners that data is loaded
    } catch (error) {
      _errorMessage = 'Failed to fetch user data: $error';
      _isLoading = false;
      notifyListeners();
      //print("Error fetching user data: $error"); todo snack bar it
    }
  }

  void clearUser() {
    _user = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

