import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonationInfo extends StatelessWidget {
  const DonationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        children: [
          Image.network(
            'https://newsbriefapp.com/assets/donation-cover.jpg',
            width: MediaQuery.of(context).size.width * 0.8,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)?.missionStatement ??
                'Our mission from day one has been to ensure equal coverage across global stories while including all perspectives.',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context)?.beliefInJournalisticResources ??
                'We believe that journalistic resources are the key to propel our mission. If you value fair, diverse coverage and wish to help us bring real stories to a wider audience in every corner of the world, please lend a helping hand. Even the smallest amount can help us in making a great difference.',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context)?.journalistFund ??
                'All proceeds go toward our Journalist Fund, which allows journalists to pursue real leads to the fullest extent. Join us in our goal to give a voice to those who have been silenced, and uncover truths to bring to our readers.',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/donate');
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xFF0d6efd),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                AppLocalizations.of(context)?.imIn ?? "I'm in",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
