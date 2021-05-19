import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';

Widget mContainer(
    String mValContainer, Function() onChanged(val), BuildContext context,
    {bool enabled = true}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: mValContainer,
          decoration: InputDecoration(
            filled: true,
            enabled: enabled,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_main_category.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget dContainerCars(
    String dValContainer, Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: dValContainer,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_desc_cars.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget dContainerSpareParts(
    String dValContainer, Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: dValContainer,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_desc_spare_parts.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget dContainerRepairsAndServices(
    String dValContainer, Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: dValContainer,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_desc_repairs_and_services.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget dContainerCommercial(
    String dValContainer, Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: dValContainer,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_desc_commercial.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget dContainerOther(
    String dValContainer, Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              Text(AppLocalizations.of(context).translate('h_m_selected_auto')),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: dValContainer,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text(
              AppLocalizations.of(context).translate('h_m_selected_category')),
          items: a_desc_other.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget mContainerCarBody(String mValContainerCarBody, Function() onChanged(val),
    BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Выберете Кузов автомобиля'),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: mValContainerCarBody,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text('Выбрать кузов'),
          items: car_body.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget mContainerDriveAuto(String mValContainerDriveAuto,
    Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Выберете привод автомобиля'),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: mValContainerDriveAuto,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text('Выбрать привод'),
          items: drive_auto.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget mContainerGearboxAuto(String mValContainerGearboxAuto,
    Function() onChanged(val), BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Выберете корбку передач'),
        ),
        DropdownButtonFormField(
          isExpanded: true,
          value: mValContainerGearboxAuto,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.yellow),
          ),
          hint: Text('Выбрать коробку передач'),
          items: gearbox_auto.map((map) {
            return DropdownMenuItem(
              child: Text(AppLocalizations.of(context)
                  .translate('h_m_' + map['value'])),
              value: map['value'],
            );
          }).toList(),
          onChanged: (val) => onChanged(val),
        ),
      ],
    ),
  );
}

Widget containerCarModel(
    String valCar,
    String valModel,
    Function() onChanged(val),
    Function() onChangedTwo(val),
    BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Выберете марку и модель автомобиля'),
        ),
        DropdownButtonFormField(
            isExpanded: true,
            value: valCar,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              errorStyle: TextStyle(color: Colors.yellow),
            ),
            hint: Text(AppLocalizations.of(context)
                .translate('h_m_selected_category')),
            items: cars.map((map) {
              return DropdownMenuItem(
                child: Text(
                    AppLocalizations.of(context).translate(map['value']) ??
                        'ERROR: ' + map['value']),
                value: map['value'],
              );
            }).toList(),
            onChanged: (val) => onChanged(val)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: valCar == 'acura'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_acura.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'alfa_romeo'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_alfa_romeo.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'aston_martin'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_aston_martin.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'audi'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_audi.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'aurus'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_aurus.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'baic'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_baic.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'baw'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_baw.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'bmw'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_bmw.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'byd'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_byd.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'bentley'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_bentley.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'brilliance'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_brilliance.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'bugatti'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_bugatti.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'buick'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_buick.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'cadilac'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_cadilac.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'changfeng'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_changfeng.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'changan'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_changan.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'chery'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_chery.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'chevrolet'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_chevrolet.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'chrysler'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_chrysler.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'citroen'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_citroen.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'dacia'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_dacia.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'daewoo'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_daewoo.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'daihatsu'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_daihatsu.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'datsun'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_datsun.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'derways'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_derways.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'dodge'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_dodge.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'dongfeng'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_dongfeng.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'eagle'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_eagle.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'faw'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_faw.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'ferrari'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_ferrari.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'fiat'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_fiat.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'ford'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_ford.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'foton'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_foton.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'gac'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_gac.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'gmc'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_gmc.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'geely'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_geely.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'genesis'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_genesis.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'gonow'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_gonow.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'great_wall'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_great_wall.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'hafei'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_hafei.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'haima'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_haima.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'hanteng'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_hanteng.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'haval'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_haval.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'honda'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_honda.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'huanghai'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_huanghai.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'hummer'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_hummer.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'hyundai'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_hyundai.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'infinti'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_infinti.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'iran_khodro'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_iran_khodro.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'isuzu'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_isuzu.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'jac'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_jac.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'jmc'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_jmc.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'jaguar'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_jaguar.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'jeep'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_jeep.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'jinbei'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_jinbei.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'kia'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_kia.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lamborghini'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lamborghini.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lancia'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lancia.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'land_rover'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_land_rover.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lexus'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lexus.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lifan'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lifan.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lincoln'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lincoln.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lotus'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lotus.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lucid'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lucid.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'luxgen'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_luxgen.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mg'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mg.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mahindra'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mahindra.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'maserati'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_maserati.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'maybach'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_maybach.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mazda'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mazda.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mercedes_benz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mercedes_benz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mercedes_maybach'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mercedes_maybach.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mercury'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mercury.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mini'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mini.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'mitsubishi'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_mitsubishi.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'nissan'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_nissan.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'oldsmobile'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_oldsmobile.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'opel'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_opel.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'peugeot'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_peugeot.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'plymouth'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_plymouth.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'pontiac'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_pontiac.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'porsche'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_porsche.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'proton'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_proton.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'puch'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_puch.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'ravon'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_ravon.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'renault'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_renault.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'renault_samsung'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_renault_samsung.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'rolls_royce'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_rolls_royce.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'rover'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_rover.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'seat'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_seat.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'saab'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_saab.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'santana'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_santana.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'saturn'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_saturn.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'scion'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_scion.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'shuanghuan'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_shuanghuan.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'skoda'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_skoda.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'smart'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_smart.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'soueast'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_soueast.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'ssangyong'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_ssangyong.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'subaru'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_subaru.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'suzuki'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_suzuki.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'tesla'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_tesla.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'tianma'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_tianma.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'tianye'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_tianye.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'toyota'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_toyota.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'volkswagen'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_volkswagen.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'volvo'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_volvo.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'wuling'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_wuling.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'xinkai'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_xinkai.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'xpeng'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_xpeng.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'zx'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_zx.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'zotye'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_zotye.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'lada'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_lada.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'vis'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_vis.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'gaz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_gaz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'eraz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_eraz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'zaz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_zaz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'zil'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_zil.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'izh'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_izh.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'luaz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_luaz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'moskvich'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_moskvich.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'raf'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_raf.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'retro_cars'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_retro_cars.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'smz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_smz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'tagaz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_tagaz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : valCar == 'uaz'
              ? DropdownButtonFormField(
                  isExpanded: true,
                  value: valModel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: mod_uaz.map((map) {
                    return DropdownMenuItem(
                      child: Text(AppLocalizations.of(context)
                              .translate(map['value']) ??
                          'ERROR: ' + map['value']),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (val) => onChangedTwo(val),
                )
              : SizedBox(),
        ),
        Container(
            // child: textFieldtwo(controller, error, hint),
            ),
      ],
    ),
  );
}
