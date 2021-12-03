import 'dart:io';

// import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/services/global_methods.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final TextEditingController _emailController =
      TextEditingController(text: '');
  late final TextEditingController _passController =
      TextEditingController(text: '');
  late final TextEditingController _fullNameController =
      TextEditingController(text: '');
  late final TextEditingController _positionCPController =
      TextEditingController(text: '');

  late final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionCPFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obsecure = true;
  final _signupFormKey = GlobalKey<FormState>();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String ?imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailController.dispose();
    _positionCPController.dispose();
    _fullNameController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormSignUp() async {
    final _isValid = _signupFormKey.currentState!.validate();
    if (_isValid) {
      if (imageFile == null) {
        GlobalMethod.showDialogError(
            error: 'Please upload an image', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passController.text.trim());

        final User? _user = _auth.currentUser;
        final _uid = _user!.uid;
        final ref=FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        imageUrl=await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'uid': _uid,
          'name': _fullNameController.text,
          'email': _emailController.text,
          'password': _passController.text,
          'imageUrl': imageUrl,
          'phoneNumber': _phoneNumberController.text,
          'positionInCompany': _positionCPController.text,
          'createAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showDialogError(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text('Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const TextSpan(text: '   '),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(context),
                        text: 'Login',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue.shade300,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _signupFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.name,
                              controller: _fullNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is missing';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(9),
                                child: Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? Image.network(
                                            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            imageFile!,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    _showImageDialog();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constant.backgroundColor,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        imageFile == null
                                            ? Icons.add_a_photo
                                            : Icons.edit_off_outlined,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _passFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_phoneNumberFocusNode),
                        controller: _passController,
                        obscureText: _obsecure,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password must be 7 character or more';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obsecure = !_obsecure;
                              });
                            },
                            child: Icon(
                              _obsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _phoneNumberFocusNode,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_positionCPFocusNode),
                        textInputAction: TextInputAction.done,
                        // onEditingComplete: () => _submitFormSignUp(),
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is missing';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          GlobalMethod.showPositionCompany(
                                onTap: (index) {
                              setState(() {
                                _positionCPController.text =
                                Constant.jobsList[index];
                              });
                              Navigator.pop(context);
                            },
                            context: context, size: size,);
                        },
                        child: TextFormField(
                          focusNode: _positionCPFocusNode,
                          enabled: false,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => _submitFormSignUp(),
                          keyboardType: TextInputType.name,
                          controller: _positionCPController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is missing';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration:  InputDecoration(
                            hintText: 'Position is the company',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Constant.backgroundColor),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                _isLoading
                    ? Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            color: Constant.backgroundColor,
                          ),
                        ),
                      )
                    : MaterialButton(
                        color: Constant.backgroundColor,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        onPressed: _submitFormSignUp,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.person_add,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _pickedImageFromGallery() async {
    PickedFile? pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
    setState(() {
      imageFile = File(pickedImage!.path);
    });
    Navigator.pop(context);
  }

  void _pickedImageFromCamera() async {
    PickedFile? pickedImage = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);
    setState(() {
      imageFile = File(pickedImage!.path);
    });
    Navigator.pop(context);
  }

  // void _cropImage(filepath)async{
  //   // File? CropperImage=await ImageCropper.
  // }
  // void _cropImageFile(filePath) async {
  //   File? croppedImage = await ImageCropper.cropImage(
  //       sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //     });
  //   }
  // }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Please choose an option',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _pickedImageFromCamera();
              },
              child: Row(
                children:  [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera,
                      color: Constant.backgroundColor,
                    ),
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(color: Constant.textColor),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _pickedImageFromGallery();
              },
              child: Row(
                children:  [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.photo,
                      color: Constant.backgroundColor,
                    ),
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(color:Constant.textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showTaskCategory({required BuildContext context, required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'Choose yor job',
                style: TextStyle(color:Constant.textColor),
              ),
              content: Container(
                width: size.width * 0.9,
                child: ListView.builder(
                    itemCount: Constant.jobsList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            setState(() {
                              _positionCPController.text =
                                  Constant.jobsList[index];
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Constant.backgroundColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Constant.jobsList[index],
                                  style: TextStyle(
                                      color: Constant.textColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )),
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel '),
                ),
              ],
            ));
  }
}
