

part of login_view;
class _PhoneNumberField extends  LoginController{
   // _PhoneNumberField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: phoneNumber,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim() == "") return "";
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.grey,
            ),
            hintText: "phone number"),
      ),
    );
  }
}
