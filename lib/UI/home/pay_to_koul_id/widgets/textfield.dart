import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class KoulTextField extends StatefulWidget {
  final void Function(String) onTextChanged;
  final String labelText;
  final TextInputType keyBoardType;
  final String prefixValue;
  final int maxLength;
  final bool autoFocus;

  const KoulTextField({
    super.key,
    required this.onTextChanged,
    required this.labelText,
    required this.keyBoardType,
    required this.prefixValue,
    required this.maxLength,
    required this.autoFocus,
  });

  @override
  State<KoulTextField> createState() => _KoulTextFieldState();
}

class _KoulTextFieldState extends State<KoulTextField> {
  final TextEditingController koulidController = TextEditingController();
  final ValueNotifier<String> textLengthNotifier = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    koulidController.addListener(() {
      final currentState = context.read<KoulAccountBloc>().state;

      textLengthNotifier.value = koulidController.text.trim();
      widget.onTextChanged(koulidController.text.trim());

      if (currentState is FailureState) {
        context.read<KoulAccountBloc>().add(SetStateToInitial());
      }
    });
  }

  @override
  void dispose() {
    koulidController.dispose();
    textLengthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        autofocus: widget.autoFocus,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          labelText: widget.labelText,
          prefix: Text(widget.prefixValue),
          suffixIcon: ValueListenableBuilder<String>(
            valueListenable: textLengthNotifier,
            builder: (context, textLength, child) {
              return IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: textLength.isEmpty ? Colors.white38 : Colors.white,
                ),
                onPressed: textLength.isEmpty
                    ? null
                    : () {
                        koulidController.clear();
                      },
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.white38,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          floatingLabelStyle: Theme.of(context).textTheme.titleSmall,
          labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.white70,
              ),
          prefixStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        controller: koulidController,
        keyboardType: widget.keyBoardType,
        maxLength: widget.maxLength == 0 ? 100000 : widget.maxLength,
        buildCounter: (context,
            {required currentLength, required isFocused, required maxLength}) {
          return widget.maxLength == 0
              ? null
              : Text(
                  '$currentLength/$maxLength',
                  style: Theme.of(context).textTheme.bodySmall,
                );
        },
      ),
    );
  }
}
