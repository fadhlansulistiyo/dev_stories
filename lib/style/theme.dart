import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4288806922),
      surfaceTint: Color(4290773006),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4293329172),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4289866532),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294932586),
      onSecondaryContainer: Color(4281729025),
      tertiary: Color(4285678592),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288963584),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294965495),
      onBackground: Color(4280948244),
      surface: Color(4294965495),
      onSurface: Color(4280948244),
      surfaceVariant: Color(4294957781),
      onSurfaceVariant: Color(4284432187),
      outline: Color(4287917673),
      outlineVariant: Color(4293508278),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282460968),
      inverseOnSurface: Color(4294962666),
      inversePrimary: Color(4294948010),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4282449921),
      primaryFixedDim: Color(4294948010),
      onPrimaryFixedVariant: Color(4287823880),
      secondaryFixed: Color(4294957781),
      onSecondaryFixed: Color(4282449921),
      secondaryFixedDim: Color(4294948010),
      onSecondaryFixedVariant: Color(4287565583),
      tertiaryFixed: Color(4294958523),
      onTertiaryFixed: Color(4281014016),
      tertiaryFixedDim: Color(4294948968),
      onTertiaryFixedVariant: Color(4284955904),
      surfaceDim: Color(4294365901),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294959838),
      surfaceContainerHighest: Color(4294957781),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4287365127),
      surfaceTint: Color(4290773006),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4293329172),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4287170827),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291903799),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284627456),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288963584),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294965495),
      onBackground: Color(4280948244),
      surface: Color(4294965495),
      onSurface: Color(4280948244),
      surfaceVariant: Color(4294957781),
      onSurfaceVariant: Color(4284103479),
      outline: Color(4286142034),
      outlineVariant: Color(4288180845),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282460968),
      inverseOnSurface: Color(4294962666),
      inversePrimary: Color(4294948010),
      primaryFixed: Color(4293527062),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4290510862),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4291903799),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4289603618),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4289095171),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4286861312),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4294365901),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294959838),
      surfaceContainerHighest: Color(4294957781),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4283301890),
      surfaceTint: Color(4290773006),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287365127),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283301890),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4287170827),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281670912),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284627456),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965495),
      onBackground: Color(4280948244),
      surface: Color(4294965495),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4294957781),
      onSurfaceVariant: Color(4281802010),
      outline: Color(4284103479),
      outlineVariant: Color(4284103479),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282460968),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294961123),
      primaryFixed: Color(4287365127),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284612611),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4287170827),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284612611),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284627456),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282590720),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4294365901),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294959838),
      surfaceContainerHighest: Color(4294957781),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294948010),
      surfaceTint: Color(4294948010),
      onPrimary: Color(4285071364),
      primaryContainer: Color(4292280337),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4294948010),
      onSecondary: Color(4285071364),
      secondaryContainer: Color(4286973193),
      onSecondaryContainer: Color(4294953667),
      tertiary: Color(4294948968),
      onTertiary: Color(4282919168),
      tertiaryContainer: Color(4288109568),
      onTertiaryContainer: Color(4294967295),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4280290828),
      onBackground: Color(4294957781),
      surface: Color(4280290828),
      onSurface: Color(4294957781),
      surfaceVariant: Color(4284432187),
      onSurfaceVariant: Color(4293508278),
      outline: Color(4289693570),
      outlineVariant: Color(4284432187),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294957781),
      inverseOnSurface: Color(4282460968),
      inversePrimary: Color(4290773006),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4282449921),
      primaryFixedDim: Color(4294948010),
      onPrimaryFixedVariant: Color(4287823880),
      secondaryFixed: Color(4294957781),
      onSecondaryFixed: Color(4282449921),
      secondaryFixedDim: Color(4294948010),
      onSecondaryFixedVariant: Color(4287565583),
      tertiaryFixed: Color(4294958523),
      onTertiaryFixed: Color(4281014016),
      tertiaryFixedDim: Color(4294948968),
      onTertiaryFixedVariant: Color(4284955904),
      surfaceDim: Color(4280290828),
      surfaceBright: Color(4283118384),
      surfaceContainerLowest: Color(4279896328),
      surfaceContainerLow: Color(4280948244),
      surfaceContainer: Color(4281211416),
      surfaceContainerHigh: Color(4282000418),
      surfaceContainerHighest: Color(4282789676),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294949553),
      surfaceTint: Color(4294948010),
      onPrimary: Color(4281794561),
      primaryContainer: Color(4294923336),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294949553),
      onSecondary: Color(4281794561),
      secondaryContainer: Color(4294401359),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294950518),
      onTertiary: Color(4280553984),
      tertiaryContainer: Color(4291330342),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4280290828),
      onBackground: Color(4294957781),
      surface: Color(4280290828),
      onSurface: Color(4294965753),
      surfaceVariant: Color(4284432187),
      onSurfaceVariant: Color(4293771450),
      outline: Color(4291008916),
      outlineVariant: Color(4288772725),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294957781),
      inverseOnSurface: Color(4282000674),
      inversePrimary: Color(4287954952),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4281139201),
      primaryFixedDim: Color(4294948010),
      onPrimaryFixedVariant: Color(4285792261),
      secondaryFixed: Color(4294957781),
      onSecondaryFixed: Color(4281139201),
      secondaryFixedDim: Color(4294948010),
      onSecondaryFixedVariant: Color(4285792261),
      tertiaryFixed: Color(4294958523),
      onTertiaryFixed: Color(4280094208),
      tertiaryFixedDim: Color(4294948968),
      onTertiaryFixedVariant: Color(4283444736),
      surfaceDim: Color(4280290828),
      surfaceBright: Color(4283118384),
      surfaceContainerLowest: Color(4279896328),
      surfaceContainerLow: Color(4280948244),
      surfaceContainer: Color(4281211416),
      surfaceContainerHigh: Color(4282000418),
      surfaceContainerHighest: Color(4282789676),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294965753),
      surfaceTint: Color(4294948010),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949553),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965753),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294949553),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966008),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294950518),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4280290828),
      onBackground: Color(4294957781),
      surface: Color(4280290828),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4284432187),
      onSurfaceVariant: Color(4294965753),
      outline: Color(4293771450),
      outlineVariant: Color(4293771450),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294957781),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4284219395),
      primaryFixed: Color(4294959324),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949553),
      onPrimaryFixedVariant: Color(4281794561),
      secondaryFixed: Color(4294959324),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294949553),
      onSecondaryFixedVariant: Color(4281794561),
      tertiaryFixed: Color(4294959814),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294950518),
      onTertiaryFixedVariant: Color(4280553984),
      surfaceDim: Color(4280290828),
      surfaceBright: Color(4283118384),
      surfaceContainerLowest: Color(4279896328),
      surfaceContainerLow: Color(4280948244),
      surfaceContainer: Color(4281211416),
      surfaceContainerHigh: Color(4282000418),
      surfaceContainerHighest: Color(4282789676),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
