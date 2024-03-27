pub(crate) mod boltzswap;
pub(crate) mod error;
pub(crate) mod reverseswap;

/// Calculate the service fee from the `invoice_amount_sat`.
///
/// The fee is a percentage of the invoice amount, rounded up.
pub(crate) fn get_service_fee_sat(invoice_amount_sat: u64, fees_percentage: f64) -> u64 {
    ((invoice_amount_sat as f64) * fees_percentage / 100.0).ceil() as u64
}

/// Calculate the `invoice_amount_sat` from `invoice_amount_minus_service_fee`.
///
/// This calculates the initial amount going in reverse, e.g. from the resulting sum.
pub(crate) fn get_invoice_amount_sat(
    invoice_amount_minus_service_fee: u64,
    fees_percentage: f64,
) -> u64 {
    // The resulting invoice amount contains the service fee, which is rounded up with ceil()
    // Therefore, when calculating the invoice amount, we must also round it up with ceil()
    (invoice_amount_minus_service_fee as f64 * 100.0 / (100.0 - fees_percentage)).ceil() as u64
}

#[cfg(test)]
mod tests {
    use crate::swap_out::{get_invoice_amount_sat, get_service_fee_sat};

    #[test]
    fn test_get_service_fee_sat() {
        // Round values, so rounding up plays no role
        assert_eq!(250, get_service_fee_sat(50_000, 0.5));
        assert_eq!(300, get_service_fee_sat(50_000, 0.6));
        assert_eq!(750, get_service_fee_sat(100_000, 0.75));

        // Odd values, where rounding up kicks in
        assert_eq!(251, get_service_fee_sat(50_001, 0.5));
        assert_eq!(301, get_service_fee_sat(50_001, 0.6));
        assert_eq!(751, get_service_fee_sat(100_001, 0.75));
    }

    #[test]
    fn test_get_invoice_amount_sat() {
        // Round values, so rounding up plays no role
        test_invoice_amount_calculation_in_reverse(50_000, 0.5);
        test_invoice_amount_calculation_in_reverse(51_000, 0.5);
        test_invoice_amount_calculation_in_reverse(52_000, 0.5);
        test_invoice_amount_calculation_in_reverse(53_000, 0.5);
        test_invoice_amount_calculation_in_reverse(54_000, 0.5);
        test_invoice_amount_calculation_in_reverse(60_000, 0.6);
        test_invoice_amount_calculation_in_reverse(100_000, 0.75);

        // Odd values, where the rounding up in the service fee calculation kicks in
        test_invoice_amount_calculation_in_reverse(50_001, 0.5);
        test_invoice_amount_calculation_in_reverse(50_999, 0.5);
        test_invoice_amount_calculation_in_reverse(51_001, 0.5);
        test_invoice_amount_calculation_in_reverse(52_001, 0.5);
        test_invoice_amount_calculation_in_reverse(53_001, 0.5);
        test_invoice_amount_calculation_in_reverse(54_001, 0.5);
        test_invoice_amount_calculation_in_reverse(60_001, 0.6);
        test_invoice_amount_calculation_in_reverse(75_001, 0.75);
    }

    fn test_invoice_amount_calculation_in_reverse(invoice_amount_sat: u64, fees_percentage: f64) {
        let service_fee_sat = get_service_fee_sat(invoice_amount_sat, fees_percentage);
        let calculated_invoice_amount_sat =
            get_invoice_amount_sat(invoice_amount_sat - service_fee_sat, fees_percentage);

        // The rounding up of the service fee means there will be a precision loss when we try to calculate in reverse.
        //
        // For example:
        // - invoice_amount_sat = 50_000, service_fee_sat = 250
        // - invoice_amount_sat = 50_001, service_fee_sat = 251
        // both lead to an onchain_amount_sat of 49_750 and an identical receive_amount_sat of 46_040.
        //
        // This is not case anymore for invoice_amount_sat of 50_002, as service_fee_sat stays 251, and
        // therefore the received amount has to increase by 1 sat.
        //
        // Trying to find the invoice_amount_sat in reverse can result in either one or two valid results.
        assert!(
            (calculated_invoice_amount_sat == invoice_amount_sat)
                || (calculated_invoice_amount_sat == invoice_amount_sat - 1)
        );
    }
}
