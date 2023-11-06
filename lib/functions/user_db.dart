import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static saveUser(String username, String email, String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'username': username});
  }

  Future<String> uploadProfilePicture(String uid, Uint8List image) async {
    try {
      Reference storageRef = _storage.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask = storageRef.putData(image);
      await uploadTask;
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return "";
    }
  }

  static Future<String?> getUserImageUrl(String uid) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final userData = await userDoc.get();
      if (userData.exists) {
        final imageUrl = userData.data()?['imageUrl'];
        return imageUrl as String?;
      }
    } catch (e) {
      print('Error fetching user image URL: $e');
    }
    return null;
  }

  Future<void> savePicture(String userId, Uint8List file) async {
    try {
      String imageUrl = await uploadProfilePicture('profile_pictures', file);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'imageUrl': imageUrl});
      print('image added');
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  Future<void> editProfilePicture(String userId, Uint8List newImage) async {
    try {
      // Upload the new profile picture to Firebase Storage
      String imageUrl = await uploadProfilePicture(userId, newImage);

      // Update the user's profile picture URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'imageUrl': imageUrl});

      print('Profile picture updated');
    } catch (e) {
      print("Error editing profile picture: $e");
    }
  }

  Future<void> deleteUserImage(String uid) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      final userData = await userDoc.get();
      if (userData.exists) {
        final imageUrl = userData.data()!["imageUrl"] as String?;

        if (imageUrl != null) {
          // Delete the image from storage
          final storageRef = _storage.refFromURL(imageUrl);
          await storageRef.delete();

          // Set the user's image URL in Firestore to null
          await userDoc.update({'imageUrl': null});
          print('Image deleted');
        }
      }
    } catch (e) {
      print("Error deleting UserImage");
    }
  }

  static Future<String?> getUsername(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['username'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error  retrieving username: $e");
      return null;
    }
  }

  static Future<void> addToFavorites(String userId, String workoutId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final favoriteWorkoutRef = userRef.collection('favorites').doc(workoutId);

    await favoriteWorkoutRef.set({'workoutId': workoutId});
  }

  static Future<void> removeFromFavorites(
      String userId, String workoutId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final favoriteWorkoutRef = userRef.collection('favorites').doc(workoutId);

    await favoriteWorkoutRef.delete();
  }

  static String getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'User not logged in';
    }
  }

  static Future<void> saveUserDetails(
      String uid, int height, int weight) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'height': height, 'weight': weight});
  }

  static Future<void> editUsername(String uid, String newUsername) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'username': newUsername});
    } catch (e) {
      print("Error editing username $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error retrieving user details: $e ");
      return null;
    }
  }

  static Future<bool> hasUserEnteredDetails(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('user_details')
          .doc(uid)
          .get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking user details: $e");
      return false; // You can handle this error case as needed.
    }
  }
}
