import 'package:cached_network_image/cached_network_image.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/provider/get_purchase_data.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/provider/update_request_data.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/utils/validators.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:testapp/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testapp/widgets/custom_snackbar.dart';
import '../../../theme/colors.dart';
import '../../../theme/images.dart';
import '../../../widgets/custom_textfield.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OtherProfileScreen extends ConsumerStatefulWidget {
  final UserModel userdetails;
  const OtherProfileScreen({Key? key, required this.userdetails})
      : super(key: key);

  @override
  ConsumerState<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends ConsumerState<OtherProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String requestStatus = '0';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callGetPurchaseApi();
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
              if (widget.userdetails.purchaseStatus == 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: context.responsive(34),
                    bottom: context.responsive(46),
                  ),
                  child: Consumer(builder: (_, ref, __) {
                    final res = ref.watch(purchaseprovider);

                    return CustomButton.primary(
                      text: 'Purchase',
                      isloading: res.purchaseStatus == PurchaseStatus.loading,
                      onTap: () {
                        _makePayment();
                      },
                    );
                  }),
                ),
              if (widget.userdetails.purchaseStatus == 1 &&
                  requestStatus == '0')
                Consumer(builder: (_, ref, __) {
                  final res = ref.watch(updateRequestProvider);

                  return Padding(
                    padding: EdgeInsets.only(
                      top: context.responsive(34),
                      bottom: context.responsive(46),
                    ),
                    child: CustomButton.primary(
                      text: 'Send Request to chat',
                      isloading: res.status == UpdateStatus.loading,
                      onTap: _requestToChat,
                    ),
                  );
                }),
              if (requestStatus == '1')
                Padding(
                  padding: EdgeInsets.only(
                    top: context.responsive(34),
                    bottom: context.responsive(46),
                  ),
                  child: Text(
                    'Chat Requested',
                    textAlign: TextAlign.center,
                    style: textStyle.headlineMedium!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              if (requestStatus == '2')
                Padding(
                  padding: EdgeInsets.only(
                    top: context.responsive(34),
                    bottom: context.responsive(46),
                  ),
                  child: CustomButton.primary(
                    text: 'Chat',
                    // isloading: res.status == UpdateStatus.loading,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.chat,
                          arguments: widget.userdetails);
                    },
                  ),
                ),
              _listener(),
              _updateRequestListener(),
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
            child: widget.userdetails.purchaseStatus == 0
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
                      imageUrl: widget.userdetails.image ?? '',
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

  callGetPurchaseApi() {
    Map<String, dynamic> map = ref.read(userProvider).userData;
    ref.read(purchaseprovider).getUserPurchaseRequestInfo(
        map['mobile'].toString(), widget.userdetails.mobile ?? '');
  }

  setValues() {
    _nameController.text = widget.userdetails.name ?? '';
    _genderController.text = widget.userdetails.gender ?? '';

    _locationController.text = widget.userdetails.location ?? '';
    _aboutMeController.text = widget.userdetails.about ?? '';
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

  callPostPurchaseDataApi() {
    Map<String, dynamic> map = ref.read(userProvider).userData;
    Map<String, String> data = {
      'documentId': map['mobile'].toString(),
      'purchasedDocumentId': widget.userdetails.mobile ?? ''
    };
    ref.read(purchaseprovider).postPurchaseData(data);
  }

  void _requestToChat() async {
    Map<String, dynamic> map = ref.read(userProvider).userData;
    Map<String, String> data = {
      'documentId': map['mobile'].toString(),
      'purchasedDocumentId': widget.userdetails.mobile.toString(),
      'requestStatus': '1',
      'currentStatus': '0'
    };

    ref.read(updateRequestProvider).updateData(data);
  }

  void _makePayment() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': 100,
      'name': 'Test.',
      'description': 'make Chat',
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    callPostPurchaseDataApi();
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        title + '\n' + message,
        textAlign: TextAlign.center,
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _listener() {
    ref.listen<PurchaseProvider>(purchaseprovider, (previous, next) {
      if (next.status == PurchaseDataStatus.success) {
        ref
            .read(purchaseprovider)
            .changePurchaseStatus(PurchaseDataStatus.initilize);
        ref.read(purchaseprovider).changeStatus(PurchaseStatus.initilize);
        ref.read(updateRequestProvider).changeStatus(UpdateStatus.initilize);
        Map<String, dynamic> purchaseMap = ref.read(purchaseprovider).userData;
        if (purchaseMap.isNotEmpty) {
          requestStatus = purchaseMap['requestStatus'].toString();
          widget.userdetails.purchaseStatus = 1;
          setState(() {});
        }
      }

      if (next.purchaseStatus == PurchaseStatus.success) {
        callGetPurchaseApi();
      }
    });
    return const SizedBox.shrink();
  }

  Widget _updateRequestListener() {
    ref.listen<UpdateRequestProvider>(updateRequestProvider, (previous, next) {
      if (next.status == UpdateStatus.success) {
        AppMessenger.of(context).success('Request Send Successfully');
        callGetPurchaseApi();
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
