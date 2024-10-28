;; Artisan Loan Smart Contract - Advanced Features
;; A comprehensive lending platform for artisans and small business owners

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-loan-active (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-invalid-repayment (err u105))
(define-constant err-late-penalty (err u106))
(define-constant err-insufficient-collateral (err u107))
(define-constant err-invalid-term (err u108))
(define-constant err-early-repayment-fee (err u109))
(define-constant err-loan-not-due (err u110))

;; Constants for business logic
(define-constant max-loan-amount u1000000000) ;; 10,000 STX
(define-constant min-loan-amount u100000) ;; 1 STX
(define-constant min-daily-repayment u1000)
(define-constant base-interest-rate u5) ;; 5% base interest rate
(define-constant penalty-rate u10)
(define-constant collateral-ratio u150) ;; 150% collateral requirement
(define-constant early-repayment-fee-rate u2) ;; 2% early repayment fee
(define-constant grace-period u3) ;; 3 blocks grace period
(define-constant max-loan-term u365) ;; Maximum loan term in days/blocks
(define-constant max-credit-score u100)
(define-constant min-credit-score u0)

;; Helper functions for min and max operations
(define-private (min-uint (a uint) (b uint))
  (if (<= a b) a b))

(define-private (max-uint (a uint) (b uint))
  (if (>= a b) a b))

;; Define data types
(define-map loans
  { borrower: principal }
  {
    amount: uint,
    start-date: uint,
    term-length: uint,
    daily-repayment: uint,
    total-repaid: uint,
    interest-rate: uint,
    collateral-amount: uint,
    active: bool,
    last-payment-date: uint,
    missed-payments: uint,
    credit-score: uint
  }
)

(define-map balances principal uint)
(define-map collateral-deposits principal uint)
(define-map credit-scores principal uint)

;; Data getters
(define-read-only (get-loan (borrower principal))
  (map-get? loans { borrower: borrower })
)

(define-read-only (get-balance (account principal))
  (default-to u0 (map-get? balances account))
)

(define-read-only (get-credit-score (borrower principal))
  (default-to u50 (map-get? credit-scores borrower)) ;; Default credit score of 50
)

(define-read-only (get-collateral (borrower principal))
  (default-to u0 (map-get? collateral-deposits borrower))
)

;; Helper functions
(define-private (calculate-interest-rate (credit-score uint))
  (let (
    (credit-factor (/ credit-score u100))
  )
    (if (>= base-interest-rate credit-factor)
      (- base-interest-rate credit-factor)
      u1) ;; Minimum 1% interest rate
  )
)

(define-private (calculate-required-collateral (amount uint))
  (/ (* amount collateral-ratio) u100)
)
