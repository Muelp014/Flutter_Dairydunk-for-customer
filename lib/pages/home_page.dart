import 'dart:async';

import 'package:flutter/material.dart';
import 'package:DairyDunk/components/my_product_tile.dart';
import 'package:DairyDunk/components/mycurrentlocation.dart';
import 'package:DairyDunk/components/mydecorationbox.dart';
import 'package:DairyDunk/components/mytabbar.dart';
import 'package:DairyDunk/components/silverappbar.dart';
import 'package:DairyDunk/model/Product.dart';
import 'package:DairyDunk/model/List.dart';
import 'package:DairyDunk/pages/productpage.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void dispose() {
    _tabController .dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ProductCatagory.values.length, vsync: this);
  }

  List<Product> _filterMenuByCatagory(ProductCatagory catagory, List<Product> fullmenu){
    return fullmenu.where((Product)=>Product.catagory == catagory).toList();
  }
  List<Widget> getProductInThisCatagory(List<Product> fullmenu){
    return ProductCatagory.values.map((Catagory){
      List<Product> CatagoryMenu =_filterMenuByCatagory(Catagory, fullmenu);
  
      return ListView.builder(
        itemCount: CatagoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding:  EdgeInsets.zero,
        itemBuilder: (context, index) {
          
          final product = CatagoryMenu[index];

          return MyProductTile(
            product: product, 
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> Foodpages(product: product)))
            );
        });
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context , innerBoxIsScrolled)=>[
          MySilverAppBar(
            title: MytabBar(tabController: _tabController,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(indent: 25,endIndent: 25,color: Theme.of(context).colorScheme.secondary),
               //my location
              Mycurrentlocation(),
               //description box
              Mydecorationbox(),
            ],),

            )
        ],
        body: Consumer<Resturant>(
          builder: (context, Product,child)=>TabBarView(
            controller: _tabController,
            children: getProductInThisCatagory(Product.menu)
            ),
          ),
      ),
    );
  }
}
