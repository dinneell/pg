import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../bloc/pagination_state.dart';

class PaginationList extends StatefulWidget {
  @override
  _PaginationListState createState() => _PaginationListState();
}

class _PaginationListState extends State<PaginationList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PaginationBloc>(context).add(FetchItems());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        final state = context.read<PaginationBloc>().state;
        if (state is PaginationLoaded && state.hasMore) {
          context.read<PaginationBloc>().add(LoadMoreItems(lastDocument: state.items.last));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Pagination")),
      body: BlocBuilder<PaginationBloc, PaginationState>(
        builder: (context, state) {
          if (state is PaginationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PaginationError) {
            return Center(child: Text(state.error));
          } else if (state is PaginationLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.items.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.items.length) {
                  var item = state.items[index];
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
