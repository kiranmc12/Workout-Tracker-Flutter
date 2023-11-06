import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/auth_functions.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/screens/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  int? height;
  int? weight;
  final String uid = FirestoreServices.getUserId();
  Uint8List? _image;
  String? imgUrl;

  @override
  void initState() {
    super.initState();
    getUsername();
    userHeightget();
    userWeightget();
    getEmail();
    getUserImage();
  }

  Future<void> getUserImage() async {
    try {
      final uid = FirestoreServices.getUserId();
      if (uid != 'User not logged in') {
        final imageUrl = await FirestoreServices.getUserImageUrl(uid);

        if (imageUrl != null) {
          setState(() {
            imgUrl = imageUrl;
          });
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  void selectEditedImage() async {
  Uint8List newImage = await pickImage(ImageSource.gallery);
  if (newImage != null) {
    // Upload the new profile picture and update the state
    await FirestoreServices().savePicture(uid, newImage);
    setState(() {
      _image = newImage;
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No image selected. Please select an image."),
      ),
    );
  }
}

  Future<void> deleteProfileImageAndUpdateState() async {
    await FirestoreServices().deleteUserImage(uid); // Call the delete function
    // Update the local state variable to reflect the deletion
    setState(() {
      imgUrl = null;
    });
  }

    void deleteProfileImageDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Profile Picture"),
          content: const Text("Are you sure you want to delete your profile picture?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteProfileImageAndUpdateState();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile picture deleted successfully",),backgroundColor: Colors.green,));
                Navigator.of(context).pop(); 
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void showProfilePictureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_image != null || imgUrl != null)
                ListTile(
                  title: const Text("View Profile Picture"),
                  onTap: () {
                    showProfileImageDialog(context);
                  },
                ),
              ListTile(
                title: const Text("Change Profile Picture"),
                onTap: () {
                  selectEditedImage();
                  Navigator.of(context).pop();
                },
              ),
              if (_image != null || imgUrl != null)
                ListTile(
                  title: const Text("Delete Profile Picture"),
                  onTap: ()  {
                     deleteProfileImageDialogue(context);
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget buildProfileImage() {
    if (_image != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(_image!),
      );
    } else if (imgUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(imgUrl!),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/profile.jpg'),
      );
    }
  }

  Future<String> getUsername() async {
    try {
      final uid = FirestoreServices.getUserId();
      if (uid != 'User not logged in') {
        final fetchedUsername = await FirestoreServices.getUsername(uid);
        if (fetchedUsername != null) {
          setState(() {
            username = fetchedUsername;
          });
          return fetchedUsername; // Return the updated username.
        } else {
          print('Username not found in Firestore');
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
    return username ?? 'Your Username'; // Return the current username if not updated.
  }

  void selectImage() async {
    Uint8List 
    img = await pickImage(ImageSource.gallery);
    await FirestoreServices().savePicture(uid, img);
    setState(() {
      _image = img;
    });
    }

  
void showProfileImageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Profile Picture"),
        content: imgUrl != null
            ? Image.network(imgUrl!)
            : const Text("No profile picture available"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

  Future<void> userWeightget() async {
    try {
      final uid = FirestoreServices.getUserId();
      if (uid != 'User not logged in') {
        final fetchedWeight =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .getUserWeight(uid);
        if (fetchedWeight != null) {
          setState(() {
            weight = fetchedWeight;
          });
        } else {
          print('Weight not found in Firestore');
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching weight: $e');
    }
  }

  Future<void> userHeightget() async {
    try {
      final uid = FirestoreServices.getUserId();
      if (uid != 'User not logged in') {
        final fetchedHeight =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .getUserHeight(uid);
        setState(() {
          height = fetchedHeight;
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching height: $e');
    }
  }

  Future<void> getEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          email = user.email;
        });
      }
    } catch (e) {
      print('Error retrieving email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight=MediaQuery.of(context).size.height;
        final double screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight *0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showProfilePictureDialog(context);
              },
              child: buildProfileImage(),
            ),
             SizedBox(height: screenHeight *0.03),
            buildRoundedListItem(
              Icons.verified_user_rounded,
              "Username",
              username ?? 'Your Username',
              Icons.edit,
              () {
                final uid = FirestoreServices.getUserId();
                editUsernameDialogue(context, uid, username ?? 'Your Username');
              },
            ),
            buildRoundedListItem(
              Icons.email,
              "Email Address",
              email ?? 'Your Email Address',
              null,
              () {},
            ),
            buildRoundedListItem(
              Icons.height,
              "Height",
              "${height.toString()} cm",
              Icons.edit,
              () {
                editAddHeight(context, uid, height.toString());
              },
            ),
            buildRoundedListItem(
              Icons.sports_baseball,
              "Weight",
              "${weight.toString()} kg",
              Icons.edit,
              () {
                editAddWeight(context, uid, weight.toString());
              },
            ),
            buildRoundedListItem(
              Icons.logout,
              "Logout",
              "Log Out",
              null,
              () {
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Do you want to log out"),
        actions: [
          MaterialButton(
            onPressed: () {
              signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text("Ok"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void editUsernameDialogue(
    BuildContext context,
    String uid,
    String currentName,
  ) {
    TextEditingController editUsernameController =
        TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Username"),
        content: TextField(
          controller: editUsernameController,
        ),
        actions: [
          MaterialButton(
            child: const Text("Save"),
            onPressed: () {
              String newUsername = editUsernameController.text.trim();
              if (newUsername.isNotEmpty) {
                Provider.of<WorkoutProvider>(context, listen: false)
                    .EditUsername(uid, newUsername);
                context.read<WorkoutProvider>().loadWorkouts(uid);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Saved Changes"),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Username name cannot be empty"),
                  ),
                );
              }
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void editAddHeight(BuildContext context, String uid, String currentHeight) {
    TextEditingController editheightController =
        TextEditingController(text: currentHeight);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Height"),
        content: TextField(
          controller: editheightController,
        ),
        actions: [
          MaterialButton(
            child: const Text("Save"),
            onPressed: () {
              String newHeight = editheightController.text.trim();

              if (newHeight.isNotEmpty) {
                Provider.of<WorkoutProvider>(context, listen: false)
                    .saveUserHeight(uid, int.parse(newHeight));
                userHeightget();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Saved Changes"),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Height cannot be empty"),
                  ),
                );
              }
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void editAddWeight(BuildContext context, String uid, String currentHeight) {
    TextEditingController editWeightController =
        TextEditingController(text: weight.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Weight"),
        content: TextField(
          controller: editWeightController,
        ),
        actions: [
          MaterialButton(
            child: const Text("Save"),
            onPressed: () {
              String newWeight = editWeightController.text.trim();

              if (newWeight.isNotEmpty) {
                Provider.of<WorkoutProvider>(context, listen: false)
                    .saveUserWeight(uid, int.parse(newWeight));
                userWeightget();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Saved Changes"),
                  ),
                );
                Navigator.pop(context);
                editWeightController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Weight cannot be empty"),
                  ),
                );
              }
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget buildRoundedListItem(
    IconData leadingIcon,
    String title,
    String subtitle,
    IconData? trailingIcon,
    onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: const Color.fromARGB(255, 43, 43, 43),
          leading: Icon(
            leadingIcon,
            color: Colors.white,
          ),
          trailing: trailingIcon != null
              ? Icon(trailingIcon, color: Colors.white)
              : null,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No image selected');
}
