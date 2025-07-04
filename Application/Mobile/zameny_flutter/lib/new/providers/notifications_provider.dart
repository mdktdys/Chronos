import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/shared/domain/models/search_item_model.dart';
import 'package:zameny_flutter/shared/domain/models/subscribtion.dart';

final norificationsProvider = ChangeNotifierProvider<NotificationsNotifier>((final ref) {
  return NotificationsNotifier(ref: ref);
});

sealed class SubscribtionState {}
class SubscribtionNonSubscribed extends SubscribtionState {}
class SubscribtionSubscribed extends SubscribtionState {}
class SubscribtionRestricted extends SubscribtionState {}

final subsribtionProvider = NotifierProviderFamily<SubsribtionNotifier, AsyncValue<SubscribtionState>, SearchItem>(SubsribtionNotifier.new);

class SubsribtionNotifier extends FamilyNotifier<AsyncValue<SubscribtionState>, SearchItem> {
  SearchItem? item;

  @override
  AsyncValue<SubscribtionState> build(final SearchItem seachItem) {
    item = seachItem;
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    final subs = await ref.read(subsriptionProvider.future);

    if (subs.any((final sub) => sub.targetId == item?.id && sub.targetTypeId == item?.typeId)) {
      final enabled = await isNotificationEnabled();

      if (!enabled) {
        state = AsyncValue.data(SubscribtionRestricted());
        return;
      }

      state = AsyncValue.data(SubscribtionSubscribed());
    } else {
      state = AsyncValue.data(SubscribtionNonSubscribed());
    }
  }

  Future<bool> isNotificationEnabled() async {
  final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.notification.request();

    return result.isGranted;
  }


  Future<void> subscribe() async {
    final enabled = await isNotificationEnabled();

    if (!enabled) {
      state = AsyncValue.data(SubscribtionRestricted());
      return;
    }

    state = const AsyncValue.loading();
    await ref.read(norificationsProvider).subscribeForNotifciations(item!.id, item!.typeId);
    state = AsyncValue.data(SubscribtionSubscribed());
    ref.invalidate(subsriptionProvider);
    ref.invalidateSelf();
  }

  Future<void> onsubscribe() async {
    state = const AsyncValue.loading();
    await ref.read(norificationsProvider).unsubForNotifciations(item!.id, item!.typeId);
    state = AsyncValue.data(SubscribtionNonSubscribed());
    ref.invalidate(subsriptionProvider);
    ref.invalidateSelf();
  }
}

class NotificationsNotifier extends ChangeNotifier {
  late final _firebaseMessaging = FirebaseMessaging.instance;
  AsyncValue state = const AsyncValue.data('value');
  String? fCMToken;

  Ref ref;

  NotificationsNotifier({required this.ref}){
    fCMToken = GetIt.I.get<SharedPreferences>().getString('FCM');

    _firebaseMessaging.onTokenRefresh.listen((final String token) async {
      if (fCMToken != null) {
        await GetIt.I.get<SupabaseClient>().from('MessagingClients').update({'token': token}).eq('token', fCMToken!);
      }
      fCMToken = token;
      await GetIt.I.get<SharedPreferences>().setString('FCM', token);
    });
  }

  Future<void> subscribeForNotifciations(final int targetId, final int targetTypeId) async {
    fCMToken ??= await _getToken();

    if(fCMToken == null) {
      return;
    }

    try{
      await GetIt.I.get<SupabaseClient>().from('MessagingClients').insert({
        'token': fCMToken,
        'clientID': kIsWeb ? 1 : 2,
        'subType': targetTypeId,
        'subID': targetId,
      });
    } on Exception catch(e) {
      log(e.toString());
    }
  }

  Future<void> unsubForNotifciations(final int targetId, final int targetTypeId) async {
    fCMToken ??= await _getToken();

    if(fCMToken == null) {
      return;
    }
    log('token $fCMToken');
    log('subType $targetTypeId');
    log('subID $targetId');
    await GetIt.I.get<SupabaseClient>().from('MessagingClients').delete().eq('token', fCMToken!).eq('clientID', kIsWeb ? 1 : 2).eq('subType', targetTypeId).eq('subID', targetId);
  }

  Future<String?> _getToken() async {
    await _firebaseMessaging.requestPermission(provisional: kIsWeb ? false : true);
    final String? fCMToken = await _firebaseMessaging.getToken(vapidKey: 'BJnmledYcYUvwlAqyOkgZ2QKyIICQBQKA5aUDTboTjMp2jGf0ibZY8qaKLpBSw7DQfrX9A70SAHYqNraqdSQI0c');

    if (fCMToken != null) {
      GetIt.I.get<SharedPreferences>().setString('FCM', fCMToken);
    }

    return fCMToken;
  }
}

final subsriptionProvider = FutureProvider<List<Subscription>>((final Ref ref) async {
  String? token = ref.watch(norificationsProvider).fCMToken;

  if(token == null) {
    return [];
  }

  final response = await GetIt.I.get<SupabaseClient>().from('MessagingClients').select().eq('token', token);
  log(response.toString());
  return response.map((final sub){ return Subscription.fromMap(sub);}).toList();
});
