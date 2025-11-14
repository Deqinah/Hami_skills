import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: Colors.white),
      onSelected: (String languageCode) {
        final newLocale = Locale(languageCode);
        languageProvider.changeLanguage(newLocale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Icon(Icons.language, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'so',
          child: Row(
            children: [
              Icon(Icons.language, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('Soomaali'),
            ],
          ),
        ),
      ],
    );
  }
}