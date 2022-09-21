library native_tools;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Platform {
  iOS,
  android,
}

class NativeDialog {
  final BuildContext context;
  final Widget? title;
  final Widget? content;
  final Color? backgroudColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final String? okLabel;
  final Function()? onOk;
  final bool? isShowCancel;
  final String? cancelLabel;
  final Function()? onCancel;
  final bool? barrierDismissible;
  const NativeDialog({
    required this.context,
    this.title,
    this.content,
    this.padding,
    this.backgroudColor,
    this.borderRadius,
    this.okLabel,
    this.onOk,
    this.isShowCancel,
    this.cancelLabel,
    this.onCancel,
    this.barrierDismissible,
  });

  Future<void> showAndroidDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: backgroudColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  borderRadius ?? 5.0,
                ),
              ),
            ),
            titlePadding: const EdgeInsets.all(0.0),
            title: Container(
              padding: padding ??
                  const EdgeInsets.only(
                    top: 25.0,
                    left: 25.0,
                    right: 25.0,
                  ),
              child: title ?? const SizedBox(),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: Container(
              padding: padding ?? const EdgeInsets.all(25.0),
              child: content,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(
              right: 15.0,
              bottom: 15.0,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelButton(platform: Platform.android),
                  _okButton(platform: Platform.android),
                ],
              ),
            ],
          );
        });
  }

  Future<void> showIOSDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: backgroudColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  borderRadius ?? 15.0,
                ),
              ),
            ),
            titlePadding: const EdgeInsets.all(0.0),
            title: Container(
              padding: padding ??
                  const EdgeInsets.only(
                    top: 25.0,
                    left: 25.0,
                    right: 25.0,
                  ),
              child: title ?? const SizedBox(),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: Container(
              padding: padding ?? const EdgeInsets.all(25.0),
              child: content,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.all(0.0),
            actions: [
              Column(
                children: [
                  _iOSButtonDivider(),
                  _okButton(platform: Platform.iOS),
                  (isShowCancel ?? true)
                      ? _iOSButtonDivider()
                      : const SizedBox(),
                  _cancelButton(platform: Platform.iOS),
                ],
              ),
            ],
          );
        });
  }

  Widget _cancelButton({required Platform platform}) {
    return (isShowCancel ?? true)
        ? InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: platform == Platform.iOS
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(
                        borderRadius ?? (platform == Platform.iOS ? 15.0 : 5.0),
                      ),
                      bottomRight: Radius.circular(
                        borderRadius ?? (platform == Platform.iOS ? 15.0 : 5.0),
                      ),
                    )
                  : const BorderRadius.all(
                      Radius.circular(2.5),
                    ),
            ),
            onTap: () {
              if (onCancel != null) {
                onCancel!();
              }
              Navigator.pop(context);
            },
            child: platform == Platform.iOS
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    width: MediaQuery.of(context).size.width,
                    child: _dialogButtonText(text: cancelLabel ?? 'Cancel'),
                  )
                : Container(
                    padding: const EdgeInsets.all(5.0),
                    child: _dialogButtonText(text: cancelLabel ?? 'Cancel'),
                  ),
          )
        : const SizedBox();
  }

  Widget _okButton({required Platform platform}) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: platform == Platform.iOS
            ? ((isShowCancel ?? true)
                ? BorderRadius.zero
                : BorderRadius.only(
                    bottomLeft: Radius.circular(
                      borderRadius ?? (platform == Platform.iOS ? 15.0 : 5.0),
                    ),
                    bottomRight: Radius.circular(
                      borderRadius ?? (platform == Platform.iOS ? 15.0 : 5.0),
                    ),
                  ))
            : const BorderRadius.all(
                Radius.circular(2.5),
              ),
      ),
      onTap: () {
        if (onOk != null) {
          onOk!();
        }
      },
      child: platform == Platform.iOS
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              width: MediaQuery.of(context).size.width,
              child: _dialogButtonText(text: okLabel ?? 'OK'),
            )
          : Container(
              padding: const EdgeInsets.all(5.0),
              child: _dialogButtonText(text: okLabel ?? 'OK'),
            ),
    );
  }

  Widget _iOSButtonDivider() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  Widget _dialogButtonText({required String text}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: CupertinoColors.activeBlue,
      ),
    );
  }
}

