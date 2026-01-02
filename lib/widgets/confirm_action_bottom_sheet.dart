import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/simple_sheet.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ConfirmActionBottomSheet<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B bloc;

  final String title;
  final String confirmationText;
  final String confirmButtonText;

  final VoidCallback onConfirm;

  final bool Function(S state) isSuccess;
  final bool Function(S state) isFailure;
  final void Function(BuildContext context, S state)? onFailure;

  const ConfirmActionBottomSheet({
    super.key,
    required this.bloc,
    required this.title,
    required this.confirmationText,
    required this.onConfirm,
    required this.isSuccess,
    required this.isFailure,
    this.onFailure,
    this.confirmButtonText = 'Confirm',
  });

  static Future<void> show<B extends StateStreamableSource<S>, S>({
    required BuildContext context,
    required ConfirmActionBottomSheet<B, S> sheet,
  }) {
    final pageIndexNotifier = ValueNotifier<int>(0);

    return WoltModalSheet.show(
      context: context,
      pageIndexNotifier: pageIndexNotifier,
      modalTypeBuilder: (context) => PiUtils.getModalTypeBuilder(context),
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            pageTitle: Text(
              sheet.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: BlocProvider.value(value: sheet.bloc, child: sheet),
          ),
        ];
      },
    ).whenComplete(pageIndexNotifier.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        if (isSuccess(state)) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else if (isFailure(state)) {
          onFailure?.call(context, state);
        }
      },
      child: SimpleBottomSheet(
        primaryTitle: confirmButtonText,
        confirmationText: confirmationText,
        cancelFunction: () => Navigator.pop(context),
        primaryFunction: onConfirm,
      ),
    );
  }
}
