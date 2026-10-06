import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Manager _manager;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Manager, BlocState>(
      listener: (context, state) {
        if (state is Update_Profile_SuccessState) {
          setState(() {
            isEditing = false;
            passwordController.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Profile updated successfully"),
            ),
          );
        }

        if (state is Update_Profile_ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (_manager.isProfileLoaded) {
          firstNameController = TextEditingController(
            text: _manager.profileModel.firstname,
          );
          lastNameController = TextEditingController(
            text: _manager.profileModel.lastname,
          );
          emailController = TextEditingController(
            text: _manager.profileModel.email,
          );
        }
        return AsyncView(
          isLoading: state is Get_Profile_LoadingState,
          error: state is Get_Profile_ErrorState ? state.error : null,
          onRetry: () {
            _manager.isProfileLoaded = false;
            _manager.getProfile();
          },
          child: _manager.isProfileLoaded
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      _header(),

                      const SizedBox(height: 25),

                      _field(
                        title: "First Name",
                        icon: Icons.person_outline,
                        controller: firstNameController,
                      ),

                      const SizedBox(height: 15),

                      _field(
                        title: "Last Name",
                        icon: Icons.person,
                        controller: lastNameController,
                      ),

                      const SizedBox(height: 15),

                      _field(
                        title: "Email",
                        icon: Icons.email_outlined,
                        controller: emailController,
                        readOnly: true,
                      ),

                      const SizedBox(height: 15),

                      _field(
                        title: "Created At",
                        icon: Icons.access_time,
                        controller: TextEditingController(
                          text: _manager.profileModel.createdAt,
                        ),
                        readOnly: true,
                      ),

                      const SizedBox(height: 15),

                      _field(
                        title: "Updated At",
                        icon: Icons.update,
                        controller: TextEditingController(
                          text: _manager.profileModel.lastUpdatedAt,
                        ),
                        readOnly: true,
                      ),

                      const SizedBox(height: 25),

                      if (isEditing) ...[
                        _field(
                          title: "Enter your password",
                          icon: Icons.lock_outline,
                          controller: passwordController,
                        ),

                        const SizedBox(height: 20),
                        (state is Update_Profile_LoadingState)
                            ? CircularProgressIndicator()
                            : Reusable.button('Update Profile', () {
                                _manager.updateProfile({
                                  'firstname': firstNameController.text.trim(),
                                  'lastname': lastNameController.text.trim(),
                                  'password': passwordController.text,
                                });
                              }),
                      ],
                    ],
                  ),
                )
              : SizedBox(),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [Constants.appSecondColor, Constants.appFirstColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_circle, color: Colors.white, size: 34),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isEditing ? Icons.close : Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Manage your account information",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xff7C3FE0)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            readOnly: !isEditing || readOnly,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ],
      ),
    );
  }
}
