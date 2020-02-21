import 'package:flutter/material.dart';

Widget AtmsPageViewer(zones,controller){



  return Scaffold(

    body: Container(
      child:
          ListView.builder(
              controller:controller,
              itemCount:zones['TotalCount'],
               itemBuilder: (context, index) {
              return  Card( //                           <-- Card widget
                        child: ListTile(
                                        leading: Icon(Icons.atm),
                                       title: Text(zones['ZonesDetails'][index]['name']),
                                          trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {

                                print(zones['ZonesDetails'][index]['governorate_id']);
                            },

                        ),

              );

      }
      ),
      )

  );


}