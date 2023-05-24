import 'package:flutter/material.dart';
import 'package:testapp/theme/colors.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 15,right:15,top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
             Text(
                    'Hi,',
                    style: textStyle.headlineMedium!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Vyshna Kalerikkal',
                    style: textStyle.titleMedium!.copyWith(
                      fontSize: 16,
                      color: AppColors.primary.withOpacity(0.75),
                    ),
                  ),
                   const SizedBox(height: 4),
            Expanded(
              child: GridView.builder(shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                  
              ),
              itemCount: 50,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.amber,
                  child: Center(child: Text('$index')),
                );
              },),
            ),
          ],
        ),
      ),);
  }



}