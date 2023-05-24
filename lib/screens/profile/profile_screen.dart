import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/utils/validators.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:testapp/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/constants.dart';
import '../../../theme/colors.dart';
import '../../../theme/images.dart';
import '../../../widgets/custom_textfield.dart';

import '../../utils/helper_functions.dart';
import '../../widgets/custom_loading.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  File? _imageFile;
  String _selectedImage = '';
  String _image = '';
  String _imagePath = '';
  final List<String> _images = [];
  
  Map<String, String> _selectedCountry = {};

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    try {
      _imageFile = await compressFile(File(image.path));
      _selectedImage = _imageFile!.path;
      debugPrint(image.path);
      debugPrint(_imageFile!.path);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        AppMessenger.of(context).error('Error compressing image');
      }
    }
  }

  void _saveAndPublish() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'website': _websiteController.text,
        'whatsapp': _whatsappController.text,
        'job': _jobController.text,
        'organization': _companyController.text,
        'about': _aboutMeController.text,
      };
      if (_selectedImage.isNotEmpty) {
        bool validateValues = _images.any((element) => element == 'image');
        if (!validateValues) {
          _images.add('image');
        }
        data['image'] = _selectedImage;
      }
    }
  }

  // void _setValues(User userDetails) {
  //   setState(() {
  //     _nameController.text = userDetails.name ?? '';
  //     _jobController.text = userDetails.job ?? '';
  //     _companyController.text = userDetails.organization ?? '';
  //     _aboutMeController.text = userDetails.about ?? '';
  //     _emailController.text = userDetails.email ?? '';
  //     _websiteController.text = userDetails.website ?? '';
  //     _phoneController.text =
  //         '${userDetails.countryCode} ${userDetails.mobile ?? ''}';
  //     _whatsappController.text = userDetails.whatsapp ?? '';
  //     _imagePath = userDetails.imagePath ?? '';
  //     _image = '${userDetails.imagePath}${userDetails.image}';
  //     _socialLinks = userDetails.socialLinks ?? [];
  //     _links = userDetails.links ?? [];
  //   });
  // }

  // void _redirect(String? url) async {
  //   await secureStorage.write(key: 'IS_USER_SET', value: 'true');
  //   if (context.mounted) {
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       AppRoutes.profile,
  //       (route) => false,
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
             
            }
          },
          child: Icon(
            Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          'Profile',
          style: textStyle.headlineSmall!.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.screenTitle,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsive(22)),
          child: ListView(
            children: [
             
                     Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _profilePicture(),
                        _formFields(textStyle),
                       
                      ],
                    
                 
               
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: context.responsive(34),
                  bottom: context.responsive(46),
                ),
                child: CustomButton.primary(
                      text: 'Save',
                      isloading: false,
                      onTap: _saveAndPublish,
                    ),
                  
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _profilePicture() {
    return Container(
      height: context.responsive(200),
      margin: EdgeInsets.only(
        // top: context.responsive(15),
        bottom: context.responsive(45),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: context.responsive(140),
            width: context.responsive(140),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: _imageFile != null
                ? Container(
                    height: context.responsive(136),
                    width: context.responsive(136),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.file(_imageFile!, fit: BoxFit.fill),
                  )
                : _image.isEmpty
                    ? Container(
                        height: context.responsive(134),
                        width: context.responsive(134),
                        decoration: const BoxDecoration(
                          color: AppColors.lightGray,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(AppImages.avatar),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        clipBehavior: Clip.hardEdge,
                        height: context.responsive(136),
                        width: context.responsive(136),
                        child: CachedNetworkImage(
                          imageUrl: _imagePath,
                          height: context.responsive(136),
                          width: context.responsive(136),
                          errorWidget: (context, url, error) => Container(
                            height: context.responsive(136),
                            width: context.responsive(136),
                            decoration: const BoxDecoration(
                              color: AppColors.lightGray,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(AppImages.avatar),
                          ),
                          progressIndicatorBuilder: (context, url, progress) =>
                              const Center(
                            child: CustomLoadingWidget(
                              strokeWidth: 3,
                              color: AppColors.primary,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
          ),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: context.responsive(70),
              backgroundColor: Colors.black.withOpacity(0.45),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, TextTheme textStyle) {
    return Text(
      text,
      style: textStyle.bodySmall!.copyWith(
        fontSize: 11,
        color: AppColors.formFieldLabel,
      ),
    );
  }

  Widget _formFields(TextTheme textStyle) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Your Name', textStyle),
          CustomTextfield(
            hintText: 'Your name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: requiredValidator(),
            onChanged: (value) {},
          ),
          SizedBox(height: context.responsive(25)),
         
         
          _fieldLabel('About me', textStyle),
          CustomTextfield(
            hintText: 'Type something about yourself',
            controller: _aboutMeController,
            keyboardType: TextInputType.multiline,
            minLine: 2,
            maxLines: 5,
            onChanged: (value) {},
          ),
          SizedBox(height: context.responsive(25)),
          _fieldLabel('Email id', textStyle),
          CustomTextfield(
            hintText: 'Enter your email id',
            controller: _emailController,
            keyboardType: TextInputType.multiline,
            validator: MultiValidator([
              requiredValidator(),
              emailValidator,
            ]),
            onChanged: (value) {},
          ),
          
          SizedBox(height: context.responsive(25)),
          _fieldLabel('Phone number', textStyle),
          CustomTextfield(
            hintText: 'Enter your phone number',
            controller: _phoneController,
            readOnly: true,
            keyboardType: TextInputType.phone,
            validator: requiredValidator(),
            onChanged: (value) {},
          ),
          
          SizedBox(height: context.responsive(25)),
          
        ],
      ),
    );
  }

  
}
