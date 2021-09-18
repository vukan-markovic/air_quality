import 'dart:io';

import '../../main.dart';
import 'city_details_item.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/city.dart';
import 'package:flutter/material.dart';

class CityDetailsPage extends StatelessWidget {
  final City city;

  final divider = Container(
    margin: const EdgeInsets.all(16.0),
    child: const Divider(
      height: 1.0,
      thickness: 1.0,
      color: Color(0xFFE5E9EB),
    ),
  );

  CityDetailsPage({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(city.station.name)),
      body: SafeArea(
        child: Scrollbar(
          isAlwaysShown:
              Platform.isWindows || Platform.isLinux || Platform.isMacOS
                  ? true
                  : false,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                const Text(
                  'Podaci o stanici',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 24.0),
                CityDetailsItem(
                  attribute: 'Naziv stanice',
                  value: city.station.name,
                ),
                divider,
                CityDetailsItem(
                  attribute: 'Početak rada',
                  value: DateFormat('dd.MM.yyyy.').format(
                    DateTime.parse(city.station.startDate),
                  ),
                ),
                divider,
                CityDetailsItem(
                  attribute: 'Pripada mreži',
                  value: city.station.city,
                ),
                if (city.station.stationClassification != null) ...[
                  divider,
                  CityDetailsItem(
                    attribute: 'Klasifikacija',
                    value: city.station.stationClassification!,
                  ),
                ],
                if (city.station.areaClassification != null) ...[
                  divider,
                  CityDetailsItem(
                    attribute: 'Zona',
                    value: city.station.areaClassification!,
                  ),
                ],
                divider,
                CityDetailsItem(
                  attribute: 'Geografska širina',
                  value: city.station.latitude.toString(),
                ),
                divider,
                CityDetailsItem(
                  attribute: 'Geografska dužina',
                  value: city.station.longitude.toString(),
                ),
                if (city.station.altitude != null) ...[
                  divider,
                  CityDetailsItem(
                    attribute: 'Nadmorska visina',
                    value: '${city.station.altitude.toString()}m',
                  ),
                ],
                const SizedBox(height: 48.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Komponente zagađenosti vazduha',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                const SizedBox(height: 24.0),
                ListView.separated(
                  separatorBuilder: (context, index) => divider,
                  itemCount: city.components.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => CityDetailsItem(
                    attribute:
                        '${city.components[index].shortName} (${city.components[index].name})',
                    value: city.values[index] != null
                        ? '${city.values[index]?.toStringAsFixed(2)} ${city.components[index].unit} (${city.components[index].matrix})'
                        : 'nepoznato',
                  ),
                ),
                divider,
                const SizedBox(height: 24.0),
                const Text('Agencija za zaštitu životne sredine'),
                GestureDetector(
                  onTap: () async => await canLaunch(Uri.encodeFull(agencyUrl))
                      ? await launch(Uri.encodeFull(agencyUrl))
                      : logger.e('Could not launch $agencyUrl'),
                  child: const Text(
                    agencyUrl,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
