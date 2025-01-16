import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserPopup extends StatelessWidget {
  SearchUserPopup();

  final MenuController controller = MenuController();

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search names, roles or teams',
              prefixIcon: Icon(Icons.search),
              prefixIconConstraints: BoxConstraints.tight(Size(30, 30)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.25)),
              isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.25)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.blue, width: 1.25)),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 10),
          // Suggested people
          const Text(
            'Suggested people',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Suggested Person Row
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.redAccent,
              child: Text(
                'I',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: const Text(
              'Ibrahim',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              // Add functionality for selecting this user
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          // Invite by email
          ListTile(
            leading: Icon(Icons.person_add_alt_1_outlined,
                color: Colors.grey.shade700),
            title: const Text(
              'Invite a new member by email',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            onTap: () {
              // Add functionality for inviting user
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 10),
          // Hold info
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Hold ',
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      CupertinoIcons.command,
                      color: Colors.black54,
                      size: 14.5,
                    )),
                const SizedBox(width: 4),
                Text(
                  'for a multiple selection',
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
