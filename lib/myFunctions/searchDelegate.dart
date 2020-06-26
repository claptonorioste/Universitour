import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Sample> sample = [Sample(1,'ABC'), Sample(2,'BCD'), Sample(3,'CDE')];
  List<Sample> suggestion = [Sample(1,'ABC'), Sample(2,'BCD'), Sample(3,'CDE'),Sample(4,'DEF'), Sample(5,'EFG')];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Sample> suggestionList = query.isEmpty
        ? sample
        : suggestion.where((p) => p.name.startsWith(query)).toList();
    // TODO: implement buildSuggestions
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => print(suggestionList[index].id),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].name.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].name.substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          );
        });
  }
}
class Sample{

  final int id;
  final String name;

  const Sample(this.id,this.name);
}
