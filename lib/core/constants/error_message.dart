import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// === Model ===
class Test {
  final int id;
  final String content;

  Test({required this.id, required this.content});
}

// 1️⃣ Persistent Provider (cached until manually invalidated)
final persistentTestProvider = FutureProvider<Test>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return Test(id: 1, content: "Persistent Test");
});

// 2️⃣ Always Refetch Provider (autoDispose)
final alwaysRefetchTestProvider = FutureProvider.autoDispose<Test>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return Test(id: 2, content: "Always Refetch Test");
});

// 3️⃣ Stale Time Provider (custom stale time logic)
Test? _cachedValue;
final Map<String, DateTime> _lastFetched = {};

final staleTimeTestProvider = FutureProvider<Test>((ref) async {
  final lastFetched = _lastFetched["staleTimeTest"];
  final now = DateTime.now();

  if (lastFetched != null &&
      now.difference(lastFetched) < const Duration(seconds: 10)) {
    return _cachedValue!;
  }

  await Future.delayed(const Duration(seconds: 1));
  final test = Test(id: 3, content: "Stale Time Test");
  _cachedValue = test;
  _lastFetched["staleTimeTest"] = now;
  return test;
});

// 4️⃣ Parameterized Provider (family)
final paramTestProvider = FutureProvider.family<Test, int>((ref, id) async {
  await Future.delayed(const Duration(seconds: 1));
  return Test(id: id, content: "Test with ID $id");
});

// 5️⃣ Manual Fetch Provider (StateNotifier)
final manualTestProvider =
    StateNotifierProvider<ManualTestNotifier, AsyncValue<Test>>(
      (ref) => ManualTestNotifier(),
    );

class ManualTestNotifier extends StateNotifier<AsyncValue<Test>> {
  ManualTestNotifier() : super(const AsyncValue.loading());

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncValue.data(Test(id: 5, content: "Manual Fetch Test"));
  }
}

// === Demo App ===
class ProviderExamplesScreen extends ConsumerWidget {
  const ProviderExamplesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persistent = ref.watch(persistentTestProvider);
    final always = ref.watch(alwaysRefetchTestProvider);
    final stale = ref.watch(staleTimeTestProvider);
    final param = ref.watch(paramTestProvider(99));
    final manual = ref.watch(manualTestProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Riverpod Provider Examples")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: "Persistent Provider",
            asyncValue: persistent,
            onRefetch: () => ref.invalidate(persistentTestProvider),
          ),
          _buildCard(
            title: "Always Refetch Provider",
            asyncValue: always,
            onRefetch: () => ref.invalidate(alwaysRefetchTestProvider),
          ),
          _buildCard(
            title: "Stale Time Provider (10s)",
            asyncValue: stale,
            onRefetch: () => ref.invalidate(staleTimeTestProvider),
          ),
          _buildCard(
            title: "Parameterized Provider (id: 99)",
            asyncValue: param,
            onRefetch: () => ref.invalidate(paramTestProvider(99)),
          ),
          _buildCard(
            title: "Manual Fetch Provider",
            asyncValue: manual,
            onRefetch: () => ref.read(manualTestProvider.notifier).fetch(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required AsyncValue<Test> asyncValue,
    required VoidCallback onRefetch,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            asyncValue.when(
              data: (test) => Text("${test.id}: ${test.content}"),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text("Error: $err"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRefetch, child: const Text("Refetch")),
          ],
        ),
      ),
    );
  }
}
