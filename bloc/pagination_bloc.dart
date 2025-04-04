import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pagination_event.dart';
import 'pagination_state.dart';
import '../repositories/firestore_repository.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final FirestoreRepository repository;

  PaginationBloc({required this.repository}) : super(PaginationInitial()) {
    on<FetchItems>(_onFetchItems);
    on<LoadMoreItems>(_onLoadMoreItems);
  }

  void _onFetchItems(FetchItems event, Emitter<PaginationState> emit) async {
    emit(PaginationLoading());
    try {
      List<DocumentSnapshot> items = await repository.fetchItems();
      emit(PaginationLoaded(items: items, hasMore: items.length == FirestoreRepository.pageSize));
    } catch (e) {
      emit(PaginationError('Ошибка загрузки данных'));
    }
  }

  void _onLoadMoreItems(LoadMoreItems event, Emitter<PaginationState> emit) async {
    if (state is! PaginationLoaded) return;
    
    final currentState = state as PaginationLoaded;
    if (!currentState.hasMore) return; // Если данных больше нет, выходим

    try {
      List<DocumentSnapshot> newItems = await repository.fetchItems(lastDoc: event.lastDocument);
      List<DocumentSnapshot> allItems = List.from(currentState.items)..addAll(newItems);
      
      emit(PaginationLoaded(
        items: allItems,
        hasMore: newItems.length == FirestoreRepository.pageSize,
      ));
    } catch (e) {
      emit(PaginationError('Ошибка загрузки данных'));
    }
  }
}
