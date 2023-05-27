import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/provider/get_requests_data.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/screens/requests/widgets/requestTile.dart';
import 'package:testapp/theme/colors.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  Map<String, dynamic> user = {};

  @override
  void initState() {
    user = ref.read(userProvider).userData;
    ref.read(requestprovider).getRequests(user['mobile']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Requests',
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
        child: Consumer(builder: (_, ref, __) {
          final data = ref.watch(requestprovider);
          if (data.status == RequestStatus.success) {
            return data.usermodel.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: data.usermodel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RequestTileScreen(
                            user: data.usermodel[index],
                            documentId: user['mobile'].toString());
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      'No Requests Found',
                      style: textStyle.headlineMedium!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                  );
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
