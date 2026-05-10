# Spreadsheet Answers

## Cleaning Steps
* Standardized merchant names using PROPER and TRIM formulas.
* Formatted dates strictly to YYYY-MM-DD.
* Cleaned status values by converting to lowercase and safely extracting the core status word ("captured", "failed", "chargeback") using text parsing to avoid trailing space errors.
* Cleaned risk scores by stripping out text artifacts like "score:" and "risk-", converting the remainder to a numeric value, and defaulting errors/blanks to 0.
* Handled missing gateway regions by logically inferring them from the transaction currency (INR->APAC, EUR->EU, USD->US).

## Standardization Rules
* Amounts converted to USD by matching both the transaction date and currency against the `exchange_rates.csv` table using a SUMIFS logic to ensure the correct daily rate was applied.

## Lookup and Enrichment Logic
* Joined `merchant_master.csv` using a VLOOKUP on the clean merchant name to bring in the `merchant_category`.

## Final Answers
* Total raw rows: 30
* Total cleaned rows: 30
* Invalid or missing rows handled: 0
* Top region by GMV: APAC (with $63415.5)
* Number of high value transactions: 7
* Number of high risk transactions: 9
* Top merchant by captured GMV: Beta Stores (with $33431)

## Formula Samples
* **Risk Score Clean:** `=IFERROR(VALUE(SUBSTITUTE(SUBSTITUTE(LOWER(I2), "score:", ""), "risk-", "")), 0)`
* **Status Clean:** `=LOWER(IFERROR(LEFT(TRIM(G2), FIND(" ", TRIM(G2))-1), TRIM(G2)))`
* **Amount USD:** `=E2 * SUMIFS(Exchange_Rates!C:C, Exchange_Rates!B:B, F2, Exchange_Rates!A:A, B2)`
* **High Value Flag:** `=IF(OR(AND(J2="APAC", O2>5000), AND(J2="EU", O2>6000), AND(J2="US", O2>7000)), 1, 0)`
* **High Risk Flag:** `=IF(OR(I2>=70, ISNUMBER(SEARCH("chargeback", H2))), 1, 0)`