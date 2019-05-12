import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helius/theme/theme_bloc.dart';
import 'user_repository/user_repository.dart';

import 'authentication/authentication.dart';
import 'reddit/reddit.dart';
import 'settings/settings.dart';
import 'theme/theme.dart';
import 'splash/splash.dart';
import 'login/login.dart';
import 'home/home.dart';
import 'common/common.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository, }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  SettingsBloc _settingsBloc;
  ThemeBloc _themeBloc = ThemeBloc();
  RedditBloc _redditBloc = RedditBloc();
  // UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {

    // _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    // _authenticationBloc.dispatch(AppStarted());

    _settingsBloc = SettingsBloc();

    _themeBloc.dispatch(AppLoaded());
    super.initState();
  }

  @override
  void dispose() {
    // _authenticationBloc.dispose();
    _settingsBloc.dispose();
    _themeBloc.dispose();
    _redditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProviderTree(
        blocProviders: [
          BlocProvider<RedditBloc>(bloc: _redditBloc,),
          BlocProvider<ThemeBloc>(bloc: _themeBloc,),
          // BlocProvider<AuthenticationBloc>(bloc: _authenticationBloc),
          BlocProvider<SettingsBloc>(bloc: _settingsBloc),

        ],
        child: BlocBuilder(
          bloc: _redditBloc,
          builder: (BuildContext context, RedditState redditState) {
            return MaterialApp(
              title: 'Helius',
              home: _pageHandler(redditState, context)

            );
          },
        )

            
    );


    // return BlocProvider<AuthenticationBloc>(
    //   bloc: _authenticationBloc,
    //   child: MaterialApp(
    //     home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
    //       bloc: _authenticationBloc,
    //       builder: (BuildContext context, AuthenticationState state) {
    //         if (state is AuthenticationUninitialized) {
    //           return SplashPage();
    //         }
    //         if (state is AuthenticationAuthenticated) {
    //           return HomePage();
    //         }
    //         if (state is AuthenticationUnauthenticated) {
    //           return LoginPage(userRepository: _userRepository);
    //         }
    //         if (state is AuthenticationLoading) {
    //           return LoadingIndicator();
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
  Widget _pageHandler(redditState, context) {
    if (redditState is RedditIsUninitialized) {
      _redditBloc.dispatch(InitializeReddit());
      return SplashPage();
    }
    if(redditState is RedditIsInitialized) {
      return HomePage(context);
    }
    // if(redditState is RedditIsInitializing) {
    //   return LoadingIndicator();
    // }
      return LoadingIndicator();


  //   if (state is RedditIsUninitialized) {
  //     return HomePage();
  //   }
  //   if (state is AuthenticationUnauthenticated) {
  //     return LoginPage(userRepository: _userRepository);
  //   }
  //   if (state is AuthenticationLoading) {
  //     return LoadingIndicator();
  //   }
  // }
}
}
