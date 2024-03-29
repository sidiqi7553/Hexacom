import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  final String emailAddress;
  final bool fromSignUp;
  VerificationScreen({@required this.emailAddress, this.fromSignUp = false});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification ? ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : CustomAppBar(title: getTranslated('verify_email', context)):ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : CustomAppBar(title: getTranslated('assets/icon/bag.svg', context)),

      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context)? size.height - 400 : size.height),
                    child: SizedBox(
                      width: 1170,
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 55),
                            Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                            Image.asset(
                              Images.email_with_background,
                              width: 142,
                              height: 142,
                            ):Icon(Icons.phone_android_outlined,size: 50,color: Theme.of(context).primaryColor,),

                            SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Center(
                                  child: Text(
                                    '${getTranslated('please_enter_4_digit_code', context)}\n +${emailAddress.trim()}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                              child: PinCodeTextField(
                                length: 4,
                                appContext: context,
                                obscureText: false,
                                showCursor: true,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldHeight: 63,
                                  fieldWidth: 55,
                                  borderWidth: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  selectedColor: ColorResources.colorMap[200],
                                  selectedFillColor: Colors.white,
                                  inactiveFillColor: ColorResources.getSearchBg(context),
                                  inactiveColor: ColorResources.colorMap[200],
                                  activeColor: ColorResources.colorMap[400],
                                  activeFillColor: ColorResources.getSearchBg(context),
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.transparent,
                                enableActiveFill: true,
                                onChanged: authProvider.updateVerificationCode,
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                            ),
                            Center(
                                child: Text(
                                  getTranslated('i_didnt_receive_the_code', context),
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    color: ColorResources.getGreyBunkerColor(context),
                                  ),
                                )),
                            Center(
                              child: InkWell(
                                onTap: () {

                                  if(fromSignUp) {
                                    Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                                    Provider.of<AuthProvider>(context, listen: false).checkEmail(emailAddress).then((value) {
                                      if (value.isSuccess) {
                                        showCustomSnackBar('Resent code successful', context, isError: false);
                                      } else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    }):Provider.of<AuthProvider>(context, listen: false).checkPhone(emailAddress).then((value) {
                                      if (value.isSuccess) {
                                        showCustomSnackBar('Resent code successful', context, isError: false);
                                      } else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }else {
                                    Provider.of<AuthProvider>(context, listen: false).forgetPassword(emailAddress).then((value) {
                                      if (value.isSuccess) {
                                        showCustomSnackBar('Resent code successful', context, isError: false);
                                      } else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Text(
                                    getTranslated('resend_code', context),
                                    style: Theme.of(context).textTheme.headline3.copyWith(
                                      color: ColorResources.getGreyBunkerColor(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 48),
                            authProvider.isEnableVerificationCode ? !authProvider.isPhoneNumberVerificationButtonLoading
                                ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                btnTxt: getTranslated('verify', context),
                                onTap: () {
                                  if(fromSignUp) {
                                    Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?

                                    Provider.of<AuthProvider>(context, listen: false).verifyEmail(emailAddress).then((value) {
                                      if(value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getCreateAccountRoute(emailAddress,"",""));
                                      }else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    }): Provider.of<AuthProvider>(context, listen: false).verifyPhone("+"+emailAddress.trim()).then((value) {
                                      if(value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getCreateAccountRoute(emailAddress,"",""));
                                      }else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }else {
                                    String _mail = Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification
                                        ? '+'+emailAddress.trim() : emailAddress;
                                    Provider.of<AuthProvider>(context, listen: false).verifyToken(_mail).then((value) {
                                      if(value.isSuccess) {
                                        Navigator.pushNamed(context, Routes.getNewPassRoute(_mail, authProvider.verificationCode));
                                      }else {
                                        showCustomSnackBar(value.message, context);
                                      }
                                    });
                                  }
                                },
                              ),
                            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
