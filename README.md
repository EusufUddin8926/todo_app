# Draft - Todo App

An elegant task-taking app written in Flutter that uses Isar DB for local storage and `flutter_local_notifications` for reminders.

## Features

1. **Login Modality**: Users can log in with email and password. Once logged in, there's no need to log in again until they log out.
2. **Minimalistic Design**: A clean and simple UI for a seamless user experience.
3. **CRUD Operations**: Users can add, edit, delete tasks, and mark them as completed.
4. **Notifications**: Schedule reminders for tasks with the `flutter_local_notifications` package.
5. **Dark Mode**: Light and dark theme variants for the app.
6. **Edit Notes**: Edit previously saved notes.
7. **Local Storage**: Stores data locally using Isar DB for offline access.
8. **Image Integration**: Users can add images to their notes using the `image_picker` package.
9. **Custom Themes**: Implemented with `get` package for state management and `get_storage` for persisting user preferences.

## Dependencies

- `fluttertoast: ^8.2.4`
- `get: ^4.6.5`
- `get_it`
- `intl`
- `shared_preferences`
- `isar: ^3.1.0+1`
- `isar_flutter_libs: ^3.1.0+1`
- `path_provider: ^2.0.2`
- `permission_handler: ^11.3.0`
- `image: ^4.1.7`
- `google_fonts: ^6.2.1`
- `cupertino_icons: ^1.0.6`
- `flutter_svg: ^2.0.10+1`
- `dart_jsonwebtoken: ^2.14.0`
- `image_picker: ^0.8.7+4`
- `flutter_datetime_picker_plus: ^2.1.0`
- `get_storage`
- `timezone: ^0.9.1`
- `date_picker_timeline: ^1.2.3`
- `flutter_staggered_animations`
- `flutter_local_notifications`

## Run the Project

- With Flutter installed, clone the project and run `flutter run --release` in that directory.
- Alternatively, download the built APK from [here](https://drive.google.com/drive/folders/1GiX4zkn9gbjR7pc9Gr4F-04MQqXOYLWh?usp=sharing).

## Screenshots

| ![login_screen](https://github.com/user-attachments/assets/32410e27-bd40-46ae-9b65-f1c0fa151fa3) | ![note_screen](https://github.com/user-attachments/assets/f83df247-ecce-4703-a1e4-960deefa40f6) |
| ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| ![add_screen](https://github.com/user-attachments/assets/9f725f87-f149-43e9-b5ef-9f87dc340be9)    | ![update_screen](https://github.com/user-attachments/assets/04f004f3-4737-404c-97ac-e916f83f51d9) |

This is a GitHub `README.md` file script based on your project.
