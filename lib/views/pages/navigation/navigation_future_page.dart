import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/auth/supabase/supabase_auth.dart';
import 'package:workout_tracker/providers/profile/profile_data_notifier.dart';
import 'package:workout_tracker/views/pages/navigation/navigation_page.dart';

class NavigationFuturePage extends ConsumerStatefulWidget {
  const NavigationFuturePage({super.key});

  @override
  ConsumerState<NavigationFuturePage> createState() => _NavigationFuturePageState();
}

class _NavigationFuturePageState extends ConsumerState<NavigationFuturePage> {
  late Future<void> _getProfile;

  @override
  void initState() {
    super.initState();
    _getProfile = ref.read(profileDataProvider.notifier).loadProfileData().then((profile) async {
      await SupabaseAuth.instance.getUserFromCache(profile?.id);
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _getProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint('Error loading data: ${snapshot.error}');
          return const Scaffold(
            body: Center(
              child: Text('Error loading data'),
            ),
          );
        } else {
          debugPrint('Data gotten');
          return const NavigationPage();
        }
      },
    );
  }
}
