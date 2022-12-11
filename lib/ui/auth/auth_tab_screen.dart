import 'package:flutter/material.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:flutter/services.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/ui/auth/login_screen.dart';
import 'package:warshat/ui/auth/register_screen.dart';

class AuthTabScreen extends StatefulWidget {
  final selectedPage;
  const AuthTabScreen({Key key, this.selectedPage}) : super(key: key);

  @override
  _AuthTabScreenState createState() => _AuthTabScreenState();
}

class _AuthTabScreenState extends State<AuthTabScreen>
    with SingleTickerProviderStateMixin, ValidationMixin {
  RegisterScreen _buildBodyItemRegister;
  TabController _tabController;
  double _height = 0, _width = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: (widget.selectedPage != null) ? widget.selectedPage : 0,
        length: 2,
        vsync: this);
  }

  final TextEditingController controller = TextEditingController();

  Widget _buildBodyItem() {
    return Container(
      width: _width,
      height: _height,
      margin: EdgeInsets.only(right: 20, left: 20),
      child: Column(
        children: [
          Container(
            height: _height * 0.12,
            child: Image.asset(
              'assets/images/Group3831.png',
              height: _height * 0.12,
              width: _width * 0.4,
              fit: BoxFit.contain,
            ),
          ),
          TabBar(
        
            tabs: [
             
              Tab(
                  child: Text('تسجيل الدخول',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                      ))),
              Tab(
                  child: Text('حساب جديد ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                      ))),
            ],
            indicatorColor: mainAppColor,
            unselectedLabelColor: Colors.black,
            labelColor: mainAppColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            isScrollable: true,
            controller: _tabController,
          ),

          Expanded(
            child: TabBarView(
              children: [
                Container(
                  child: LoginScreen(),
                ),
                Container(
                  child: RegisterScreen(),
                ),
              ],
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PageContainer(
        child: Scaffold(
          body: _buildBodyItem(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
