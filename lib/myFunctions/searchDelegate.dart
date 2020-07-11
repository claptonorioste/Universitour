import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:universitour/models/building.dart';
import 'package:universitour/models/instructor.dart';
import 'package:universitour/models/room.dart';

class CustomSearchDelegate extends SearchDelegate {
  //searchLevel 1 = all , 2 = building , 3 = instructor, 4 = room

  final int searchLevel;
  final List list;
  final List suggestionList;
  final Function addDestination, addDestLocation, setRouting, popContext;

  CustomSearchDelegate(
      this.searchLevel,
      this.list,
      this.suggestionList,
      this.addDestination,
      this.addDestLocation,
      this.setRouting,
      this.popContext,
      );

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
    
    List suggestionList = getSuggestionList(searchLevel);
    
    // TODO: implement buildSuggestions
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (searchLevel == 2) {
                close(context, null);
                popContext();
                addDestLocation(LatLng(suggestionList[index].latitude,suggestionList[index].longitude),0.0,0.0," ");
                addDestination(suggestionList[index].blngName,"Going to Building");
                setRouting();
                
              }else if (searchLevel == 4) {
                close(context, null);
                popContext();
                addDestLocation(LatLng(suggestionList[index].latitude,
                    suggestionList[index].longitude),suggestionList[index].roomXCoor,suggestionList[index].roomYCoor,suggestionList[index].floor);
                addDestination(suggestionList[index].namenum,suggestionList[index].roomName);
                setRouting();
                
              }else if (searchLevel == 3) {
                close(context, null);
                popContext();
                addDestLocation(LatLng(suggestionList[index].latitude,
                    suggestionList[index].longitude),suggestionList[index].roomXCoor,suggestionList[index].roomYCoor,suggestionList[index].floor);
                addDestination(suggestionList[index].blngName,"Visiting "+suggestionList[index].instructor+" "+(suggestionList[index].bldgNumber).toString()+"-"+suggestionList[index].roomNum);
                setRouting();
               
              }
            },
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index]
                      .namenum
                      .substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index]
                            .namenum
                            .substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          );
        });
  }

  List getSuggestionList(searchLevel){
    if(searchLevel == 2){
        List<Building> buildingSuggestionList = query.isEmpty
          ? list
          : suggestionList.where((p) => p.namenum.startsWith(query)).toList();
        return buildingSuggestionList;
    }else if(searchLevel == 4){
        List<Room> roomSuggestionList = query.isEmpty
          ? list
          : suggestionList.where((p) => p.namenum.startsWith(query)).toList();
        return roomSuggestionList;
    }else if(searchLevel == 3){
        List<Instructor> roomSuggestionList = query.isEmpty
          ? list
          : suggestionList.where((p) => p.namenum.startsWith(query)).toList();
        return roomSuggestionList;
    }else if(searchLevel == 1){
        List allList = query.isEmpty
          ? list
          : suggestionList.where((p) => p.namenum.startsWith(query)).toList();
        return allList;
    }
  }
}
