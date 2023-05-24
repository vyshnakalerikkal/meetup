import 'package:carousel_slider/carousel_slider.dart';
import 'package:testapp/config/routes.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/theme/images.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:testapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardScreen extends ConsumerStatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ConsumerState<OnboardScreen> {
  int _activeIndex = 0;
  final CarouselController _controller = CarouselController();

  final _slides = <SlideData>[
    SlideData(
      title: 'Find Your\nSpecial Someone',
      subTitle:
          'With our new exciting features',
      image: AppImages.onboardOne,
    ),
    SlideData(
      title: 'Interact Around\nThe World',
      subTitle:
          'Send direct messages to your matches',
      image: AppImages.onboardTwo,
    ),
  ];

  void _redirect() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          _carouselSliderWidget(textStyle, screenHeight, screenWidth),
          _forgroundWidgets(textStyle, screenHeight, screenWidth),
        ],
      ),
    );
  }

  Widget _carouselSliderWidget(
    TextTheme textStyle,
    double height,
    double width,
  ) {
    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: _slides.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.black,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.63),
                AppColors.primary,
                AppColors.onboardMaskColor,
              ],
              stops: const [
                0.2,
                0.6,
                0.7,
              ],
            ),
            image: DecorationImage(
              image: AssetImage(_slides[index].image),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: context.responsive(50),
              top: height * 0.51,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _slides[index].title,
                  style: textStyle.headlineMedium!.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.responsive(15)),
                Text(
                  _slides[index].subTitle,
                  style: textStyle.titleMedium!.copyWith(
                    fontSize: 15,
                    color: AppColors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: height,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }

  Widget _forgroundWidgets(TextTheme textStyle, double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: context.responsive(50)),
                    child: AnimatedSmoothIndicator(
                      activeIndex: _activeIndex,
                      count: _slides.length,
                      effect: ScaleEffect(
                        activeDotColor: AppColors.pageIndicator,
                        dotColor: AppColors.white,
                        dotHeight: context.responsive(6),
                        dotWidth: context.responsive(6),
                        spacing: context.responsive(6),
                      ),
                    ),
                  ),
                  if (_activeIndex < (_slides.length - 1))
                    _skipButton(textStyle),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(50),
              vertical: context.responsive(75),
            ),
            child: CustomButton.secondary(
              text: (_activeIndex < (_slides.length - 1))
                  ? 'Next'
                  : 'Get started',
              onTap: () {
                if (_activeIndex < (_slides.length - 1)) {
                  _controller.nextPage();
                }
                if (_activeIndex == (_slides.length - 1)) {
                  _redirect();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _skipButton(TextTheme textStyle) {
    return Padding(
      padding: EdgeInsets.only(right: context.responsive(50) - 8),
      child: InkWell(
        onTap: _redirect,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'SKIP',
            style: textStyle.titleSmall!.copyWith(
              fontSize: 15,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SlideData {
  SlideData({
    required this.title,
    required this.subTitle,
    required this.image,
  });
  final String title;
  final String subTitle;
  final String image;
}
