import 'package:flutter/material.dart';
import 'package:flutter_app/index.dart';
import 'package:flutter_app/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MaterialApp(title: "HagLex", home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
    HttpLink(uri: "https://hagglex-backend.herokuapp.com/graphql");
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyOGMyMDU0OC1mNGUxLTRiOTgtOGY4My00MGFjZmYyODEzNjQiLCJpYXQiOjE2MDAyNjA1ODAsImV4cCI6MTYwMDM0Njk4MH0.zcQm4fxfrVOQYxciVZi1gs0jBsn-IMey6De9GoZ2FbQ',
      // OR
      // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    );
    final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  bool showSpinner = false;


  final String register = """
                  mutation(\$email: String!,\$username:String!,\$password:String!, \$phonenumber:String!,
  \$referralCode:String!,){
  
  register(data: { email: \$email, username:\$username, 
    password:\$password, phonenumber:\$phonenumber,referralCode:\$referralCode,
    phoneNumberDetails:{phoneNumber:\$phonenumber, callingCode:"889", flag:"green"}
     }) {
    user{
      email
      username
      phonenumber
      referralCode
      phoneNumberDetails{
        phoneNumber
        callingCode
        flag
      }
      
    }
    token
  }
}
                  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hagglex Authentication"),
      ),
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Mutation(
            options: MutationOptions(
              documentNode: gql(register), // this is the mutation string you just created
              // you can update the cache based on results
              update: (Cache cache, QueryResult result) {
                return cache;
              },
              // or do something with the result.data on completion
              onCompleted: (dynamic resultData) {
                print(resultData);

                setState(() {
                  showSpinner = false;
                });

                if(resultData == null){
                  Fluttertoast.showToast(
                      msg: "Sorry You have Already Registered",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                }else{
                  Fluttertoast.showToast(
                      msg: "Registration Successful",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.green,
                      textColor: Colors.white);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: HomeView()));
                }

              },
            ),
            builder: ( RunMutation runMutation, QueryResult result,){
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Registration Authentication"),
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(

                                  hintText: 'Enter username',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController,
                                decoration: InputDecoration(

                                  hintText: 'Enter password',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: referralController,
                                decoration: InputDecoration(

                                  hintText: 'Enter referral Code',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: phoneController,
                                decoration: InputDecoration(

                                  hintText: 'Enter phone number',
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("sign up"),
                            onPressed: () {
                              if (emailController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Fill all input fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                              else if (passwordController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Fill all input fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                              else if (phoneController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Fill all input fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                              else if (referralController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Fill all input fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                              else if (usernameController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Fill all input fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                              else{
                                setState(() {
                                  showSpinner = true;
                                });
                                runMutation({
                                  "email": emailController.text,
                                  "username": usernameController.text,
                                  "password": passwordController.text,
                                  "phonenumber": phoneController.text,
                                  "referralCode": referralController.text

                                });
                              }


                            }
                        ),
                        RaisedButton(
                          child: Text("Log In"),
                          onPressed: (){
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: LoginApp()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );

            },

          ),
        ),
      ),
    );
  }
}