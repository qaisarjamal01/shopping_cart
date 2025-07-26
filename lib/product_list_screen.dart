import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {


  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://images.pexels.com/photos/7543212/pexels-photo-7543212.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/207085/pexels-photo-207085.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/60021/grapes-wine-fruit-vines-60021.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/7194965/pexels-photo-7194965.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1394423/pexels-photo-1394423.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/209416/pexels-photo-209416.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/8447093/pexels-photo-8447093.jpeg?auto=compress&cs=tinysrgb&w=600'
  ] ;

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                isLabelVisible: true,
                label: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),

          SizedBox(width: 20.0)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Image(
                                  height: 100,
                                  width: 100,
                                  image: NetworkImage(productImage[index].toString()),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString() ,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(productUnit[index].toString() +" "+r"$"+ productPrice[index].toString() ,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 5,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: (){
                                          print(index);
                                          print(index);
                                          print(productName[index].toString());
                                          print( productPrice[index].toString());
                                          print( productPrice[index]);
                                          print('1');
                                          print(productUnit[index].toString());
                                          print(productImage[index].toString());

                                          dbHelper!.insert(
                                              Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName: productName[index].toString(),
                                                  initialPrice: productPrice[index],
                                                  productPrice: productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  image: productImage[index].toString())
                                          ).then((value){

                                            cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                            cart.addCounter();

                                            final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                          }).onError((error, stackTrace){
                                            print("error"+error.toString());
                                            final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          });
                                        },
                                        child:  Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: const Center(
                                            child:  Text('Add to cart' , style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),

        ],
      ),
    );
  }
}