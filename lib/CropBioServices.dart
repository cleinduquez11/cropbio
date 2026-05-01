import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class _Service {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const _Service({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        body: Column(
          children: [
            ResponsiveTitleBar(title: "CropBio Services"),
            ResponsiveNavBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// ================= HERO =================
                    _ServicesHero(),

                    /// ================= SERVICES GRID =================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Our Capabilities",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Comprehensive solutions for crop research, geospatial analysis, and biodiversity monitoring.",
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(height: 40),
                              _ServicesGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// ================= PROCESS =================
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: const _ServiceProcess(),
                        ),
                      ),
                    ),

                    /// ================= CTA =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 100, horizontal: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2F4F2F),
                            Color(0xFF1E2E1E),
                          ],
                        ),
                      ),
                      child: const _ServiceCTA(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F4F2F),
            Color(0xFF1E2E1E),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_Logo_Dark.svg",
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "CropBio Research & Data Services",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Empowering agriculture through data, remote sensing, and scientific research.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  @override
  Widget build(BuildContext context) {
    final services = [
      _Service(
        title: "Drone Mapping",
        description:
            "High-resolution orthomosaic and field analysis using UAVs.",
        icon: Icons.flight,
        route: "/drone",
      ),
      _Service(
        title: "GIS & Spatial Analysis",
        description: "Mapping, shapefiles, and geospatial data processing.",
        icon: Icons.map,
        route: "/gis",
      ),
      _Service(
        title: "Crop Monitoring",
        description: "NDVI, vegetation health, and temporal analysis.",
        icon: Icons.eco,
        route: "/monitoring",
      ),
      _Service(
        title: "Data Analytics",
        description: "Crop statistics, reports, and predictive insights.",
        icon: Icons.analytics,
        route: "/analytics",
      ),
      _Service(
        title: "Research Collaboration",
        description: "Partner with us for academic and institutional studies.",
        icon: Icons.groups,
        route: "/collaboration",
      ),
      _Service(
        title: "Data Access & API",
        description:
            "Structured datasets available for integration and research.",
        icon: Icons.storage,
        route: "/data",
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800
                ? 3
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (_, i) {
            return _ServiceCard(service: services[i]);
          },
        );
      },
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final _Service service;

  const _ServiceCard({required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.service.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: hover
              ? (Matrix4.identity()..translate(0, -8))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.08),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.service.icon,
                  size: 40, color: const Color(0xFF3F6B2A)),
              const SizedBox(height: 20),
              Text(
                widget.service.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.service.description,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ServiceCTA extends StatelessWidget {
  const _ServiceCTA();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Work With CropBio",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Partner with us for data-driven agricultural research and solutions.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6A432),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          ),
          onPressed: () {},
          child: const Text("Request a Service"),
        )
      ],
    );
  }
}


class _ServiceProcess extends StatelessWidget {
  const _ServiceProcess();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        final steps = [
          _ProcessStep(
            title: "Request",
            description: "Submit your data or service request.",
            icon: Icons.send,
          ),
          _ProcessStep(
            title: "Collect",
            description: "Field data, drone capture, or dataset gathering.",
            icon: Icons.cloud_download,
          ),
          _ProcessStep(
            title: "Analyze",
            description: "Processing, validation, and analytics.",
            icon: Icons.analytics,
          ),
          _ProcessStep(
            title: "Deliver",
            description: "Final outputs, reports, and datasets.",
            icon: Icons.check_circle,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How It Works",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "A streamlined workflow from request to delivery of research-grade outputs.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 40),

            isMobile
                ? Column(
                    children: steps
                        .map((step) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _ProcessCard(step: step),
                            ))
                        .toList(),
                  )
                : Row(
                    children: List.generate(steps.length * 2 - 1, (index) {
                      if (index.isEven) {
                        return Expanded(
                          child: _ProcessCard(
                            step: steps[index ~/ 2],
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF3F6B2A),
                          ),
                        );
                      }
                    }),
                  ),
          ],
        );
      },
    );
  }
}

class _ProcessStep {
  final String title;
  final String description;
  final IconData icon;

  _ProcessStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _ProcessCard extends StatefulWidget {
  final _ProcessStep step;

  const _ProcessCard({required this.step});

  @override
  State<_ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<_ProcessCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: hover
            ? (Matrix4.identity()..translate(0, -6))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.06),
            )
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF3F6B2A).withOpacity(0.1),
              child: Icon(
                widget.step.icon,
                color: const Color(0xFF3F6B2A),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.step.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.step.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}