import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PaginationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaginationInitial extends PaginationState {}

class PaginationLoading extends PaginationState {}

class PaginationLoaded extends PaginationState {
  final List<DocumentSnapshot> items;
  final bool hasMore;

  PaginationLoaded({required this.items, required this.hasMore});

  @override
  List<Object?> get props => [items, hasMore];
}

class PaginationError extends PaginationState {
  final String error;

  PaginationError(this.error);

  @override
  List<Object?> get props => [error];
}
