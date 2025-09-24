# HealthChain 💪

> A decentralized wellness tracking platform that monitors health metrics, rewards healthy habits, and builds supportive wellness communities through blockchain technology

[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-purple)](https://stacks.co/)
[![Clarity](https://img.shields.io/badge/Smart_Contract-Clarity-blue)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Health](https://img.shields.io/badge/Focus-Wellness-brightgreen)](https://github.com/yourusername/healthchain)

## Overview

HealthChain revolutionizes personal wellness by creating a comprehensive blockchain-based ecosystem where healthy habits are rewarded, progress is permanently recorded, and communities support each other's wellness journeys. Users earn HealthChain Vitality Tokens (HVT) for consistent health tracking, goal achievement, and community contributions.

### Key Features

- **📊 Comprehensive Health Tracking** - Daily logging of physical, mental, and nutritional metrics
- **🎯 Goal Setting & Achievement** - Personalized wellness targets with progress monitoring
- **🏆 Wellness Challenges** - Community competitions promoting healthy behaviors
- **💡 Health Knowledge Sharing** - Expert tips and community wisdom exchange
- **🏅 Milestone Recognition** - Achievement badges for significant wellness progress
- **📈 Wellness Analytics** - Detailed insights into health patterns and trends
- **🤝 Community Support** - Peer encouragement and accountability systems
- **💰 Healthy Habit Rewards** - Token incentives for consistent wellness practices

## Getting Started

### Prerequisites

- [Clarinet CLI](https://github.com/hirosystems/clarinet) installed
- [Stacks Wallet](https://www.hiro.so/wallet) for blockchain interactions
- Node.js 16+ (for development and testing)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/healthchain-stacks
cd healthchain-stacks
```

2. Install dependencies
```bash
clarinet install
```

3. Run tests
```bash
clarinet test
```

4. Deploy to testnet
```bash
clarinet deploy --testnet
```

## Smart Contract Architecture

### Core Components

#### Token Economy (HVT)
- **Token Name**: HealthChain Vitality Token
- **Symbol**: HVT
- **Decimals**: 6
- **Max Supply**: 800,000 HVT
- **Philosophy**: Rewarding consistent wellness practices and community engagement

#### Wellness Ecosystem
- **Health Metrics Database**: Comprehensive tracking categories for physical and mental health
- **Daily Logging System**: Complete wellness data capture with mood and energy tracking
- **Goal Management**: Personal target setting with progress monitoring
- **Challenge Platform**: Community wellness competitions and group activities
- **Knowledge Hub**: Health tip sharing and community wisdom exchange

### Reward Structure

| Activity | HVT Reward | Purpose |
|----------|------------|---------|
| Daily Health Log | 25 HVT + Bonus | Consistent self-monitoring and awareness |
| Goal Achievement | 80 HVT | Reaching personal wellness targets |
| Wellness Milestone | 60 HVT | Celebrating significant progress markers |
| Health Tip Sharing | 40 HVT | Community knowledge contribution |
| Challenge Victory | 100 HVT | Competitive wellness achievement |
| Complete Health Day | 15 HVT Bonus | All metrics above healthy thresholds |

### Data Models

#### User Health Profile
```clarity
{
  username: (string-ascii 32),
  age-group: (string-ascii 8),         // "18-25", "26-35", etc.
  fitness-level: uint,                 // 1-5 current fitness assessment
  health-goals: uint,                  // Number of active goals
  daily-logs: uint,                    // Consistency tracking
  goals-achieved: uint,                // Success milestone count
  challenges-completed: uint,          // Community participation
  tips-shared: uint,                   // Knowledge contribution
  wellness-score: uint,                // 1-100 overall health score
  join-date: uint,
  last-activity: uint
}
```

#### Daily Health Tracking
```clarity
{
  steps-taken: uint,
  calories-consumed: uint,
  water-intake-ml: uint,
  sleep-hours: uint,
  exercise-minutes: uint,
  mood-rating: uint,                   // 1-10 emotional wellbeing
  stress-level: uint,                  // 1-10 stress assessment
  energy-level: uint,                  // 1-10 vitality measurement
  notes: (string-ascii 200)           // Personal observations
}
```

#### Health Goal Framework
```clarity
{
  user: principal,
  goal-title: (string-ascii 64),
  goal-type: (string-ascii 16),       // "weight", "steps", "exercise", "nutrition"
  target-value: uint,
  current-value: uint,
  target-date: uint,
  created-date: uint,
  progress-percentage: uint,
  achieved: bool,
  active: bool
}
```

## Core Functions

### Daily Wellness Tracking

#### `log-daily-health`
Record comprehensive daily health metrics
```clarity
(log-daily-health 
  u8500       ;; steps taken
  u2200       ;; calories consumed
  u2500       ;; water intake (ml)
  u8          ;; sleep hours
  u45         ;; exercise minutes
  u8          ;; mood rating (1-10)
  u4          ;; stress level (1-10)
  u7          ;; energy level (1-10)
  "Felt great after morning workout")
```

#### `add-health-metric`
Define custom health tracking categories
```clarity
(add-health-metric 
  "Blood Pressure" 
  "physical" 
  "mmHg" 
  u90 
  u120 
  "daily")
```

### Goal Management

#### `create-health-goal`
Set personal wellness targets
```clarity
(create-health-goal 
  "Daily Walking Goal" 
  "steps" 
  u10000 
  u30) ;; 30 days to achieve 10,000 steps daily
```

#### `update-goal-progress`
Track progress toward health objectives
```clarity
(update-goal-progress u1 u8500) ;; goal-id, current-value
```

### Community Features

#### `create-health-challenge`
Organize group wellness activities
```clarity
(create-health-challenge 
  "30-Day Step Challenge" 
  "Walk 10,000 steps daily for 30 days and improve cardiovascular health"
  "steps" 
  u30 
  u10000 
  u50)
```

#### `join-health-challenge`
Participate in community wellness competitions
```clarity
(join-health-challenge u1)
```

#### `share-health-tip`
Contribute wellness knowledge to the community
```clarity
(share-health-tip 
  "Hydration for Better Energy" 
  "Drinking water first thing in morning boosts metabolism and energy levels throughout the day"
  "nutrition" 
  u2)
```

### Milestone Achievement

#### `achieve-milestone`
Claim recognition for significant wellness progress
```clarity
(achieve-milestone 
  "fitness" 
  "First 5K Completion" 
  u5000) ;; milestone-type, name, metric-value
```

## Health Tracking Categories

### Physical Metrics
- **Activity**: Steps, exercise duration, calories burned
- **Nutrition**: Calorie intake, water consumption, meal quality
- **Sleep**: Duration, quality, sleep schedule consistency
- **Vital Signs**: Heart rate, blood pressure, weight trends

### Mental Wellness
- **Mood Tracking**: Daily emotional state assessment (1-10 scale)
- **Stress Management**: Stress level monitoring and coping strategies
- **Energy Levels**: Vitality and alertness throughout the day
- **Mindfulness**: Meditation, reflection, and mental health practices

### Goal Categories
- **Weight Management**: Healthy weight loss or gain targets
- **Fitness Improvement**: Strength, endurance, flexibility goals
- **Habit Formation**: Daily routine establishment and maintenance
- **Health Optimization**: Specific biomarker improvements

## Wellness Scoring System

### Score Calculation
The wellness score (1-100) incorporates:
- **Activity Level**: Steps taken and exercise minutes
- **Mental Wellbeing**: Mood and energy ratings
- **Consistency**: Regular logging and goal progress
- **Community Engagement**: Tips shared and challenges joined

### Score Benefits
- **50-70**: Basic wellness foundation
- **70-85**: Active healthy lifestyle
- **85-95**: Optimal wellness practices
- **95-100**: Wellness community leader

## Challenge System

### Challenge Types
- **Step Challenges**: Daily or weekly step targets
- **Fitness Goals**: Exercise duration and intensity
- **Nutrition Focus**: Healthy eating habits and hydration
- **Mental Wellness**: Stress reduction and mood improvement
- **Sleep Optimization**: Consistent sleep schedule and quality

### Participation Benefits
- **Community Support**: Peer encouragement and accountability
- **Competitive Motivation**: Leaderboards and rankings
- **Reward Distribution**: Token prizes for participation and achievement
- **Knowledge Sharing**: Tips and strategies from successful participants

## API Reference

### Read-Only Functions

```clarity
;; Get user health profile and wellness score
(get-user-profile (user principal))

;; View daily health log entries
(get-daily-health-log (user principal) (log-date uint))

;; Check health goal progress
(get-health-goal (goal-id uint))

;; View challenge information and participants
(get-health-challenge (challenge-id uint))

;; Browse health tips and community wisdom
(get-health-tip (tip-id uint))

;; Check milestone achievements
(get-wellness-milestone (user principal) (milestone-type (string-ascii 16)))
```

### Profile Management

```clarity
;; Update username
(update-user-username "WellnessWarrior2024")

;; Check token balance
(get-balance (user principal))

;; Transfer tokens for health-related purchases
(transfer u50000000 tx-sender recipient-principal none)
```

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
clarinet test

# Run specific test files
clarinet test tests/health-tracking_test.ts
clarinet test tests/goal-management_test.ts
clarinet test tests/challenges_test.ts

# Validate contract syntax
clarinet check
```

### Test Coverage
- Daily health logging and wellness scoring
- Goal creation, progress tracking, and achievement
- Challenge participation and completion
- Health tip sharing and community features
- Token distribution and reward mechanics
- Milestone recognition and badge systems

## Health & Safety Considerations

### Responsible Health Tracking
- **Medical Disclaimer**: Platform is for wellness tracking, not medical diagnosis
- **Realistic Goals**: Encourages sustainable, achievable health targets
- **Balanced Approach**: Promotes overall wellness, not extreme behaviors
- **Community Guidelines**: Supportive environment focused on positive health outcomes

### Data Privacy
- **Minimal Data Collection**: Only essential health metrics for rewards
- **User Control**: Complete ownership of health data and sharing preferences
- **Anonymized Analytics**: Aggregate insights without personal identification
- **Secure Storage**: Blockchain-based permanent records with user consent

## Integration Examples

### Fitness Device Integration
```javascript
// Sync with fitness trackers and health apps
const syncHealthData = async (deviceData) => {
  await openContractCall({
    contractAddress: HEALTHCHAIN_CONTRACT,
    contractName: 'healthchain',
    functionName: 'log-daily-health',
    functionArgs: [
      uintCV(deviceData.steps),
      uintCV(deviceData.calories),
      uintCV(deviceData.waterIntake),
      uintCV(deviceData.sleepHours),
      uintCV(deviceData.exerciseMinutes),
      uintCV(deviceData.moodRating),
      uintCV(deviceData.stressLevel),
      uintCV(deviceData.energyLevel),
      stringAsciiCV(deviceData.notes)
    ]
  });
};
```

### Mobile Health App
```swift
// iOS health app integration
class HealthTracker {
    func logDailyMetrics(healthData: HealthData) {
        let contractCall = ContractCall(
            function: "log-daily-health",
            parameters: [
                healthData.steps,
                healthData.calories,
                healthData.waterIntake,
                healthData.sleepHours,
                healthData.exerciseMinutes,
                healthData.mood,
                healthData.stress,
                healthData.energy,
                healthData.notes
            ]
        )
        stacksService.executeCall(contractCall)
    }
    
    func createWellnessGoal(goal: HealthGoal) {
        let contractCall = ContractCall(
            function: "create-health-goal",
            parameters: [goal.title, goal.type, goal.targetValue, goal.targetDate]
        )
        stacksService.executeCall(contractCall)
    }
}
```

## Deployment

### Testnet Deployment
```bash
clarinet deploy --testnet
```

### Mainnet Deployment
```bash
clarinet deploy --mainnet
```

### Environment Configuration
```toml
# Clarinet.toml
[contracts.healthchain]
path = "contracts/healthchain.clar"
clarity_version = 2

[network.testnet]
node_rpc_address = "https://stacks-node-api.testnet.stacks.co"
```

## Roadmap

### Phase 1 (Current)
- Core health tracking and goal management
- Basic community features and challenges
- Token rewards for healthy habits

### Phase 2 (Q2 2024)
- Advanced analytics and health insights
- Integration with popular fitness devices
- Enhanced community features and social support

### Phase 3 (Q3 2024)
- AI-powered health recommendations
- Healthcare provider integration
- Advanced wellness coaching features

### Phase 4 (Q4 2024)
- NFT health achievement badges
- Telemedicine platform integration
- Global wellness impact tracking

## Contributing

We welcome contributions from the health and wellness community! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Medical Disclaimer

HealthChain is designed for general wellness tracking and community support. It is not intended to diagnose, treat, cure, or prevent any disease or medical condition. Always consult with qualified healthcare professionals for medical advice and treatment decisions.

## Support

- **Documentation**: [Wiki](https://github.com/yourusername/healthchain-stacks/wiki)
- **Issues**: [GitHub Issues](https://github.com/yourusername/healthchain-stacks/issues)
- **Community**: [Discord](https://discord.gg/healthchain)
- **Health Resources**: [Wellness Blog](https://healthchain.blog)

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Health and wellness communities for guidance and feedback
- Medical professionals for safety review and recommendations
- Open source health data standards organizations

---

**Your wellness journey, permanently recorded and rewarded 💪**
