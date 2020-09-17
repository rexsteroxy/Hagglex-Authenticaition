import 'package:flutter/material.dart';
import 'package:flutter_app/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';


class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
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
      child: HomePageLogin(),
      client: client,
    );
  }
}

class HomePageLogin extends StatefulWidget {
  @override
  _HomePageLoginState createState() => _HomePageLoginState();
}

class _HomePageLoginState extends State<HomePageLogin> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  bool showSpinner = false;

  void clearControllers(){
    emailController.clear();

    passwordController.clear();

  }


  final String login = """
                 mutation(\$email: String!,\$password:String!){
  
  login(data: { email: \$email,
    password:\$password,
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Mutation(
          options: MutationOptions(
            documentNode: gql(login), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              print(resultData);
              clearControllers();
              setState(() {
                showSpinner = false;
              });

              if(resultData == null){
                Fluttertoast.showToast(
                    msg: "Incorrect Credentials",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                    textColor: Colors.white);
              }else{
                Fluttertoast.showToast(
                    msg: "Login Successful",
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
                  Text("Log In Authentication"),
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
                              controller: passwordController,
                              decoration: InputDecoration(

                                hintText: 'Enter password',
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
                        child: Text("Sign Up"),
                        onPressed: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: MyApp()));
                        },
                      ),
                      RaisedButton(
                          child: Text("Log in"),
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

                            else{
                              setState(() {
                                showSpinner = true;
                              });
                              runMutation({
                                "email": emailController.text,
                                "password": passwordController.text,

                              });
                            }


                          }
                      ),

                    ],
                  ),
                ],
              ),
            );

          },

        ),
      ),
    );
  }
}