class AndroidToggle extends StatefulWidget {
  final bool? initValue;
  final Color? activeColor;
  final Color? activeBarColor;
  final Function(bool)? onChanged;
  const AndroidToggle({
    Key? key,
    this.initValue,
    this.activeColor,
    this.activeBarColor,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AndroidToggle> createState() => _AndroidToggleState();
}

class _AndroidToggleState extends State<AndroidToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _togglePositionController;
  late Animation<Alignment> _togglePositionAnimation;
  late Animation<Color?> _toggleBarColorAnimation;
  late Animation<Color?> _toggleColorAnimation;

  @override
  void initState() {
    _togglePositionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _togglePositionAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_togglePositionController);
    _toggleBarColorAnimation = ColorTween(
      begin: CupertinoColors.systemGrey2,
      end: widget.activeBarColor ?? Colors.green[800],
    ).animate(_togglePositionController);
    _toggleColorAnimation = ColorTween(
      begin: CupertinoColors.systemGrey5,
      end: widget.activeColor ?? Colors.green[300],
    ).animate(_togglePositionController);
    if (widget.initValue != null && widget.initValue == true) {
      _togglePositionController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _togglePositionController.dispose();
    super.dispose();
  }

  void activateAnimation() {
    setState(() {
      if (_togglePositionAnimation.isDismissed) {
        _togglePositionController.forward();
        if (widget.onChanged != null) {
          widget.onChanged!(true);
        }
      } else {
        _togglePositionController.reverse();
        if (widget.onChanged != null) {
          widget.onChanged!(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _togglePositionController,
        builder: (context, child) {
          return Stack(
            alignment: _togglePositionAnimation.value,
            children: [
              GestureDetector(
                onTap: () => activateAnimation(),
                child: AnimatedBuilder(
                    animation: _togglePositionController,
                    builder: (context, child) {
                      return Container(
                        width: screenSize.width * 0.09,
                        height: screenSize.width * 0.03,
                        decoration: BoxDecoration(
                          color: _toggleBarColorAnimation.value,
                          borderRadius: BorderRadius.all(
                            Radius.circular(screenSize.width * 0.02),
                          ),
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () => activateAnimation(),
                child: AnimatedBuilder(
                    animation: _togglePositionController,
                    builder: (context, child) {
                      return Container(
                        width: screenSize.width * 0.05,
                        height: screenSize.width * 0.05,
                        decoration: BoxDecoration(
                          color: _toggleColorAnimation.value,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }
}

class IOSToggle extends StatefulWidget {
  final bool? initValue;
  final Color? activeColor;
  final Color? activeBarColor;
  final Function(bool)? onChanged;
  const IOSToggle({
    Key? key,
    this.initValue,
    this.activeColor,
    this.activeBarColor,
    this.onChanged,
  }) : super(key: key);

  @override
  State<IOSToggle> createState() => _IOSToggleState();
}

class _IOSToggleState extends State<IOSToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _togglePositionController;
  late Animation<Alignment> _togglePositionAnimation;
  late Animation<Color?> _toggleBarColorAnimation;
  late Animation<Color?> _toggleColorAnimation;

  @override
  void initState() {
    _togglePositionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _togglePositionAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_togglePositionController);
    _toggleBarColorAnimation = ColorTween(
      begin: CupertinoColors.systemGrey2,
      end: widget.activeBarColor ?? CupertinoColors.activeGreen,
    ).animate(_togglePositionController);
    _toggleColorAnimation = ColorTween(
      begin: CupertinoColors.white,
      end: widget.activeColor ?? Colors.white,
    ).animate(_togglePositionController);
    if (widget.initValue != null && widget.initValue == true) {
      _togglePositionController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _togglePositionController.dispose();
    super.dispose();
  }

  void activateAnimation() {
    setState(() {
      if (_togglePositionAnimation.isDismissed) {
        _togglePositionController.forward();
        if (widget.onChanged != null) {
          widget.onChanged!(true);
        }
      } else {
        _togglePositionController.reverse();
        if (widget.onChanged != null) {
          widget.onChanged!(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _togglePositionController,
        builder: (context, child) {
          return Stack(
            alignment: _togglePositionAnimation.value,
            children: [
              GestureDetector(
                onTap: () => activateAnimation(),
                child: AnimatedBuilder(
                    animation: _togglePositionController,
                    builder: (context, child) {
                      return Container(
                        width: screenSize.width * 0.12,
                        height: screenSize.width * 0.07,
                        decoration: BoxDecoration(
                          color: _toggleBarColorAnimation.value,
                          borderRadius: BorderRadius.all(
                            Radius.circular(screenSize.width * 0.035),
                          ),
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () => activateAnimation(),
                child: AnimatedBuilder(
                    animation: _togglePositionController,
                    builder: (context, child) {
                      return Container(
                        margin: EdgeInsets.all(screenSize.width * 0.01),
                        width: screenSize.width * 0.06,
                        height: screenSize.width * 0.06,
                        decoration: BoxDecoration(
                          color: _toggleColorAnimation.value,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }
}
