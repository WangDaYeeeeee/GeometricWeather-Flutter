import 'package:flutter/widgets.dart';
import 'package:geometricweather_flutter/app/common/basic/widgets.dart';
import 'package:geometricweather_flutter/app/main/view_models.dart';

class ManagementPage extends GeoStatefulWidget {

  ManagementPage({
    Key key,
    MainViewModel viewModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManagementPageState();
  }
}

class _ManagementPageState extends GeoState<ManagementPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}