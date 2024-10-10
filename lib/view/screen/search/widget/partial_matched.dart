// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchSuggestion extends StatefulWidget {
  final bool fromCompare;
  final int? id;

  const SearchSuggestion({
    Key? key,
    this.fromCompare = false,
    this.id,
  }) : super(key: key);
  @override
  State<SearchSuggestion> createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  String? selectedCity;
  TextEditingController locationController = TextEditingController();
  String? currentAddress;
  Position? currentPosition;
  bool isLocationEnabled = true;
  bool isDropdownEnabled = true;
  //* FUNCTION to handel location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // print(serviceEnabled);
    // if (!serviceEnabled) {
    // ignore: use_build_context_synchronously
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //           'Location services are disabled. Please enable the services'),
    //     ),
    //   );
    //   return false;
    // }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        locationController.text = place.locality!;
        selectedCity =
            place.locality; // Update the city name in the DropdownButton
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCurrentPositionForUser() async {
    final hasPermission = await _handleLocationPermission();
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
      isDropdownEnabled = false;
      _getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    // print('LAT: ${currentPosition?.latitude ?? ""}');
    // print('LNG: ${currentPosition?.longitude ?? ""}');
    // print('ADDRESS: ${currentAddress ?? ""}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Autocomplete(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty ||
                      searchProvider.suggestionModel == null) {
                    return const Iterable<String>.empty();
                  } else {
                    return searchProvider.nameList.where(
                      (word) => word.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                    );
                  }
                },
                optionsViewBuilder:
                    (context, Function(String) onSelected, options) {
                  return Material(
                    elevation: 0,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return InkWell(
                          onTap: () {
                            if (widget.fromCompare) {
                              searchProvider.setSelectedProductId(
                                  index, widget.id);
                              Navigator.of(context).pop();
                            } else {
                              searchProvider.searchProduct(
                                  query: option.toString(), offset: 1);
                              onSelected(option.toString());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeSmall),
                                  child: Icon(Icons.history,
                                      color: Theme.of(context).hintColor,
                                      size: 20),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeSmall),
                                    child: SubstringHighlight(
                                      text: option.toString(),
                                      textStyle: textRegular.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(.5),
                                      ),
                                      term:
                                          searchProvider.searchController.text,
                                      textStyleHighlight: textBold.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                          fontSize: Dimensions.fontSizeLarge),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: Dimensions.paddingSizeSmall,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: options.length,
                    ),
                  );
                },
                onSelected: (selectedString) {
                  if (kDebugMode) {
                    print(selectedString);
                  }
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  searchProvider.searchController = controller;

                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            textInputAction: TextInputAction.search,
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                searchProvider.getSuggestionProductName(
                                    searchProvider.searchController.text
                                        .trim());
                              }
                            },
                            decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  top: 15.0,
                                ),
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search here..",
                                hintStyle: TextStyle(fontSize: 12)
                                // suffixIcon:
                                ),
                          ),
                        ),
                      ),
                      //* drop down field for the city name
                      Expanded(
                        child: DropdownButton<String>(
                          value: isDropdownEnabled ? selectedCity : null,
                          hint: const Text('City'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          underline:
                              const SizedBox.shrink(), // Remove the underline
                          elevation: 0,
                          isExpanded: true,
                          items: <String>[
                            'Illam',
                            'Ithari',
                            'Biratnagar',
                            'Pokhara'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: isDropdownEnabled
                              ? (value) {
                                  setState(() {
                                    selectedCity = value;
                                    isLocationEnabled = false;
                                  });
                                  print(selectedCity);
                                }
                              : null, // Disable onChanged when dropdown is not enabled
                        ),
                      ),

                      //* find location
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          controller: locationController,
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.only(
                                top: 16.0,
                              ),
                              border: InputBorder.none,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Loction",
                              suffixIcon: IconButton(
                                onPressed: isLocationEnabled
                                    ? getCurrentPositionForUser
                                    : null,
                                icon: isLocationEnabled
                                    ? const Icon(Icons.location_on_outlined)
                                    : const Icon(Icons.location_off_outlined),
                              )
                              // suffixIcon:
                              ),
                        ),
                      ),
                      //* search icon for search requests
                      SizedBox(
                        width: controller.text.isNotEmpty ? 70 : 50,
                        height: 60,
                        child: Row(
                          children: [
                            //* cross icon is shown after search is made to clear
                            if (controller.text.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.clear();
                                  });
                                },
                                child: const Icon(
                                  Icons.clear,
                                  size: 20,
                                ),
                              ),
                            //search icon and logic if controller.text.isEmpty and not empty
                            InkWell(
                              onTap: () {
                                if (controller.text.trim().isNotEmpty) {
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .saveSearchAddress(
                                          controller.text.toString());
                                  Provider.of<SearchProvider>(context,
                                          listen: false)
                                      .searchProduct(
                                          query: controller.text.toString(),
                                          offset: 1);
                                } else {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_somethings', context),
                                      context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  width: 40,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              Dimensions.paddingSizeSmall))),
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: Image.asset(Images.search,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
