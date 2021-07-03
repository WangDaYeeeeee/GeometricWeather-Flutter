// @dart=2.12

import 'package:flutter/src/widgets/framework.dart';
import 'package:geometricweather_flutter/app/common/basic/model/location.dart';
import 'package:geometricweather_flutter/app/common/basic/model/resources.dart';
import 'package:geometricweather_flutter/app/common/basic/mvvm.dart';
import 'package:geometricweather_flutter/app/common/utils/logger.dart';
import 'package:geometricweather_flutter/app/common/utils/text.dart';
import 'package:geometricweather_flutter/app/updater/models.dart';
import 'package:geometricweather_flutter/app/updater/weather/helper.dart';

class _SearchRepository {

  static DisposableFuture<List<Location>> requestLocations(String query) =>
      WeatherHelper().requestLocations(query);
}

class SearchViewModel extends ViewModel {

  final LiveData<ListResource<Location>> results = LiveData(
    ListResource(List<Location>.empty())
  );
  final LiveData<bool> loading = LiveData(false);

  String query = '';

  Disposable? _disposable;

  @override
  void dispose(BuildContext context) {
    _disposeRequest();
  }

  void _disposeRequest() {
    loading.value = false;

    _disposable?.dispose();
    _disposable = null;
  }

  void search(String q) {
    if (loading.value || _disposable != null || isEmptyString(q) || query == q) {
      return;
    }
    query = q;
    loading.value = true;

    final df = _SearchRepository.requestLocations(q);
    _disposable = df.disposable;

    df.future.then((value) {
      results.value = ListResource(value);
    }).onError((error, stackTrace) {
      testLog(error.toString());
      testLog(stackTrace.toString());
      results.value = ListResource(List<Location>.empty());
    }).whenComplete(() {
      loading.value = false;
      _disposable = null;
    });
  }
}