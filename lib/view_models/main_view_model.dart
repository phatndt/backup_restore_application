import 'package:backup_restore_application/view_models/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNotifier extends StateNotifier {
  MainNotifier(this.ref) : super(ref);
  final Ref ref;
}

final mainNotifierProvider = StateNotifierProvider((ref) => MainNotifier(ref));

final contactFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(repoProvider).getContactBackUpFile());

final phoneLogFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(repoProvider).getPhoneLogBackUpFile());

final smsLogFutureProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(repoProvider).getSmsLogBackUpFile());
