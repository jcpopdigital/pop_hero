import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Particle class for background animation
class Particle {
  double x;
  double y;
  double speed;
  double theta;
  double radius;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.theta,
    required this.radius,
  });

  void update(Size size) {
    x += cos(theta) * speed;
    y += sin(theta) * speed;

    if (x < 0) {
      x = size.width;
    } else if (x > size.width) {
      x = 0;
    }

    if (y < 0) {
      y = size.height;
    } else if (y > size.height) {
      y = 0;
    }
  }
}

// Custom painter for particle animation
class ParticleStorm extends CustomPainter {
  final List<Particle> particles;
  final Color particleColor;

  ParticleStorm({required this.particles, required this.particleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        paint,
      );
    }

    final linePaint = Paint()
      ..color = particleColor.withOpacity(0.2)
      ..strokeWidth = 1;

    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Particle background widget
class ParticleStormBackground extends StatefulWidget {
  final Widget child;
  final Color particleColor;

  const ParticleStormBackground({
    Key? key,
    required this.child,
    this.particleColor = Colors.white,
  }) : super(key: key);

  @override
  State<ParticleStormBackground> createState() => _ParticleStormBackgroundState();
}

class _ParticleStormBackgroundState extends State<ParticleStormBackground>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() {
      _updateParticles();
    });
  }

  void _initializeParticles() {
    particles = List.generate(50, (index) {
      return Particle(
        x: random.nextDouble() * 400,
        y: random.nextDouble() * 800,
        speed: 1 + random.nextDouble() * 2,
        theta: random.nextDouble() * 2 * pi,
        radius: 1 + random.nextDouble() * 2,
      );
    });
  }

  void _updateParticles() {
    setState(() {
      for (var particle in particles) {
        particle.update(MediaQuery.of(context).size);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.blue.shade900,
          child: CustomPaint(
            painter: ParticleStorm(
              particles: particles,
              particleColor: widget.particleColor,
            ),
            child: Container(),
          ),
        ),
        widget.child,
      ],
    );
  }
}

// Skill model
class Skill {
  final String name;
  final String? url;
  final String? description;

  const Skill({
    required this.name,
    this.url,
    this.description,
  });
}

// Main HeroProfile widget
class HeroProfile extends StatelessWidget {
  final List<Skill> skills = const [
    Skill(
      name: 'Flutter Development',
      url: '',
      description: '',
    ),
    Skill(
      name: 'Rise360',
      url: 'https://client-portfolio-lessons.s3.us-east-2.amazonaws.com/home.html',
      description: 'A handful of microlesson samples',
    ),
    Skill(
      name: 'ADAPT Framework',
      url: 'https://eot-jumpball.s3.us-east-2.amazonaws.com/x-build/index.html',
      description: 'Prototype for Entrepreneurs of Tomorrow',
    ),
  ];

  const HeroProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleStormBackground(
        particleColor: Colors.white.withOpacity(0.7),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: -50,
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                        ),
                        // Name and Title
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'JC Choi',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Content Section
              Container(
                padding: const EdgeInsets.fromLTRB(16, 66, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'About',
                      'Passionate instructional designer with deep technical background in GenAI and automation.',
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Contact',
                      'Email: jc.choi.popdigital@gmail.com\nPhone: +1 206 551 8619\nLocation: Seattle/Oakland',
                    ),
                    const SizedBox(height: 24),
                    _buildSkillsSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...skills.map((skill) => _buildSkillItem(context, skill)).toList(),
      ],
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: skill.url != null
            ? () => _launchURL(context, skill.url!)
            : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      skill.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (skill.url != null)
                    const Icon(
                      Icons.link,
                      size: 20,
                      color: Colors.blue,
                    ),
                ],
              ),
              if (skill.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  skill.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open link: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}