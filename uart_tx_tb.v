`timescale 1ns/1ps

module uart_tx_tb;

    //=====================================================
    // TESTBENCH SIGNALS
    //=====================================================
    reg         r_Clock;
    reg         r_TX_DV;
    reg [7:0]   r_TX_Byte;

    wire        w_TX_Active;
    wire        w_TX_Serial;
    wire        w_TX_Done;

    //=====================================================
    // CLOCK PERIOD
    // 50 MHz Clock = 20 ns period
    //=====================================================
    parameter c_CLOCK_PERIOD_NS = 20;
    parameter CLKS_PER_BIT      = 5208;

    //=====================================================
    // DUT INSTANTIATION
    //=====================================================
    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) DUT (
        .i_Clock      (r_Clock),
        .i_TX_DV      (r_TX_DV),
        .i_TX_Byte    (r_TX_Byte),

        .o_TX_Active  (w_TX_Active),
        .o_TX_Serial  (w_TX_Serial),
        .o_TX_Done    (w_TX_Done)
    );

    //=====================================================
    // CLOCK GENERATION
    //=====================================================
    always #(c_CLOCK_PERIOD_NS/2)
        r_Clock <= ~r_Clock;

    //=====================================================
    // TEST SEQUENCE
    //=====================================================
    initial begin

        // Initialize
        r_Clock   = 0;
        r_TX_DV   = 0;
        r_TX_Byte = 8'h00;

        // Wait a little
        #100;

        // Send 0x55
        r_TX_Byte = 8'h55;
        r_TX_DV   = 1'b1;

        #20;
        r_TX_DV   = 1'b0;

        // Wait for transmission complete
        wait(w_TX_Done == 1);

        #1000;

        $stop;

    end

endmodule