/*
You don't need context.watch inside a bloc builder.
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/authentication_bloc.dart';
import 'bloc/user_bloc.dart';
import 'cubit/guestbook_cubit.dart';
import 'widgets/authentication.dart';
import 'widgets/widgets.dart';

void main() {
  runApp(
    // we will create the UserBloc instance one context above
    // and before passing it into the AuthenticationBloc
    // since otherwise we will have bloc not found in the
    // specified context exception.
    BlocProvider<UserBloc>(
      create: (_) => UserBloc(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(context.read<UserBloc>()),
        ),
        BlocProvider<GuestbookCubit>(
          create: (context) => GuestbookCubit(context.read<UserBloc>()),
        )
      ],
      child: MaterialApp(
        title: 'Firebase Meetup',
        theme: ThemeData(
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                highlightColor: Colors.deepPurple,
              ),
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          const Authentication(),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  if (context.watch<UserBloc>().state.user != null) ...[
                    const Header('Discussion'),
                    GuestBook(
                      addMessage: (message) =>
                          context.read<GuestbookCubit>().addDocumentToGuestbook(message),
                    ),
                  ]
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
