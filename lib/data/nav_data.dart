import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/presentation/views/donation/donation_info.dart';
import 'package:newsbriefapp/presentation/views/news/all_news.dart';
import 'package:newsbriefapp/presentation/views/news/trending_news.dart';
import 'package:newsbriefapp/presentation/views/profile/main_profile.dart';

class NavItem {
  final String name;
  final Icon icon;
  final Widget route;
  final NavBarType navBarType;
  const NavItem(
      {required this.name,
      required this.icon,
      required this.route,
      required this.navBarType});
}

enum NavBarType { normal, title, menu }

List<NavItem> navList = [
  const NavItem(
      name: 'All News',
      icon: Icon(FontAwesomeIcons.arrowsRotate),
      navBarType: NavBarType.normal,
      route: AllNews()),
  const NavItem(
      name: 'Trending News',
      icon: Icon(FontAwesomeIcons.fire),
      navBarType: NavBarType.normal,
      route: TrendingNews()),
  const NavItem(
      name: 'Donate',
      icon: Icon(FontAwesomeIcons.handHoldingHeart),
      navBarType: NavBarType.title,
      route: DonationInfo()),
  const NavItem(
      name: 'Profile',
      icon: Icon(FontAwesomeIcons.solidUser),
      navBarType: NavBarType.menu,
      route: MainProfile()),
];
