enum ContactsConnectionMode {
  server,
  sqlite,
}

class ContactsConnectionState {
  final ContactsConnectionMode mode;
  final String? sqliteDbFileName;

  const ContactsConnectionState({
    this.mode = ContactsConnectionMode.server,
    this.sqliteDbFileName,
  });

  bool get isSqlite =>
      mode == ContactsConnectionMode.sqlite && sqliteDbFileName != null;

  ContactsConnectionState copyWith({
    ContactsConnectionMode? mode,
    String? sqliteDbFileName,
    bool clearSqliteDb = false,
  }) {
    return ContactsConnectionState(
      mode: mode ?? this.mode,
      sqliteDbFileName:
          clearSqliteDb ? null : (sqliteDbFileName ?? this.sqliteDbFileName),
    );
  }
}
