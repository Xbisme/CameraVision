import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';

import 'settings_cubit.dart';

/// Placeholder for the settings area (Spec #001).
///
/// Shows only its localized area name. No styling is authored here — the design
/// system lands in Spec #001b (Principle VII).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit()..start(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.areaSettings)),
        body: Center(child: Text(l10n.areaSettings)),
      ),
    );
  }
}
