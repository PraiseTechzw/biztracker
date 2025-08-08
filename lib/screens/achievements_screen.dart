import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/engagement_service.dart';
import '../utils/glassmorphism_theme.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final EngagementService _engagementService = EngagementService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E293B)],
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(),
            _buildStatsCard(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAchievementsTab(),
                  _buildGoalsTab(),
                  _buildChallengesTab(),
                  _buildLeaderboardTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Achievements & Goals',
            style: TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _engagementService.checkForNewAchievements();
              });
            },
            icon: const Icon(
              Icons.refresh,
              color: GlassmorphismTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphismTheme.glassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Level',
                  '${_engagementService.level}',
                  Icons.star,
                  Colors.amber,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Points',
                  '${_engagementService.totalPoints}',
                  Icons.emoji_events,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Streak',
                  '${_engagementService.streak} days',
                  Icons.local_fire_department,
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Achievements',
                  '${_engagementService.getUnlockedAchievements().length}',
                  Icons.workspace_premium,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: GlassmorphismTheme.textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphismTheme.glassmorphismContainer(
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: GlassmorphismTheme.primaryColor.withOpacity(0.3),
          ),
          labelColor: GlassmorphismTheme.primaryColor,
          unselectedLabelColor: GlassmorphismTheme.textColor.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Achievements'),
            Tab(text: 'Goals'),
            Tab(text: 'Challenges'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _engagementService.checkForNewAchievements();
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Unlocked Achievements',
              Icons.workspace_premium,
            ),
            const SizedBox(height: 16),
            _buildAchievementsGrid(
              _engagementService.getUnlockedAchievements(),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Locked Achievements', Icons.lock),
            const SizedBox(height: 16),
            _buildAchievementsGrid(_engagementService.getLockedAchievements()),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsGrid(List achievements) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(achievement) {
    final isUnlocked = achievement.isUnlocked;

    return GlassmorphismTheme.glassmorphismContainer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 30,
                    color: isUnlocked ? achievement.color : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              achievement.title,
              style: TextStyle(
                color: isUnlocked ? GlassmorphismTheme.textColor : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: TextStyle(
                color: isUnlocked
                    ? GlassmorphismTheme.textColor.withOpacity(0.7)
                    : Colors.grey.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${achievement.points} pts',
                style: TextStyle(
                  color: isUnlocked ? achievement.color : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isUnlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Unlocked ${DateFormat('MMM dd').format(achievement.unlockedAt!)}',
                style: TextStyle(color: achievement.color, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _engagementService.checkForGoalProgress();
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Active Goals', Icons.flag),
            const SizedBox(height: 16),
            _buildGoalsList(_engagementService.getActiveGoals()),
            const SizedBox(height: 32),
            _buildSectionHeader('Completed Goals', Icons.check_circle),
            const SizedBox(height: 16),
            _buildGoalsList(_engagementService.getCompletedGoals()),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList(List goals) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return _buildGoalCard(goal);
      },
    );
  }

  Widget _buildGoalCard(goal) {
    final progress = _engagementService.getGoalProgress(goal);
    final isCompleted = goal.isCompleted;
    final isExpired = DateTime.now().isAfter(goal.deadline);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismTheme.glassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.flag,
                    color: isCompleted ? Colors.green : Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          goal.description,
                          style: TextStyle(
                            color: GlassmorphismTheme.textColor.withOpacity(
                              0.7,
                            ),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${goal.rewardPoints} pts',
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${goal.currentValue.toStringAsFixed(2)} / \$${goal.targetValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Deadline: ${DateFormat('MMM dd, yyyy').format(goal.deadline)}',
                style: TextStyle(
                  color: isExpired && !isCompleted
                      ? Colors.red
                      : GlassmorphismTheme.textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _engagementService.checkForChallengeProgress();
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Active Challenges', Icons.sports_esports),
            const SizedBox(height: 16),
            _buildChallengesList(_engagementService.getActiveChallenges()),
            const SizedBox(height: 32),
            _buildSectionHeader('Completed Challenges', Icons.emoji_events),
            const SizedBox(height: 16),
            _buildChallengesList(_engagementService.getCompletedChallenges()),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesList(List challenges) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return _buildChallengeCard(challenge);
      },
    );
  }

  Widget _buildChallengeCard(challenge) {
    final progress = _engagementService.getChallengeProgress(challenge);
    final isCompleted = challenge.isCompleted;
    final isExpired = DateTime.now().isAfter(challenge.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismTheme.glassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCompleted ? Icons.emoji_events : Icons.sports_esports,
                    color: isCompleted ? Colors.orange : Colors.purple,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            color: GlassmorphismTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            color: GlassmorphismTheme.textColor.withOpacity(
                              0.7,
                            ),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${challenge.rewardPoints} pts',
                      style: TextStyle(
                        color: isCompleted ? Colors.orange : Colors.purple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${challenge.currentValue.toStringAsFixed(2)} / \$${challenge.targetValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: isCompleted ? Colors.orange : Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.orange : Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ends: ${DateFormat('MMM dd, yyyy').format(challenge.endDate)}',
                style: TextStyle(
                  color: isExpired && !isCompleted
                      ? Colors.red
                      : GlassmorphismTheme.textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _engagementService.updateLeaderboard();
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Leaderboard', Icons.leaderboard),
            const SizedBox(height: 16),
            _buildLeaderboardList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    final leaderboard = _engagementService.leaderboard;

    if (leaderboard.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.leaderboard,
              size: 64,
              color: GlassmorphismTheme.textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No leaderboard data available',
              style: TextStyle(
                color: GlassmorphismTheme.textColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Leaderboards will be available when more businesses join!',
              style: TextStyle(
                color: GlassmorphismTheme.textColor.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return _buildLeaderboardCard(entry, index + 1);
      },
    );
  }

  Widget _buildLeaderboardCard(entry, int rank) {
    Color rankColor;
    IconData rankIcon;

    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = Colors.grey;
        rankIcon = Icons.workspace_premium;
        break;
      case 3:
        rankColor = Colors.orange;
        rankIcon = Icons.military_tech;
        break;
      default:
        rankColor = Colors.blue;
        rankIcon = Icons.star;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismTheme.glassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(rankIcon, color: rankColor, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.businessName,
                      style: const TextStyle(
                        color: GlassmorphismTheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rank #$rank',
                      style: TextStyle(
                        color: rankColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${entry.points} pts',
                    style: const TextStyle(
                      color: GlassmorphismTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd').format(entry.lastUpdated),
                    style: TextStyle(
                      color: GlassmorphismTheme.textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: GlassmorphismTheme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: GlassmorphismTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
