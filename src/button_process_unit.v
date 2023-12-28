module button_unit(
    clk,
    reset,
    ButtonIn,
    ButtonOut,
    led
);
    parameter sim = 0;

    input clk, ButtonIn, reset;
    output ButtonOut, led;

    wire ssynchronizer_to_debouncer, debouncer_to_pulsewidth;

    //同步器
    synchronizer synchronizer_inst(.asynch_in(ButtonIn), 
                                   .clk(clk), 
                                   .synch_out(ssynchronizer_to_debouncer));

    //防颤动电路
    debouncer #(.sim(sim)) debouncer_inst(.clk(clk), 
                             .in(ssynchronizer_to_debouncer),
                             .reset(reset),
                             .out(debouncer_to_pulsewidth));

    //脉宽变换电路
    PulseWidth_conver PulseWidth_conver(.in(debouncer_to_pulsewidth),
                                        .clk(clk),
                                        .out(ButtonOut));
    //测试电路
    dffer_en dffer_en_test(.d(~led), .clk(clk), .r(1'b0), .q(led), .en(ButtonOut));
endmodule