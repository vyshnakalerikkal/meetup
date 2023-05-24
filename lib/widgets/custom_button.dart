import 'dart:io';

import 'package:testapp/theme/styles.dart';
import 'package:testapp/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton.primary({
    Key? key,
    this.width,
    this.height = 50.0,
    this.hPadding = 0,
    this.vPadding = 0,
    this.color = AppColors.primary,
    this.fontColor = AppColors.white,
    required this.text,
    required this.onTap,
    this.showStartUpAnimation,
    this.isloading = false,
    this.borderRadius = 8,
    this.fontSize = 20,
    this.iconSize = 20,
    this.contentPdding = 10,
    this.leading = '',
    this.trailing = '',
    this.overrideLoadingButtonSize = false,
    this.isDisabled = false,
  })  : isSecondary = false,
        isOutlined = false,
        super(key: key);

  const CustomButton.secondary({
    Key? key,
    this.width,
    this.height,
    this.hPadding = 0,
    this.vPadding = 0,
    this.color = AppColors.white,
    this.fontColor = AppColors.primary,
    required this.text,
    required this.onTap,
    this.showStartUpAnimation,
    this.isloading = false,
    this.fontSize = 20,
    this.iconSize = 24,
    this.borderRadius = 8,
    this.leading = '',
    this.trailing = '',
    this.overrideLoadingButtonSize = false,
    this.isDisabled = false,
  })  : isSecondary = true,
        isOutlined = false,
        contentPdding = 10,
        super(key: key);

  const CustomButton.outlined({
    Key? key,
    this.width,
    this.height,
    this.hPadding = 0,
    this.vPadding = 0,
    this.color = AppColors.primary,
    required this.text,
    required this.onTap,
    this.showStartUpAnimation,
    this.isloading = false,
    this.borderRadius = 8,
    this.fontSize = 20,
    this.leading = '',
    this.trailing = '',
    this.overrideLoadingButtonSize = false,
    this.isDisabled = false,
  })  : isSecondary = false,
        isOutlined = true,
        fontColor = AppColors.primary,
        iconSize = 24,
        contentPdding = 10,
        super(key: key);

  final double? width;
  final double? height;
  final double vPadding;
  final double hPadding;
  final double borderRadius;
  final bool isSecondary;
  final bool isOutlined;
  final Color? color;
  final String text;
  final VoidCallback? onTap;
  final bool? showStartUpAnimation;
  final bool isloading;
  final bool overrideLoadingButtonSize;
  final double fontSize;
  final double iconSize;
  final double contentPdding;
  final bool isDisabled;
  final Color fontColor;
  final String leading;
  final String trailing;

  @override
  State<CustomButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scale;
  late AnimationController _controller;
  final bool _isIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    showDefaultAnimation();
  }

  void showDefaultAnimation() {
    if (widget.showStartUpAnimation == true) {
      _scale = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward().whenComplete(
            () => _scale = Tween<double>(begin: 1.0, end: 0.9).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
          );
    } else {
      _scale = Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _tapDown(bool autoAnimate) {
    if (autoAnimate) {
      _controller.forward().whenComplete(_tapUp);
    } else {
      _controller.forward();
    }
  }

  void _tapUp() {
    _controller.reverse().whenComplete(() => widget.onTap!());
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: GestureDetector(
        onTapUp: (_) => _tapDown(false),
        onTapDown: (_) => _tapDown(false),
        onTapCancel: _tapUp,
        onTap: () {
          _tapDown(true);
        },
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: widget.width,
            height: widget.height ?? 55,
            margin: EdgeInsets.symmetric(
              horizontal: context.responsive(widget.hPadding),
              vertical: context.responsive(widget.vPadding),
            ),
            decoration: BoxDecoration(
              // gradient: (!widget.isOutlined &&
              //         !widget.isSecondary &&
              //         !widget.isDisabled)
              //     ? AppColors.buttonGradient
              //     : null,
              color: widget.isDisabled
                  ? AppColors.disabled
                  : widget.isOutlined
                      ? null
                      : widget.color,
              border: widget.isOutlined
                  ? Border.all(
                      color: widget.isDisabled
                          ? AppColors.disabled
                          : widget.color ?? AppColors.primary,
                    )
                  : null,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            alignment: Alignment.center,
            child: widget.isloading
                ? Padding(
                    padding: EdgeInsets.all(
                      widget.overrideLoadingButtonSize ? 6 : 16,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: _isIOS
                          ? CupertinoActivityIndicator(
                              color: widget.isOutlined
                                  ? AppColors.primary
                                  : widget.fontColor,
                            )
                          : CircularProgressIndicator(
                              color: widget.isOutlined
                                  ? AppColors.primary
                                  : widget.fontColor,
                              strokeWidth: 2,
                            ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leading.isNotEmpty) ...[
                        SvgPicture.asset(
                          widget.leading,
                          // color: AppColors.white,
                          height: widget.iconSize,
                        ),
                        SizedBox(
                          width: widget.contentPdding,
                        ),
                      ],
                      Text(
                        widget.text,
                        style: widget.isOutlined
                            ? widget.isDisabled
                                ? textStyle.buttonStyle.copyWith(
                                    color: AppColors.white,
                                    fontSize: widget.fontSize,
                                  )
                                : textStyle.buttonStyle.copyWith(
                                    color: widget.color,
                                    fontSize: widget.fontSize,
                                  )
                            : textStyle.buttonStyle.copyWith(
                                fontSize: widget.fontSize,
                                color: widget.fontColor,
                              ),
                      ),
                      if (widget.trailing.isNotEmpty) ...[
                        SvgPicture.asset(
                          widget.trailing,
                          // color: AppColors.white,
                          height: widget.iconSize,
                        ),
                        SizedBox(
                          width: widget.contentPdding,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
