import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/provider/get_user_data.dart';
import 'package:testapp/provider/provider.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/theme/images.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, dynamic> user = {};

  @override
  void initState() {
    user = ref.read(userProvider).userData;
    ref.read(userProvider).getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Hi,',
              style: textStyle.headlineMedium!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user['name'].toString(),
              style: textStyle.titleMedium!.copyWith(
                fontSize: 16,
                color: AppColors.primary.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 4),
            Consumer(builder: (_, ref, __) {
              final data = ref.watch(userProvider);
              if (data.userliststatus == UserListStatus.success) {
                return Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: data.usermodel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector (
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes .othersProfile,arguments: data.usermodel[index]);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: data.usermodel[index].image == null
                                    ? AppColors.lightGray
                                    : Colors.transparent,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: data.usermodel[index].image == null
                                  ? SvgPicture.asset(AppImages.avatar)
                                  : CachedNetworkImage(
                                      imageUrl: data.usermodel[index].image ?? '',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              data.usermodel[index].name ?? '',
                              style: textStyle.titleMedium!.copyWith(
                                fontSize: 14,
                                color: AppColors.primary.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}
