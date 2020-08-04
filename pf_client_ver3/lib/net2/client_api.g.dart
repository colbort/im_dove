// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ClientApi implements ClientApi {
  _ClientApi(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  getRecommendData(type, page, [pageSize = 30]) async {
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'id': type, 'page': page, 'pageSize': pageSize};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/recommend/av',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RecommendBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getClassifyHome(
      [sortId = 0, categoryId = 0, tagId = 0, pageSize = PAGE_SIZE]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'sortId': sortId,
      'categoryId': categoryId,
      'tagId': tagId,
      'page_size': pageSize
    };
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/v3/video/categoryVideoHome',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ClassifyHome.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getClassifyNext(sortId, categoryId, tagId,
      [skip = 0, limit = PAGE_SIZE]) async {
    ArgumentError.checkNotNull(sortId, 'sortId');
    ArgumentError.checkNotNull(categoryId, 'categoryId');
    ArgumentError.checkNotNull(tagId, 'tagId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'sortId': sortId,
      'categoryId': categoryId,
      'tagId': tagId,
      'skip': skip,
      'limit': limit
    };
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/v3/video/categoryVideo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VideosBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getSelectedCarousel([type = 3]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'type': type};
    final Response<List<dynamic>> _result = await _dio.request('/carouse/list',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => CarouseBean.fromJson(i as Map<String, dynamic>))
        .toList();
    return Future.value(value);
  }

  @override
  getSelectedGroups() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/v3/video/allTopicVideo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VideoGroupsBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getSelectedGroup(topicId) async {
    ArgumentError.checkNotNull(topicId, 'topicId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'topicId': topicId};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/v3/video/topicVideo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VideoGroupBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getVersion(map2) async {
    ArgumentError.checkNotNull(map2, 'map2');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map2 ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/version/getVersion',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VersionBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getCoinVideos(page, [pageSize = PAGE_SIZE]) async {
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'page': page, 'pageSize': pageSize};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/video/needPayVideos',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VideosBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getBoughtVideos(skip, [limit = PAGE_SIZE]) async {
    ArgumentError.checkNotNull(skip, 'skip');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'skip': skip, 'limit': limit};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/video/avBuysNew',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = BoughtBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getCollectVideos(skip, [limit = PAGE_SIZE]) async {
    ArgumentError.checkNotNull(skip, 'skip');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'skip': skip, 'limit': limit};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/userVideo/avCollectsNew',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CollectBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getPayType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request(
        '/recharge/paytype',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => ChargeItemBean.fromJson(i as Map<String, dynamic>))
        .toList();
    return Future.value(value);
  }

  @override
  pay(money, payType, payTypeName, buyType, [memberId = 0, flag = true]) async {
    ArgumentError.checkNotNull(money, 'money');
    ArgumentError.checkNotNull(payType, 'payType');
    ArgumentError.checkNotNull(payTypeName, 'payTypeName');
    ArgumentError.checkNotNull(buyType, 'buyType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'money': money,
      'payType': payType,
      'typeName': payTypeName,
      'typ': buyType,
      'id': memberId,
      'flag': flag
    };
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/recharge/submit',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PaySucBean.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAllVipInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/vip/getAllList',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = VipInfoBean.fromJson(_result.data);
    return Future.value(value);
  }
}
