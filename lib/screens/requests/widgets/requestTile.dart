import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testapp/model/userModel.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/provider/update_request_data.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/theme/images.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:testapp/widgets/custom_snackbar.dart';

class RequestTileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final String documentId;
  const RequestTileScreen(
      {super.key, required this.user, required this.documentId});

  @override
  ConsumerState<RequestTileScreen> createState() => _RequestTileScreenState();
}

class _RequestTileScreenState extends ConsumerState<RequestTileScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      children: [
        ListTile(
          title: Text(
            '${widget.user.name} send a request ',
            style: textStyle.titleMedium!.copyWith(
              fontSize: 16,
              color: AppColors.primary.withOpacity(0.75),
            ),
          ),
          subtitle: Consumer(builder: (_, ref, __) {
            final res = ref.watch(updateRequestProvider);

            return CustomButton.secondary(
              text: 'Accept',
              onTap: () {
                Map<String, String> map = {
                  'documentId': widget.user.mobile.toString(),
                  'purchasedDocumentId': widget.documentId,
                  'requestStatus': '2',
                  'currentStatus': '1'
                };

                ref.read(updateRequestProvider).updateData(map);
              },
              isloading: res.status == UpdateStatus.loading,
              color: AppColors.primary,
              fontColor: AppColors.white,
              fontSize: 16,
              height: 30,
            );
          }),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.user.image == null
                  ? AppColors.lightGray
                  : Colors.transparent,
            ),
            clipBehavior: Clip.hardEdge,
            child: widget.user.image == null
                ? SvgPicture.asset(AppImages.avatar)
                : CachedNetworkImage(
                    imageUrl: widget.user.image ?? '',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        _listener(),
      ],
    );
  }

  Widget _listener() {
    ref.listen<UpdateRequestProvider>(updateRequestProvider, (previous, next) {
      if (next.status == UpdateStatus.success) {
        AppMessenger.of(context).success('Accepted Successfully');
        ref.read(requestprovider).getRequests(widget.documentId);
      } else if ((next.status == UpdateStatus.error)) {
        AppMessenger.of(context).error(next.message);
      }
    });
    return const SizedBox.shrink();
  }
}
