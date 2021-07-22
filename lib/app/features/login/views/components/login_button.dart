part of login_view;

class _LoginButton extends LoginController {
   // _LoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: isLoading.value ? null : () =>login(),
        child: isLoading.value
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              )
            : Text("Login"),
      ),
    );
  }
}
