import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const PinterestCloneApp());
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Clone',
      // CONFIGURAÇÃO DO TEMA ESCURO (DARK MODE)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.black,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE60023), // Vermelho Pinterest
          secondary: Colors.white,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- NAVEGAÇÃO PRINCIPAL ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Search")),
    const Center(child: Text("Create")),
    const Center(child: Text("Notifications")),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 28,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Msg'),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop'),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// --- TELA HOME (CORRIGIDA) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Cabeçalho "For You"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column( // REMOVI O 'const' DAQUI
                  children: [
                    const Text(
                      "For you",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(height: 3, width: 40, color: Colors.white) // Container não pode ser const
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                )
              ],
            ),
          ),
          
          // Grid Infinito
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                itemCount: 40,
                itemBuilder: (context, index) {
                  return const PinterestPinItem(isHome: true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TELA DE PERFIL (ATUALIZADA) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BANNER E ÍCONES DE TOPO
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // IMAGEM DE FUNDO: Lugar calmo (lago e montanhas)
                      image: NetworkImage('https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=1000&auto=format&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.bar_chart, color: Colors.white),
                        ),
                        Row(
                          children: [
                             Container(padding:const EdgeInsets.all(6), decoration:const BoxDecoration(color:Colors.black54, shape:BoxShape.circle), child:const Icon(Icons.share, color: Colors.white)),
                             const SizedBox(width: 8),
                             Container(padding:const EdgeInsets.all(6), decoration:const BoxDecoration(color:Colors.black54, shape:BoxShape.circle), child:const Icon(Icons.more_horiz, color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 2. INFORMAÇÕES DO PERFIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mexi aqui para o avatar subir um pouco sobre o banner (estilo Pinterest)
                  Transform.translate(
                    offset: const Offset(0, -40), // Sobe o avatar 40 pixels
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4), // Borda preta ao redor do avatar
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: const CircleAvatar(
                            radius: 50, // Aumentei um pouco
                            // IMAGEM DE PERFIL: Homem
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Como subi o avatar, ajustei o espaçamento aqui (era -40, agora compenso)
                  Transform.translate(
                    offset: const Offset(0, -30), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Marcos Bittencourt", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text("@marcosb_dev", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text("1.2k followers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            SizedBox(width: 6),
                            Text("•", style: TextStyle(color: Colors.white)),
                            SizedBox(width: 6),
                            Text("340 following", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        const Text(
                          "não sei",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.link, color: Colors.white, size: 16), // Mudei icone para link
                            SizedBox(width: 6),
                            Text("bit.ly/marcos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10), // Ajustei espaço
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60023),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text("Creator Hub", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. ABAS (Created / Saved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Created", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const Text("Saved", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Container(height: 2, width: 50, color: Colors.white)
                    ],
                  ),
                ),
              ],
            ),

            // 4. BARRA DE BUSCA E EMPTY STATE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 10),
                              Text("Search your Pins", style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.add, color: Colors.white, size: 30),
                    ],
                  ),

                  const SizedBox(height: 50),
                  const Text("You haven't saved any ideas yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Find ideas"),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET DO PIN/CARD ---
class PinterestPinItem extends StatelessWidget {
  final bool isHome;
  const PinterestPinItem({super.key, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    final randomHeight = (Random().nextInt(150) + 180).toDouble();

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                isHome 
                 ? 'https://i.pinimg.com/236x/8d/62/8d/8d628d62810e75508855d045a1226074.jpg' 
                 : 'https://picsum.photos/200/${randomHeight.toInt()}', 
                height: randomHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(height: randomHeight, color: Colors.grey[900]),
              ),
            ),
            if (isHome && Random().nextBool()) 
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                  child: const Text("0:18", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.more_horiz, size: 16, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}