import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';

import 'batch_cubit.dart';

/// Placeholder for the batch area (Spec #001).
///
/// Shows only its localized area name. No styling is authored here — the design
/// system lands in Spec #001b (Principle VII).
class BatchPage extends StatelessWidget {
  const BatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return BlocProvider<BatchCubit>(
      create: (_) => BatchCubit()..start(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.areaBatch)),
        body: Center(child: Text(l10n.areaBatch)),
      ),
    );
  }
}
