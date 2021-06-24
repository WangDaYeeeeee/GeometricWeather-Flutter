// @dart=2.12

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';

import 'model.dart';

const SHOW_ANIM_DURATION = 500;
const HIDE_ANIM_DURATION = 350;

enum SnackBarStatus {
  executingShowAnimation,
  showing,
  executingHideAnimation,
  hiding,
}

class SnackBarView extends StatefulWidget {

  SnackBarView({
    Key? key,
    required this.model,
  }): super(key: key);

  final SnackBarModel model;

  @override
  State<StatefulWidget> createState() {
    return SnackBarViewState();
  }
}

class SnackBarViewState extends State<SnackBarView>
    with TickerProviderStateMixin {

  Widget? child;

  SnackBarStatus _status = SnackBarStatus.hiding;

  AnimationController? _animController;
  Animation<double>? _opacityAnim;
  Animation<Offset>? _positionAnim;
  Animation<double>? _scaleAnim;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        duration: Duration(
          milliseconds: SHOW_ANIM_DURATION,
        ),
        vsync: this
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _status = SnackBarStatus.showing;
        timer = new Timer(Duration(milliseconds: widget.model.duration), () {
          hide();
        });
      }
    });

    _opacityAnim = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(
        CurvedAnimation(
          parent: _animController!,
          curve: Curves.ease,
        )
    );
    _positionAnim = Tween(
        begin: Offset(0.0, 120.0),
        end: Offset.zero
    ).animate(
        CurvedAnimation(
          parent: _animController!,
          curve: Curves.easeOutBack,
        )
    );
    _scaleAnim = Tween(
        begin: 1.1,
        end: 1.0
    ).animate(
        CurvedAnimation(
          parent: _animController!,
          curve: Curves.ease,
        )
    );

    _status = SnackBarStatus.executingShowAnimation;
    _animController!.forward();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SnackBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      child = null;
    });
  }

  SnackBarStatus get status => _status;

  void hide() {
    if (_status == SnackBarStatus.executingHideAnimation
        || _status == SnackBarStatus.hiding) {
      return;
    }

    _animController?.dispose();

    setState(() {
      _animController = AnimationController(
          duration: Duration(
            milliseconds: HIDE_ANIM_DURATION,
          ),
          vsync: this
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _status = SnackBarStatus.hiding;
          widget.model.dismissCallback?.call();
        }
      });

      _opacityAnim = Tween(
          begin: _opacityAnim?.value ?? 1.0,
          end: 0.0
      ).animate(
          CurvedAnimation(
            parent: _animController!,
            curve: Curves.ease,
          )
      );
      _positionAnim = Tween(
          begin: _positionAnim?.value ?? Offset.zero,
          end: Offset(0.0, 120.0),
      ).animate(
          CurvedAnimation(
            parent: _animController!,
            curve: Curves.easeInOutQuint,
          )
      );

      _status = SnackBarStatus.executingHideAnimation;
      _animController!.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      final theme = Theme.of(context);

      List<Widget> contents = [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(normalMargin),
            child: Text(widget.model.content,
              style: theme.textTheme.bodyText2
            ),
          ),
        )
      ];
      if (!isEmptyString(widget.model.action)
          && widget.model.actionCallback != null) {
        contents.add(
          Padding(
            padding: EdgeInsets.only(
              top: littleMargin,
              bottom: littleMargin,
              right: normalMargin,
            ),
            child: ElevatedButton(
              child: PlatformText(widget.model.action!),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    ThemeColors.colorAlert
                ),
                foregroundColor: MaterialStateProperty.all(
                    Colors.black
                ),
              ),
              onPressed: () {
                widget.model.actionCallback?.call();
              },
            ),
          )
        );
      }

      child = getTabletAdaptiveWidthBox(
        context,
        SafeArea(
          child: Card(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.dividerColor, theme.backgroundColor],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 4.0,
                  bottom: 4.0,
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: contents,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(cardRadius)
                )
            ),
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(normalMargin),
          ),
        ),
      );
    }

    return AnimatedBuilder(
        animation: _animController!,
        child: child,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _opacityAnim?.value ?? 1.0,
            child: Transform.translate(
              offset: _positionAnim?.value ?? Offset.zero,
              child: Transform.scale(
                scale: _scaleAnim?.value ?? 1.0,
                child: child,
              ),
            ),
          );
        }
    );
  }
}