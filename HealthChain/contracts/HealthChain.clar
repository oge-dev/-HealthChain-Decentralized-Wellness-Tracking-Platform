;; HealthChain - Decentralized Wellness Tracking Platform
;; A comprehensive blockchain-based health platform that tracks wellness metrics,
;; rewards healthy habits, and builds supportive wellness communities

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))
(define-constant err-insufficient-tokens (err u105))
(define-constant err-invalid-metric (err u106))
(define-constant err-goal-not-active (err u107))

;; Token constants
(define-constant token-name "HealthChain Vitality Token")
(define-constant token-symbol "HVT")
(define-constant token-decimals u6)
(define-constant token-max-supply u800000000000) ;; 800k tokens with 6 decimals

;; Reward amounts (in micro-tokens)
(define-constant reward-daily-log u25000000) ;; 25 HVT
(define-constant reward-goal-achievement u80000000) ;; 80 HVT
(define-constant reward-milestone u60000000) ;; 60 HVT
(define-constant reward-health-tip u40000000) ;; 40 HVT
(define-constant reward-challenge-win u100000000) ;; 100 HVT

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var next-user-id uint u1)
(define-data-var next-goal-id uint u1)
(define-data-var next-challenge-id uint u1)

;; Token balances
(define-map token-balances principal uint)

;; Health metrics categories
(define-map health-metrics
  uint
  {
    metric-name: (string-ascii 32),
    metric-type: (string-ascii 16), ;; "physical", "mental", "nutrition", "sleep"
    measurement-unit: (string-ascii 16),
    optimal-range-min: uint,
    optimal-range-max: uint,
    tracking-frequency: (string-ascii 8), ;; "daily", "weekly", "monthly"
    verified: bool
  }
)

;; User health profiles
(define-map user-profiles
  principal
  {
    username: (string-ascii 32),
    age-group: (string-ascii 8), ;; "18-25", "26-35", etc
    fitness-level: uint, ;; 1-5
    health-goals: uint,
    daily-logs: uint,
    goals-achieved: uint,
    challenges-completed: uint,
    tips-shared: uint,
    wellness-score: uint, ;; 1-100
    join-date: uint,
    last-activity: uint
  }
)

;; Daily health logs
(define-map daily-health-logs
  { user: principal, log-date: uint }
  {
    steps-taken: uint,
    calories-consumed: uint,
    water-intake-ml: uint,
    sleep-hours: uint,
    exercise-minutes: uint,
    mood-rating: uint, ;; 1-10
    stress-level: uint, ;; 1-10
    energy-level: uint, ;; 1-10
    notes: (string-ascii 200)
  }
)

;; Health goals
(define-map health-goals
  uint
  {
    user: principal,
    goal-title: (string-ascii 64),
    goal-type: (string-ascii 16), ;; "weight", "steps", "exercise", "nutrition"
    target-value: uint,
    current-value: uint,
    target-date: uint,
    created-date: uint,
    progress-percentage: uint,
    achieved: bool,
    active: bool
  }
)

;; Health challenges
(define-map health-challenges
  uint
  {
    creator: principal,
    challenge-title: (string-ascii 64),
    challenge-description: (string-ascii 300),
    challenge-type: (string-ascii 16),
    duration-days: uint,
    target-metric: uint,
    participants: uint,
    max-participants: uint,
    start-date: uint,
    end-date: uint,
    prize-pool: uint,
    active: bool
  }
)

;; Challenge participation
(define-map challenge-participants
  { challenge-id: uint, participant: principal }
  {
    join-date: uint,
    current-progress: uint,
    daily-updates: uint,
    final-score: uint,
    rank: (optional uint),
    completed: bool
  }
)

;; Health tips
(define-map health-tips
  uint
  {
    author: principal,
    tip-title: (string-ascii 64),
    tip-content: (string-ascii 400),
    category: (string-ascii 16), ;; "fitness", "nutrition", "mental", "sleep"
    difficulty-level: uint, ;; 1-5
    usefulness-votes: uint,
    publication-date: uint,
    verified: bool
  }
)

;; Wellness milestones
(define-map wellness-milestones
  { user: principal, milestone-type: (string-ascii 16) }
  {
    milestone-name: (string-ascii 64),
    achievement-date: uint,
    metric-value: uint,
    badge-earned: bool,
    celebration-points: uint
  }
)

