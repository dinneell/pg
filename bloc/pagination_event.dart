import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PaginationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchItems extends PaginationEvent {}

class LoadMoreItems extends PaginationEvent {
  final DocumentSnapshot lastDocument;

  LoadMoreItems({required this.lastDocument});

  @override
  List<Object?> get props => [lastDocument];
}
