import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workoutapp/functions/cardio_db.dart';
import 'package:workoutapp/models/cardio/cardio_model.dart';

class CardioHistory extends StatefulWidget {
  const CardioHistory({super.key, });

  @override
  State<CardioHistory> createState() => _CardioHistoryState();
}

enum SortOption {
  none,
  ascending,
  descending,
  largestCalorieBurnt,
  smallestCalorieBurnt,
}

class _CardioHistoryState extends State<CardioHistory> {
  TextEditingController searchController = TextEditingController();
  List<CardioModel> allCardioData = [];
  List<CardioModel> searchedCardioData = [];
  SortOption selectedSortOption = SortOption.none;
  bool isNoDataFound = false; // Variable to track if no data is found

  @override
  void initState() {
    super.initState();
    _loadCardioData();
  }

  Future<void> _loadCardioData() async {
    final updatedList = await Cardiodb.retrieveCardio();
    setState(() {
      allCardioData = updatedList;
      searchedCardioData = List.from(allCardioData);
    });
  }

  void searchCardio(String query) {
    setState(() {
      searchedCardioData = allCardioData.where((cardio) {
        final formattedDate =
            DateFormat("dd MMM y").format(DateTime.parse(cardio.cardioDate));
        return cardio.cardioName.toLowerCase().contains(query.toLowerCase()) ||
            cardio.cardioName.startsWith(query) ||
            formattedDate == query;
      }).toList();
      isNoDataFound = searchedCardioData.isEmpty; // Set the flag
    });
  }

  void onSearched() {
    final text = searchController.text;
    if (text.isEmpty) {
      searchCardio('');
      isNoDataFound = false; // Reset the flag
    } else {
      searchCardio(text);
    }
  }

  void sortCardioList() {
    switch (selectedSortOption) {
      case SortOption.ascending:
        searchedCardioData.sort((a, b) =>
            DateTime.parse(a.cardioDate).compareTo(DateTime.parse(b.cardioDate)));
        break;
      case SortOption.descending:
        searchedCardioData.sort((a, b) =>
            DateTime.parse(b.cardioDate).compareTo(DateTime.parse(a.cardioDate)));
        break;

      case SortOption.smallestCalorieBurnt:
        searchedCardioData.sort((a, b) => a.caloriesBurnt.compareTo(b.caloriesBurnt));
        break;
      case SortOption.largestCalorieBurnt:
        searchedCardioData.sort((a, b) => b.caloriesBurnt.compareTo(a.caloriesBurnt));
        break;

      case SortOption.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;
    sortCardioList();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Cardio History"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Track your cardio",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        onSearched();
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        hintText: "Search your cardio",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                        filled: true,
                        fillColor: const Color.fromRGBO(43, 43, 43, 1),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range, color: Colors.amber),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            ).then((pickedDate) {
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat("dd MMM y").format(pickedDate);
                                searchController.text = formattedDate;
                                onSearched();
                              }
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButton<SortOption>(
                      alignment: Alignment.centerLeft,
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                      dropdownColor: Colors.black,
                      value: selectedSortOption,
                      items: const [
                        DropdownMenuItem<SortOption>(
                          value: SortOption.none,
                          child: Text('Sort by Date (None)'),
                        ),
                        DropdownMenuItem<SortOption>(
                          value: SortOption.ascending,
                          child: Text('Sort by Date (Ascending)'),
                        ),
                        DropdownMenuItem<SortOption>(
                          value: SortOption.descending,
                          child: Text('Sort by Date (Descending)'),
                        ),
                        DropdownMenuItem<SortOption>(
                          value: SortOption.largestCalorieBurnt,
                          child: Text('Sort by Calories (largest)'),
                        ),
                        DropdownMenuItem<SortOption>(
                          value: SortOption.smallestCalorieBurnt,
                          child: Text('Sort by Calories (smallest)'),
                        ),
                      ],
                      onChanged: (SortOption? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedSortOption = newValue;
                            sortCardioList();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              isNoDataFound?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                    child: Text(
                      "No data found for the selected date.",
                      style: TextStyle(color: Colors.white, fontSize: isLargeScreen ? 16 : 14),
                    ),
                  ),
                )
              :
              Expanded(
                child: ListView.builder(
                  itemCount: searchedCardioData.length,
                  itemBuilder: (context, index) {
                    final cardioData = searchedCardioData[index];
                    String dateCardio = DateFormat("dd MMM y")
                        .format(DateTime.parse(cardioData.cardioDate));
                    return ListTile(
                      title: Text(
                        cardioData.cardioName,
                        style: TextStyle(color: Colors.white, fontSize: isLargeScreen ? 16 : 14),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "${cardioData.durationMillis ~/ 60000} mins",
                            style: const TextStyle(color: Colors.amber, fontSize: 12),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.sunny,
                            color: Colors.amber,
                            size: 15,
                          ),
                          Text(
                            " ${cardioData.caloriesBurnt.toStringAsFixed(2)}kcal",
                            style: const TextStyle(color: Colors.amber, fontSize: 12),
                          )
                        ],
                      ),
                      trailing: Text(
                        dateCardio,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