;; Helper function to get or create user profile
(define-private (get-or-create-profile (user principal))
  (match (map-get? user-profiles user)
    profile profile
    {
      username: "",
      age-group: "26-35",
      fitness-level: u3,
      health-goals: u0,
      daily-logs: u0,
      goals-achieved: u0,
      challenges-completed: u0,
      tips-shared: u0,
      wellness-score: u50,
      join-date: stacks-block-height,
      last-activity: stacks-block-height
    }
  )
)

;; Token functions
(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-decimals)
  (ok token-decimals)
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? token-balances user)))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let (
    (current-balance (default-to u0 (map-get? token-balances recipient)))
    (new-balance (+ current-balance amount))
    (new-total-supply (+ (var-get total-supply) amount))
  )
    (asserts! (<= new-total-supply token-max-supply) err-invalid-input)
    (map-set token-balances recipient new-balance)
    (var-set total-supply new-total-supply)
    (ok amount)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (let (
    (sender-balance (default-to u0 (map-get? token-balances sender)))
  )
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (asserts! (>= sender-balance amount) err-insufficient-tokens)
    (try! (mint-tokens recipient amount))
    (map-set token-balances sender (- sender-balance amount))
    (print {action: "transfer", sender: sender, recipient: recipient, amount: amount, memo: memo})
    (ok true)
  )
)

;; Health metric management
(define-public (add-health-metric (metric-name (string-ascii 32)) (metric-type (string-ascii 16))
                                 (measurement-unit (string-ascii 16)) (optimal-range-min uint)
                                 (optimal-range-max uint) (tracking-frequency (string-ascii 8)))
  (let (
    (metric-id (var-get next-user-id))
  )
    (asserts! (> (len metric-name) u0) err-invalid-input)
    (asserts! (> (len metric-type) u0) err-invalid-input)
    (asserts! (> (len measurement-unit) u0) err-invalid-input)
    (asserts! (< optimal-range-min optimal-range-max) err-invalid-input)
    
    (map-set health-metrics metric-id {
      metric-name: metric-name,
      metric-type: metric-type,
      measurement-unit: measurement-unit,
      optimal-range-min: optimal-range-min,
      optimal-range-max: optimal-range-max,
      tracking-frequency: tracking-frequency,
      verified: false
    })
    
    (var-set next-user-id (+ metric-id u1))
    (print {action: "health-metric-added", metric-id: metric-id, metric-name: metric-name})
    (ok metric-id)
  )
)

;; Daily health logging
(define-public (log-daily-health (steps-taken uint) (calories-consumed uint) (water-intake-ml uint)
                                (sleep-hours uint) (exercise-minutes uint) (mood-rating uint)
                                (stress-level uint) (energy-level uint) (notes (string-ascii 200)))
  (let (
    (log-date (/ stacks-block-height u144)) ;; Daily grouping
    (profile (get-or-create-profile tx-sender))
    (wellness-calculation (+ (+ (/ steps-taken u100) (/ exercise-minutes u10)) (+ mood-rating energy-level)))
    (new-wellness-score (if (<= wellness-calculation u100) wellness-calculation u100))
  )
    (asserts! (and (>= mood-rating u1) (<= mood-rating u10)) err-invalid-input)
    (asserts! (and (>= stress-level u1) (<= stress-level u10)) err-invalid-input)
    (asserts! (and (>= energy-level u1) (<= energy-level u10)) err-invalid-input)
    (asserts! (<= sleep-hours u24) err-invalid-input)
    
    (map-set daily-health-logs {user: tx-sender, log-date: log-date} {
      steps-taken: steps-taken,
      calories-consumed: calories-consumed,
      water-intake-ml: water-intake-ml,
      sleep-hours: sleep-hours,
      exercise-minutes: exercise-minutes,
      mood-rating: mood-rating,
      stress-level: stress-level,
      energy-level: energy-level,
      notes: notes
    })
    
    ;; Update user profile
    (map-set user-profiles tx-sender
      (merge profile {
        daily-logs: (+ (get daily-logs profile) u1),
        wellness-score: new-wellness-score,
        last-activity: stacks-block-height
      })
    )
    
    ;; Award daily logging reward
    (try! (mint-tokens tx-sender reward-daily-log))
    
    ;; Bonus for complete health day (all metrics above average)
    (if (and (and (>= mood-rating u7) (>= energy-level u7)) (>= exercise-minutes u30))
      (begin
        (try! (mint-tokens tx-sender u15000000)) ;; 15 HVT bonus
        true
      )
      true
    )
    
    (print {action: "daily-health-logged", user: tx-sender, date: log-date, wellness-score: new-wellness-score})
    (ok true)
  )
)

