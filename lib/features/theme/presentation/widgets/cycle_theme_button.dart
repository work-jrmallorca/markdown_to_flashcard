import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../bloc/theme_state.dart';

class CycleThemeButton extends StatelessWidget {
  const CycleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        Icon icon;
        switch (state.status) {
          case ThemeStatus.light:
            icon = const Icon(Icons.sunny);
            break;
          case ThemeStatus.dark:
            icon = const Icon(Icons.nightlight_round_sharp);
            break;
          case ThemeStatus.amoled:
            icon = const Icon(Icons.circle);
            break;
        }

        return IconButton(
          tooltip: 'Cycle theme',
          onPressed: () => context.read<ThemeCubit>().cycleTheme(),
          icon: icon,
        );
      },
    );
  }
}
