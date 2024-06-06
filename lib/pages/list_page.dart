import 'package:crud/services/firebase_service.dart';
import 'package:flutter/material.dart';

class PersonList extends StatefulWidget {
  const PersonList({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getPeople(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: ((context, index) {
                    final personData = snapshot.data?[index];
                    return Dismissible(
                      onDismissed: (direction) async {
                        await deletePeople(personData?['uid']);
                        snapshot.data?.removeAt(index);
                      },
                      confirmDismiss: (direction) async {
                        if (personData == null) return false;
                        bool result = false;
                        result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "¿Está seguro de querer eliminar a ${personData['name']}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancelar",
                                      style: TextStyle(color: Colors.red)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Sí, estoy seguro"),
                                ),
                              ],
                            );
                          },
                        );
                        return result;
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      direction: DismissDirection.endToStart,
                      key: Key(snapshot.data?[index]['uid']),
                      child: ListTile(
                        title: Text(snapshot.data?[index]['name'] ??
                            'Nombre Desconocido'),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/edit',
                              arguments: {
                                'name': snapshot.data?[index]['name'],
                                'uid': snapshot.data?[index]['uid'],
                              });
                          setState(() {});
                        },
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
