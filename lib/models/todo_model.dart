class TodoNote {
  int id;
  int done;
  String title;

  TodoNote({this.id, this.done = 0, this.title});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'done': done, 'title': title};

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  TodoNote.fromMap(Map map) {
    id = map['id'];
    title = map['title'];
    done = map['done'];
  }
}
