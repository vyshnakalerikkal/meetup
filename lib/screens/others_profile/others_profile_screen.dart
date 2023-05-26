import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/provider/update_user_data.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/utils/validators.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:testapp/widgets/custom_loading.dart';
import 'package:testapp/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/colors.dart';
import '../../../theme/images.dart';
import '../../../widgets/custom_textfield.dart';
import '../../utils/helper_functions.dart';

class OtherProfileScreen extends ConsumerStatefulWidget {
  final UserModel userdetails;
  const OtherProfileScreen({Key? key,required this.userdetails}) : super(key: key);

  @override
  ConsumerState<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends ConsumerState<OtherProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _imgString = '';

  File? _imageFile;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    try {
      _imageFile = await compressFile(File(image.path));

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        AppMessenger.of(context).error('Error compressing image');
      }
    }
  }

  void _update() async {

   
  }

  @override
  void initState() {
    super.initState();
    setValues();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
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
                child: Consumer(builder: (_, ref, __) {
                  final res = ref.watch(updateUserProvider);

                  return CustomButton.primary(
                    text: 'Purchase',
                    isloading: res.status == UpdateStatus.loading,
                    onTap: _update,
                  );
                }),
              ),
              CustomButton.primary(
                    text: 'Send Rrquest to chat',
                    // isloading: res.status == UpdateStatus.loading,
                    onTap: _update,
                  ),
                  CustomButton.primary(
                    text: 'Chat',
                    // isloading: res.status == UpdateStatus.loading,
                    onTap: _update,
                  ),
              _listener(),
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
                : _imgString.isEmpty
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
                          imageUrl: _imgString,
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
          
        ],
      ),
    );
  }

  setValues() {
    _nameController.text = widget.userdetails.name??'';
    _genderController.text = widget.userdetails.gender??'';
    
    _locationController.text = widget.userdetails.location??'';
     _aboutMeController.text = widget.userdetails.about??'';
   
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

  Widget _listener() {
    ref.listen<UpdateUserProvider>(updateUserProvider, (previous, next) {
      if (next.status == UpdateStatus.success) {

      } else if ((next.status == UpdateStatus.error)) {
        AppMessenger.of(context).error(next.message);
      }
    });
    return const SizedBox.shrink();
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
            enabled: false,
          ),
          SizedBox(height: context.responsive(25)),
          _fieldLabel('Gender', textStyle),
          CustomTextfield(
            hintText: 'Gender',
            controller: _genderController,
            keyboardType: TextInputType.name,
            validator: requiredValidator(),
            onChanged: (value) {},
            enabled: false,
          ),
          SizedBox(height: context.responsive(25)),
          
          _fieldLabel('Location', textStyle),
          CustomTextfield(
            hintText: 'location',
            controller: _locationController,
            keyboardType: TextInputType.name,
            validator: requiredValidator(),
            onChanged: (value) {},
            enabled: false,
          ),
          SizedBox(height: context.responsive(25)),
          _fieldLabel('About me', textStyle),
          CustomTextfield(
            hintText: 'Type something about yourself',
            controller: _aboutMeController,
            keyboardType: TextInputType.multiline,
            minLine: 2,
            maxLines: 5,
            enabled: false,
            onChanged: (value) {},
          ),
          SizedBox(height: context.responsive(25)),
        ],
      ),
    );
  }
}
