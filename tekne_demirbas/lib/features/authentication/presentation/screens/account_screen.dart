import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider)!;

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hesap Bilgileri',
              style: Appstyles.titleTextStyle.copyWith(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const Icon(Icons.account_circle, color: Colors.blueGrey, size: 80),

            Text(currentUser.email!),
            Text(currentUser.uid),
            SizedBox(height: SizeConfig.getProportionateHeight(20)),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Cikis yapmak istedigine emin misin?',
                      style: Appstyles.normalTextStyle,
                    ),
                    icon: const Icon(Icons.logout, color: Colors.red, size: 60),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text('Hayir', style: Appstyles.normalTextStyle),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.pop();
                          ref.read(authRepositoryProvider).signOut();
                        },
                        child: Text('Evet', style: Appstyles.normalTextStyle),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.getProportionateHeight(50),
                width: SizeConfig.screenWidth * 0.80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Cikis yap',
                  style: Appstyles.normalTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