;; Health goal setting
(define-public (create-health-goal (goal-title (string-ascii 64)) (goal-type (string-ascii 16))
                                  (target-value uint) (target-date uint))
  (let (
    (goal-id (var-get next-goal-id))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len goal-title) u0) err-invalid-input)
    (asserts! (> (len goal-type) u0) err-invalid-input)
    (asserts! (> target-value u0) err-invalid-input)
    (asserts! (> target-date stacks-block-height) err-invalid-input)
    
    (map-set health-goals goal-id {
      user: tx-sender,
      goal-title: goal-title,
      goal-type: goal-type,
      target-value: target-value,
      current-value: u0,
      target-date: target-date,
      created-date: stacks-block-height,
      progress-percentage: u0,
      achieved: false,
      active: true
    })
    
    ;; Update user profile
    (map-set user-profiles tx-sender
      (merge profile {
        health-goals: (+ (get health-goals profile) u1),
        last-activity: stacks-block-height
      })
    )
    
    (var-set next-goal-id (+ goal-id u1))
    (print {action: "health-goal-created", goal-id: goal-id, user: tx-sender, goal-title: goal-title})
    (ok goal-id)
  )
)

;; Goal progress update
(define-public (update-goal-progress (goal-id uint) (new-value uint))
  (let (
    (goal (unwrap! (map-get? health-goals goal-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
    (progress-percent (/ (* new-value u100) (get target-value goal)))
    (goal-achieved (>= new-value (get target-value goal)))
  )
    (asserts! (is-eq tx-sender (get user goal)) err-unauthorized)
    (asserts! (get active goal) err-goal-not-active)
    
    ;; Update goal progress
    (map-set health-goals goal-id
      (merge goal {
        current-value: new-value,
        progress-percentage: progress-percent,
        achieved: goal-achieved,
        active: (not goal-achieved)
      })
    )
    
    ;; Award achievement reward if goal completed
    (if goal-achieved
      (begin
        (try! (mint-tokens tx-sender reward-goal-achievement))
        (map-set user-profiles tx-sender
          (merge profile {
            goals-achieved: (+ (get goals-achieved profile) u1),
            wellness-score: (+ (get wellness-score profile) u10),
            last-activity: stacks-block-height
          })
        )
        true
      )
      (begin
        (map-set user-profiles tx-sender (merge profile {last-activity: stacks-block-height}))
        true
      )
    )
    
    (print {action: "goal-progress-updated", goal-id: goal-id, user: tx-sender, achieved: goal-achieved})
    (ok true)
  )
)

;; Health challenge creation
(define-public (create-health-challenge (challenge-title (string-ascii 64)) (challenge-description (string-ascii 300))
                                       (challenge-type (string-ascii 16)) (duration-days uint)
                                       (target-metric uint) (max-participants uint))
  (let (
    (challenge-id (var-get next-challenge-id))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len challenge-title) u0) err-invalid-input)
    (asserts! (> (len challenge-description) u0) err-invalid-input)
    (asserts! (> duration-days u0) err-invalid-input)
    (asserts! (> target-metric u0) err-invalid-input)
    (asserts! (> max-participants u0) err-invalid-input)
    
    (map-set health-challenges challenge-id {
      creator: tx-sender,
      challenge-title: challenge-title,
      challenge-description: challenge-description,
      challenge-type: challenge-type,
      duration-days: duration-days,
      target-metric: target-metric,
      participants: u0,
      max-participants: max-participants,
      start-date: stacks-block-height,
      end-date: (+ stacks-block-height duration-days),
      prize-pool: u0,
      active: true
    })
    
    ;; Update creator profile
    (map-set user-profiles tx-sender
      (merge profile {
        wellness-score: (+ (get wellness-score profile) u5),
        last-activity: stacks-block-height
      })
    )
    
    (var-set next-challenge-id (+ challenge-id u1))
    (print {action: "health-challenge-created", challenge-id: challenge-id, creator: tx-sender})
    (ok challenge-id)
  )
)

;; Challenge participation
(define-public (join-health-challenge (challenge-id uint))
  (let (
    (challenge (unwrap! (map-get? health-challenges challenge-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (get active challenge) err-invalid-input)
    (asserts! (< (get participants challenge) (get max-participants challenge)) err-invalid-input)
    (asserts! (not (is-eq tx-sender (get creator challenge))) err-unauthorized)
    (asserts! (is-none (map-get? challenge-participants {challenge-id: challenge-id, participant: tx-sender})) err-already-exists)
    
    ;; Add participant
    (map-set challenge-participants {challenge-id: challenge-id, participant: tx-sender} {
      join-date: stacks-block-height,
      current-progress: u0,
      daily-updates: u0,
      final-score: u0,
      rank: none,
      completed: false
    })
    
    ;; Update challenge participant count
    (map-set health-challenges challenge-id
      (merge challenge {participants: (+ (get participants challenge) u1)})
    )
    
    ;; Update participant profile
    (map-set user-profiles tx-sender (merge profile {last-activity: stacks-block-height}))
    
    (print {action: "health-challenge-joined", challenge-id: challenge-id, participant: tx-sender})
    (ok true)
  )
)

;; Health tip sharing
(define-public (share-health-tip (tip-title (string-ascii 64)) (tip-content (string-ascii 400))
                                (category (string-ascii 16)) (difficulty-level uint))
  (let (
    (tip-id (var-get next-goal-id)) ;; Reuse counter
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len tip-title) u0) err-invalid-input)
    (asserts! (> (len tip-content) u0) err-invalid-input)
    (asserts! (> (len category) u0) err-invalid-input)
    (asserts! (and (>= difficulty-level u1) (<= difficulty-level u5)) err-invalid-input)
    
    (map-set health-tips tip-id {
      author: tx-sender,
      tip-title: tip-title,
      tip-content: tip-content,
      category: category,
      difficulty-level: difficulty-level,
      usefulness-votes: u0,
      publication-date: stacks-block-height,
      verified: false
    })
    
    ;; Update author profile
    (map-set user-profiles tx-sender
      (merge profile {
        tips-shared: (+ (get tips-shared profile) u1),
        wellness-score: (+ (get wellness-score profile) u8),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award tip sharing reward
    (try! (mint-tokens tx-sender reward-health-tip))
    
    (var-set next-goal-id (+ tip-id u1))
    (print {action: "health-tip-shared", tip-id: tip-id, author: tx-sender, category: category})
    (ok tip-id)
  )
)

;; Milestone achievement
(define-public (achieve-milestone (milestone-type (string-ascii 16)) (milestone-name (string-ascii 64)) (metric-value uint))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len milestone-type) u0) err-invalid-input)
    (asserts! (> (len milestone-name) u0) err-invalid-input)
    (asserts! (> metric-value u0) err-invalid-input)
    (asserts! (is-none (map-get? wellness-milestones {user: tx-sender, milestone-type: milestone-type})) err-already-exists)
    
    (map-set wellness-milestones {user: tx-sender, milestone-type: milestone-type} {
      milestone-name: milestone-name,
      achievement-date: stacks-block-height,
      metric-value: metric-value,
      badge-earned: true,
      celebration-points: (* metric-value u2)
    })
    
    ;; Update profile
    (map-set user-profiles tx-sender
      (merge profile {
        wellness-score: (+ (get wellness-score profile) u15),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award milestone reward
    (try! (mint-tokens tx-sender reward-milestone))
    
    (print {action: "wellness-milestone-achieved", user: tx-sender, milestone-type: milestone-type, metric-value: metric-value})
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-user-profile (user principal))
  (map-get? user-profiles user)
)

(define-read-only (get-health-metric (metric-id uint))
  (map-get? health-metrics metric-id)
)

(define-read-only (get-daily-health-log (user principal) (log-date uint))
  (map-get? daily-health-logs {user: user, log-date: log-date})
)

(define-read-only (get-health-goal (goal-id uint))
  (map-get? health-goals goal-id)
)

(define-read-only (get-health-challenge (challenge-id uint))
  (map-get? health-challenges challenge-id)
)

(define-read-only (get-challenge-participation (challenge-id uint) (participant principal))
  (map-get? challenge-participants {challenge-id: challenge-id, participant: participant})
)

(define-read-only (get-health-tip (tip-id uint))
  (map-get? health-tips tip-id)
)

(define-read-only (get-wellness-milestone (user principal) (milestone-type (string-ascii 16)))
  (map-get? wellness-milestones {user: user, milestone-type: milestone-type})
)

;; Admin functions
(define-public (verify-health-metric (metric-id uint))
  (let (
    (metric (unwrap! (map-get? health-metrics metric-id) err-not-found))
  )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set health-metrics metric-id (merge metric {verified: true}))
    (print {action: "health-metric-verified", metric-id: metric-id})
    (ok true)
  )
)

(define-public (update-user-username (new-username (string-ascii 32)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-username) u0) err-invalid-input)
    (map-set user-profiles tx-sender (merge profile {username: new-username}))
    (print {action: "user-username-updated", user: tx-sender, username: new-username})
    (ok true)
  )
)