import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:provider/provider.dart';

import '../models/trash_can_model.dart';
import '../providers/trash_cans_provider.dart';
import 'detail_page.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  late final TrashCansProvider _trashCansProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _trashCansProvider = Provider.of<TrashCansProvider>(context, listen: false);
    _trashCansProvider.loadTrashCans(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TrashCansProvider>(
        builder: (_, provider, widget) => NaverMap(
          onMapCreated: _onMapCreated,
          markers: [
            ...provider.trashCans
                .where((e) => e.x != null && e.y != null)
                .map((e) => Marker(
                      markerId: e.hash,
                      position: LatLng(e.y!, e.x!),
                      onMarkerTab: (marker, iconsize) =>
                          _onMarkerTap(provider, marker!, iconsize),
                    ))
                .toList()
          ],
          locationButtonEnable: true,
        ),
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyValueTable(List<String> keys, List<String> values,
      {double height = 20}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: keys
                .map((e) => SizedBox(child: Text(e), height: height))
                .toList(),
          ),
          Column(
            children: keys
                .map((_) => SizedBox(
                      child: VerticalDivider(color: Colors.black),
                      height: height,
                    ))
                .toList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: values
                .map((e) => SizedBox(child: Text(e), height: height))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildModalBottomSheet(TrashCan selectedTrashCan) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
      ),
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHandle(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  child: Text('닫기'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: const Text(
                    '쓰레기통 정보',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                children: [
                  _buildKeyValueTable([
                    '설치장소',
                    '도로명주소'
                  ], [
                    '${selectedTrashCan.location ?? ''}',
                    '${selectedTrashCan.roadAddress ?? ''}'
                  ]),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('더 자세히 보기'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                address:
                                    '${selectedTrashCan.roadAddress ?? ''}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMarkerTap(
      TrashCansProvider provider, Marker marker, Map<String, int?> iconSize) {
    final selectedTrashCan =
        provider.trashCans.singleWhere((e) => e.hash == marker.markerId);

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return _buildModalBottomSheet(selectedTrashCan);
      },
    );
  }
}
