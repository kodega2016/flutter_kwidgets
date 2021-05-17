import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firestore_service.dart';

class KFirebaseQueryWidget<T> extends StatefulWidget {
  final int perPage;
  final String path;
  final T Function(Map data, String id, DocumentSnapshot last) builder;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final DocumentSnapshot Function(List<T> items) doc;
  final Query Function(Query query) queryBuilder;

  const KFirebaseQueryWidget({
    Key key,
    this.perPage = 15,
    this.path,
    this.builder,
    this.itemBuilder,
    this.doc,
    this.queryBuilder,
  }) : super(key: key);

  @override
  _KFirebaseQueryWidgetState<T> createState() =>
      _KFirebaseQueryWidgetState<T>();
}

class _KFirebaseQueryWidgetState<T> extends State<KFirebaseQueryWidget<T>> {
  ScrollController _controller;
  final _service = FirestoreService();
  List<T> _data = <T>[];
  DocumentSnapshot _lastDoc;
  bool _isLoading = false;
  bool _isLast = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_fetchMoreData);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  _fetchMoreData() async {
    if (_controller.position.maxScrollExtent == _controller.offset &&
        !_isLast) {
      _isLoading = true;
      setState(() {});
      final _newData = await _service.queryData<T>(
        path: widget.path,
        queryBuilder: (query) {
          if (widget.queryBuilder != null) {
            query = widget.queryBuilder(query);
          }
          query = query.startAfterDocument(_lastDoc).limit(widget.perPage);
          return query;
        },
        builder: (data, id, lastDoc) => widget.builder(data, id, lastDoc),
      );

      if (_newData.isEmpty) {
        _isLast = true;
      } else {
        _lastDoc = widget.doc(_newData);
      }
      _data.addAll(_newData);
      _isLoading = false;
      setState(() {});
    }
  }

  _loadData() async {
    _isLoading = true;
    setState(() {});
    final _temp = await _service.queryData<T>(
      path: widget.path,
      builder: (data, id, doc) => widget.builder(data, id, doc),
      queryBuilder: (query) {
        if (widget.queryBuilder != null) {
          query = widget.queryBuilder(query);
        }
        query = query.limit(widget.perPage);
        return query;
      },
    );
    _data.addAll(_temp);
    if (_temp.isEmpty) {
      _isLast = true;
    } else {
      _lastDoc = widget.doc(_temp);
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading && _data.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: _controller,
            itemCount: _data.length + 1,
            itemBuilder: (BuildContext context, int i) {
              if (i == _data.length)
                return Container(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink(),
                );
              return widget.itemBuilder(context, _data[i]);
            },
          );
  }
}
