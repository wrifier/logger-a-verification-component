//------------------------------------------------------------------------------
// Title: SV Macros
// 
// SV Macros will get use in SV world Env.
//------------------------------------------------------------------------------

// MACRO: `log_info
//
// This macro used to Print only messages.
//
//| `log_info(ID,MSG,VERBOSITY)
//
// Calls <wait_for_state> API of logger and print Message in UVM style.
//
`define log_info(ID,MSG,VERBOSITY) \
    begin \
      logger.wait_for_state(ID); \
      uvm_report_info(get_type_name(),MSG,VERBOSITY); \
    end

`define log_dinfo(ID,MSG,VERBOSITY) \
    begin \
      logger.get_data_with_state(ID,rd_data); \
      uvm_report_info(get_type_name(),MSG,VERBOSITY); \
    end
