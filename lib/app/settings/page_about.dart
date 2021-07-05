import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/common/ui/anim_list/slide_anim_list.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/app_bar.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/ink_well.dart';
import 'package:geometricweather_flutter/app/common/ui/platform/scaffold.dart';
import 'package:geometricweather_flutter/app/common/utils/platform.dart';
import 'package:geometricweather_flutter/app/common/utils/system_services.dart';
import 'package:geometricweather_flutter/generated/l10n.dart';
import 'package:geometricweather_flutter/main.dart';

const _ITEM_ANIM_DURATION = 300;

class _TranslatorItem extends StatelessWidget {

  const _TranslatorItem(
      this.title,
      this.subtitle,
      this.country,
      this.email,
      this.textTheme,
      this.sysServices,
      { Key key }): super(key: key);

  final String title;
  final String subtitle;
  final String country;
  final bool email;

  final TextTheme textTheme;
  final SystemServices sysServices;

  @override
  Widget build(BuildContext context) {
    return PlatformInkWell(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title + ' ' + _getEmojiFlag(country),
              style: textTheme.subtitle2,
            ),
            Text(subtitle,
              style: textTheme.caption,
            )
          ],
        ),
      ),
      onTap: () {
        if (email) {
          sysServices.sendEmail(subtitle);
        } else {
          sysServices.launchUrl(subtitle);
        }
      },
    );
  }

  String _getEmojiFlag(String country) {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}

class AboutPage extends GeoStatefulWidget {

  AboutPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends GeoState<AboutPage> {

  bool _showList = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(milliseconds: 400), () {
      setState(() {
        _showList = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SystemServices sysServices = locator<SystemServices>();

    final itemList = <Widget>[
      // header.
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset('images/ic_launcher.png',
                width: 72.0,
              ),
            ),
            Text(S.of(context).geometric_weather,
              style: textTheme.headline6,
            ),
            Text(versionName,
              style: textTheme.subtitle2,
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0))
          ]
      ),
      Divider(height: 1.0),
      // overview.
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(S.of(context).about_app,
          style: textTheme.caption,
        ),
      ),
      PlatformInkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.child_care),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(S.of(context).gitHub,
                  style: textTheme.subtitle2,
                ),
              )
            ],
          ),
        ),
        onTap: () => sysServices.launchUrl('https://github.com/WangDaYeeeeee'),
      ),
      PlatformInkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.email_outlined),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(S.of(context).email,
                  style: textTheme.subtitle2,
                ),
              )
            ],
          ),
        ),
        onTap: () => sysServices.sendEmail('wangdayeeeeee@gmail.com'),
      ),
      Divider(height: 1.0),
      // donation.
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(S.of(context).donate,
          style: textTheme.caption,
        ),
      ),
      PlatformInkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(S.of(context).wechat,
            style: textTheme.subtitle2,
          ),
        ),
        onTap: () async {
          await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Image.asset('images/donate_wechat.png')
                );
              }
          );
        },
      ),
      PlatformInkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(S.of(context).alipay,
            style: textTheme.subtitle2,
          ),
        ),
        onTap: () async {
          await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    child: Image.asset('images/donate_alipay.png')
                );
              }
          );
        },
      ),
      Divider(height: 1.0),
      // translators.
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(S.of(context).translator,
          style: textTheme.caption,
        ),
      ),
      _TranslatorItem('Mehmet Saygin Yilmaz', 'memcos@gmail.com', 'TR',
          true, textTheme, sysServices),
      _TranslatorItem('Ali D.', 'siyaha@gmail.com', 'TR',
          true, textTheme, sysServices),
      _TranslatorItem('benjamin Tourrel', 'polo_naref@hotmail.fr', 'FR',
          true, textTheme, sysServices),
      _TranslatorItem('Roman Adadurov', 'orelars53@gmail.com', 'RU',
          true, textTheme, sysServices),
      _TranslatorItem('Denio', 'deniosens@yandex.ru', 'RU',
          true, textTheme, sysServices),
      _TranslatorItem('Ken Berns', 'ken.berns@yahoo.de', 'DE',
          true, textTheme, sysServices),
      _TranslatorItem('Milan Andrejić', 'amikia@hotmail.com', 'SR',
          true, textTheme, sysServices),
      _TranslatorItem('Miguel Torrijos', 'migueltg352340@gmail.com', 'ES',
          true, textTheme, sysServices),
      _TranslatorItem('juliomartinezrodenas', 'https://github.com/juliomartinezrodenas', 'ES',
          false, textTheme, sysServices),
      _TranslatorItem('Andrea Carulli', 'rctandrew100@gmail.com', 'IT',
          true, textTheme, sysServices),
      _TranslatorItem('Jurre Tas', 'jurretas@gmail.com', 'NL',
          true, textTheme, sysServices),
      _TranslatorItem('Jörg Meinhardt', 'jorime@web.de', 'DE',
          true, textTheme, sysServices),
      _TranslatorItem('Olivér Paróczai', 'oliver.paroczai@gmail.com', 'HU',
          true, textTheme, sysServices),
      _TranslatorItem('Fabio Raitz', 'fabioraitz@outlook.com', 'BR',
          true, textTheme, sysServices),
      _TranslatorItem('Gregor', 'glakner@gmail.com', 'SI',
          true, textTheme, sysServices),
      _TranslatorItem('Paróczai Olivér', 'https://github.com/OliverParoczai', 'HU',
          false, textTheme, sysServices),
      _TranslatorItem('sodqe muhammad', 'sodqe.younes@gmail.com', 'AR',
          true, textTheme, sysServices),
      _TranslatorItem('Thorsten Eckerlein', 'thorsten.eckerlein@gmx.de', 'DE',
          true, textTheme, sysServices),
      _TranslatorItem('Jiří Král', 'jirkakral978@gmail.com', 'CZ',
          true, textTheme, sysServices),
      _TranslatorItem('Kamil', 'invisiblehype@gmail.com', 'PL',
          true, textTheme, sysServices),
      _TranslatorItem('Μιχάλης Καζώνης', 'istrios@gmail.com', 'GR',
          true, textTheme, sysServices),
      _TranslatorItem('이서경', 'ng0972@naver.com', 'KR',
          true, textTheme, sysServices),
      _TranslatorItem('rikupin1105', 'https://github.com/rikupin1105', 'JP',
          false, textTheme, sysServices),
      _TranslatorItem('Julien Papasian', 'https://github.com/papjul', 'FR',
          false, textTheme, sysServices),
      _TranslatorItem('alexandru l', 'sandu.lulu@gmail.com', 'RO',
          true, textTheme, sysServices)
    ];

    return GeoPlatformScaffold(
      appBar: GeoPlatformAppBar(context,
        leading: GeoPlatformAppBarBackLeading(context,
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        title: GeoPlatformAppBarTitle(context, S.of(context).action_about),
      ),
      body: Container(
        alignment: AlignmentDirectional.topCenter,
        child: _showList ? SlideAnimatedListView(
          itemCount: itemList.length,
          builder: (BuildContext context, int index) {
            return SizedBox(
              width: double.infinity,
              child: itemList[index],
            );
          },
          baseItemAnimationDuration: _ITEM_ANIM_DURATION,
          initItemOffsetX: GeoPlatform.isCupertinoStyle ? 128.0 : 0.0,
          initItemOffsetY: GeoPlatform.isCupertinoStyle ? 0.0 : 128.0,
        ) : null,
      ),
    );
  }
}