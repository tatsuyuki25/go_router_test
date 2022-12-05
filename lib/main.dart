import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'page1/:id',
          name: 'page1',
          builder: (context, state) => Page1Screen(
            id: int.parse(state.params['id'] ?? '0'),
            someParams: int.parse(state.queryParams['someParams'] ?? '0'),
          ),
        ),
        GoRoute(
          path: 'page2',
          name: 'page2',
          builder: (context, state) => const Page2Screen(),
        ),
        GoRoute(
          path: 'page3',
          name: 'page3',
          builder: (context, state) => const Page3Screen(),
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemExtent: 100,
        itemCount: 20,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              goRouter.go(goRouter.namedLocation(
                'page1',
                params: {
                  'id': index.toString(),
                },
                queryParams: {'someParams': index.toString()},
              ));
            },
            child: Container(
              color: Colors.amber,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(index.toString()),
            ),
          );
        },
      ),
    );
  }
}

class Page1Screen extends StatefulWidget {
  const Page1Screen({
    super.key,
    required this.id,
    required this.someParams,
  });

  final int id;
  final int someParams;

  @override
  State<Page1Screen> createState() => _Page1ScreenState();
}

class _Page1ScreenState extends State<Page1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page1 id: ${widget.id}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('someParams: ${widget.someParams}'),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              child: const Text('go to page2'),
              onPressed: () {
                goRouter.pushNamed('page2');
              },
            )
          ],
        ),
      ),
    );
  }
}

class Page2Screen extends StatefulWidget {
  const Page2Screen({super.key});

  @override
  State<Page2Screen> createState() => _Page2ScreenState();
}

class _Page2ScreenState extends State<Page2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('page2'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('go to page3'),
          onPressed: () {
            goRouter.pushNamed('page3');
          },
        ),
      ),
    );
  }
}

class Page3Screen extends StatefulWidget {
  const Page3Screen({super.key});

  @override
  State<Page3Screen> createState() => _Page3ScreenState();
}

class _Page3ScreenState extends State<Page3Screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('page3'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _onBack,
            child: const Text('back to page1'),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBack() async {
    final matches = goRouter.routerDelegate.currentConfiguration.matches;
    final route = matches
        .lastWhereOrNull((value) => value.fullpath.startsWith('/page1/:id'));
    if (route == null) {
      return false;
    }
    goRouter.go(goRouter.namedLocation('page1',
        params: route.decodedParams, queryParams: route.queryParams));
    return false;
  }
}
