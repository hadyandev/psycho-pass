;; Psycho-Pass Token - SIP-010 Standard Implementation with Score System
(impl-trait 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip-010-trait-ft-standard.sip-010-trait)

;; Fungible token
(define-fungible-token psycho-pass-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; Token metadata
(define-constant token-name "Psycho-Pass Score")
(define-constant token-symbol "PPS")
(define-constant token-decimals u6)
(define-constant token-uri u"https://workshop.blockdev.id/token.json")

;; Data maps
(define-map student-score {student: principal} {score: uint})
(define-map score-history {student: principal, index: uint} {score: uint, timestamp: uint})

;; Internal counter for history index per student
(define-map history-counter {student: principal} {count: uint})

;; ----- SIP-010 Required Functions -----
(define-read-only (get-name) (ok token-name))
(define-read-only (get-symbol) (ok token-symbol))
(define-read-only (get-decimals) (ok token-decimals))
(define-read-only (get-balance (user principal)) (ok (ft-get-balance psycho-pass-token user)))
(define-read-only (get-total-supply) (ok (ft-get-supply psycho-pass-token)))
(define-read-only (get-token-uri) (ok (some token-uri)))

;; Transfer
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq from tx-sender) err-not-token-owner)
    (ft-transfer? psycho-pass-token amount from to)
  )
)

;; Mint
(define-public (mint (amount uint) (to principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? psycho-pass-token amount to)
  )
)

;; Burn
(define-public (burn (amount uint) (from principal))
  (begin
    (asserts! (is-eq from tx-sender) err-not-token-owner)
    (ft-burn? psycho-pass-token amount from)
  )
)

;; ----- Psycho-Pass Features -----

;; Set or update student score (owner only)
(define-public (set-score (student principal) (score uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    ;; Save score
    (map-set student-score {student: student} {score: score})
    ;; Update history
    (let
      (
        (count (default-to u0 (get count (map-get? history-counter {student: student}))))
        (new-index (+ count u1))
      )
      (map-set score-history {student: student, index: new-index} {score: score, timestamp: block-height})
      (map-set history-counter {student: student} {count: new-index})
    )
    (ok score)
  )
)

;; Get student score
(define-read-only (get-score (student principal))
  (ok (default-to u0 (get score (map-get? student-score {student: student}))))
)

;; Get score history by index
(define-read-only (get-score-history (student principal) (index uint))
  (map-get? score-history {student: student, index: index})
)

;; Determine status based on score
(define-read-only (get-status (student principal))
  (let
    (
      (score (default-to u0 (get score (map-get? student-score {student: student}))))
    )
    (if (>= score u80)
        (ok "Clear")
        (if (>= score u50)
            (ok "Caution")
            (ok "Danger")
        )
    )
  )
)

;; Reward or punish based on status
(define-public (evaluate-student (student principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let
      (
        (score (default-to u0 (get score (map-get? student-score {student: student}))))
      )
      (if (>= score u80)
          ;; Clear: reward 10 tokens
          (ft-mint? psycho-pass-token u10 student)
          (if (>= score u50)
              ;; Caution: reward 5 tokens
              (ft-mint? psycho-pass-token u5 student)
              ;; Danger: burn all tokens
              (ft-burn? psycho-pass-token (ft-get-balance psycho-pass-token student) student)
          )
      )
    )
  )
)
