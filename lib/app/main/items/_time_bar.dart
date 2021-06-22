import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/model/weather.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/utils/display.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/theme/theme.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';

import '../../../main.dart';

class TimeBar extends StatefulWidget {

  TimeBar(this.weather, this.timezone): super();

  final Weather weather;
  final String timezone;

  @override
  State<StatefulWidget> createState() {
    return _TimeBarState();
  }
}

class _TimeBarState extends State<TimeBar> {

  Timer timer;
  String _time = '';

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _ensureTime(bool init) {
    if (widget.timezone == currentTimezone) {
      _time = '';
      return;
    }

    String oldTime = _time;
    String newTime = Base.getTime(
        getCurrentDateTime(widget.timezone),
        isTwelveHourFormat(context)
    );
    if (oldTime == newTime) {
      return;
    }

    if (init) {
      _time = newTime;
    } else {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureTime(true);
    timer = Timer.periodic(Duration(seconds: 15), (_) {
      if (mounted) {
        _ensureTime(false);
      }
    });

    TextStyle style = Theme.of(context).textTheme.subtitle2;

    return PlatformInkWell(
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.weather.alertList.length == 0 ? PlatformIconButton(
            materialIcon: Icon(Icons.access_time,
              color: style.color,
            ),
            cupertinoIcon: Icon(CupertinoIcons.time,
              color: style.color,
            ),
            padding: EdgeInsets.all(normalMargin),
          ) : PlatformIconButton(
            materialIcon: Icon(Icons.error_outline,
              color: style.color,
            ),
            cupertinoIcon: Icon(CupertinoIcons.exclamationmark_circle,
              color: style.color,
            ),
            padding: EdgeInsets.all(normalMargin),
            onPressed: () {
              // todo: show alerts page.
            },
          ),
          Flexible(
            child: isEmptyString(_time) ? Text(
              '${S.of(context).refresh_at} ${
                  Base.getTime(widget.weather.base.updateDate, isTwelveHourFormat(context))
              }',
              style: Theme.of(context).textTheme.subtitle2,
            ) :
            Padding(
                padding: EdgeInsets.only(
                  top: normalMargin,
                  bottom: normalMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${S.of(context).refresh_at} ${
                          Base.getTime(
                              widget.weather.base.updateDate,
                              isTwelveHourFormat(context)
                          )
                      }',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),Text(
                      '${S.of(context).local_time}: $_time',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
            ),
          ),
        ],
      ),
      onTap: () {
        // todo: management.
      },
    );
  }
}