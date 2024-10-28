## Artisan Loan Smart Contract
This is a Clarity-based smart contract that manages loan creation, repayment, and penalties for late payments on the Stacks blockchain. This contract allows a contract owner to create loans for borrowers, monitor repayments, and repossess loans if repayments are excessively late.

## Key Features
- Loan Creation: Allows the contract owner to create loans with specified amounts and daily repayment requirements.
- Loan Repayment: Borrowers can make repayments, and penalties are applied if repayments are late.
- Loan Closure: Loans are automatically closed when fully repaid.
- Loan Repossession: If a borrower is late on repayments beyond a certain threshold, the contract owner can repossess the loan.
- Read-Only Functions: Provides visibility into loan details, balances, and repayment status.


## Contract Structure
**Constants**
- Contract Owner: Defined as the tx-sender of the contract deployment transaction.
- Error Codes: Provides various error codes (e.g., err-owner-only, err-loan-active) for specific contract-related issues.

## Loan Parameters:
- max-loan-amount: The maximum allowable loan amount in microstacks (example: 1 billion microstacks).
- min-daily-repayment: The minimum allowable daily repayment amount in microstacks.
- penalty-rate: The penalty rate applied for late payments, defined per block of delay.

## Data Maps
- loans: Stores loan data for each borrower, indexed by borrower principal.
amount: The principal loan amount.
- start-date: The block height when the loan started.
- daily-repayment: Required daily repayment amount.
total-repaid: The total amount repaid.
- active: Loan status (true if active, false if closed or repossessed).
- last-payment-date: Block height of the last repayment.
balances: Stores each borrower's remaining loan balance.

## Public Functions
**1 . create-loan**
Parameters:
- borrower: The principal of the borrower.
- amount: The loan amount (must be ≤ max-loan-amount).
- daily-repayment: The daily repayment amount (must be ≥ min-daily-repayment).

**Functionality:**
Only callable by the contract owner.
Creates a loan for the specified borrower if the loan does not already exist.
Returns: true on success, error code on failure.
**2. make-repayment**
Parameters:
- amount: The repayment amount made by the borrower.

Functionality:
Calculates days since the last payment and applies penalties if late.
Updates the total repaid amount, deducts balance, and checks if the loan is fully repaid.
Returns: true on success, error code on failure.
**3. close-loan**
Functionality:
Closes a loan if it is fully repaid.
Returns: true on success, error code on failure.
**4. repossess-loan**
Parameters:
borrower: The principal of the borrower whose loan is to be repossessed.

Functionality:
Can be called by the contract owner if a borrower is over 30 blocks late in repayment.
Sets the loan status to inactive and clears the borrower’s balance.
Returns: true on success, error code on failure.
Read-Only Functions
- 1. get-loan
Parameters:
borrower: The principal of the borrower.
Returns: Loan details (if exists) or none.
- 2. get-balance
Parameters:
account: The principal of the account whose balance is requested.
Returns: The balance of the specified account, or 0 if none.
- 3. is-loan-repaid
Parameters:
borrower: The principal of the borrower.
Returns: true if the loan is fully repaid, false otherwise.
## Error Handling
This contract includes the following error codes for better management and debugging:

- err-owner-only (u100): Ensures only the contract owner can perform certain actions.
- err-not-found (u101): Indicates a loan was not found for a borrower.
- err-loan-active (u102): Prevents creating a loan for a borrower with an active loan.
- err-insufficient-balance (u103): Ensures the borrower has sufficient balance for repayment.
- err-invalid-amount (u104): Validates the amount provided is within limits.
- err-invalid-repayment (u105): Ensures the repayment amount meets minimum requirements.
- err-late-penalty (u106): Indicates a penalty should be applied due to late repayment.

Example Usage
- Create a Loan (by contract owner):

## Security Considerations
Contract Owner Permissions: Only the contract owner can create loans and repossess loans.
Late Penalties: Penalties are automatically calculated and applied to discourage late payments.
Sufficient Balance Check: Ensures that the borrower has sufficient balance for repayments, including penalties if late.