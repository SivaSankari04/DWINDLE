import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String name = "";
  String email = "";
  String phone = "";

  bool isDark = false;

  @override
  void initState() {
    super.initState();

    var box = Hive.box('userBox');

    name = box.get('name', defaultValue: "User");
    email = box.get('email', defaultValue: "No Email");
    phone = box.get('phone', defaultValue: "No Phone");

    isDark = Hive.box('settings')
        .get('darkMode', defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      isDark ? Colors.black : const Color(0xFFEAF5F1),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              /// 🔹 HEADER
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  IconButton(

                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color:
                      isDark ? Colors.white : Colors.black,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Text(
                    "My Profile",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                      isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  Row(
                    children: [

                      /// 🌙 DARK MODE SWITCH
                      Switch(

                        value: isDark,

                        onChanged: (value) {

                          setState(() {

                            isDark = value;

                            Hive.box('settings')
                                .put('darkMode', value);
                          });
                        },
                      ),

                      const SizedBox(width: 8),

                      const CircleAvatar(
                        radius: 18,
                        backgroundImage:
                        AssetImage('assets/profile.jpg'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔹 PROFILE CARD
              Container(

                decoration: BoxDecoration(

                  color: isDark
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 16),

                    const CircleAvatar(
                      radius: 45,
                      backgroundImage:
                      AssetImage('assets/profile.jpg'),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 USER NAME
                    Text(

                      name,

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:
                        isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child: Column(
                        children: [

                          _infoTile(
                            Icons.email_rounded,
                            email,
                            "Mail",
                          ),

                          const SizedBox(height: 12),

                          _infoTile(
                            Icons.phone_rounded,
                            phone,
                            "Phone",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              ///  DWINDLE CONTACT BUTTONS
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

                children: [

                  _InfoButton(
                    icon: Icons.phone,
                    label: "+91 9876543210",
                    color: Colors.teal,
                  ),

                  _InfoButton(
                    icon: Icons.email,
                    label: "dwindle.support@gmail.com",
                    color: Colors.green,
                  ),

                  _InfoButton(
                    icon: Icons.message,
                    label: "Text Us",
                    color: Colors.pinkAccent,
                  ),

                  _InfoButton(
                    icon: Icons.currency_rupee,
                    label: "Donate",
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 INFO TILE
  Widget _infoTile(
      IconData icon,
      String value,
      String label,
      ) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: isDark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF9F9F9),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Row(
            children: [

              Icon(icon, color: Colors.teal),

              const SizedBox(width: 10),

              Text(

                value,

                style: TextStyle(
                  fontSize: 16,
                  color:
                  isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),

          Text(

            label,

            style: TextStyle(
              color:
              isDark ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoButton extends StatefulWidget {

  final IconData icon;
  final String label;
  final Color color;

  const _InfoButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  State<_InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<_InfoButton> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        setState(() {
          isExpanded = !isExpanded;
        });
      },

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: widget.color.withOpacity(0.08),

          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          children: [

            CircleAvatar(

              backgroundColor:
              widget.color.withOpacity(0.15),

              radius: 26,

              child: Icon(
                widget.icon,
                color: widget.color,
                size: 26,
              ),
            ),

            const SizedBox(height: 8),

            AnimatedCrossFade(

              duration: const Duration(milliseconds: 250),

              firstChild: Text(

                widget.label.length > 8
                    ? widget.label.substring(0, 8)
                    : widget.label,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              secondChild: SizedBox(

                width: 100,

                child: Text(

                  widget.label,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}