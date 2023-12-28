module dffer (
    d,
    clk,
    r,
    q
);
    input d, clk, r;
    output q;

    reg q;

    always @(posedge clk or posedge r)
    begin
        if (r)
            q = 0;
        else
            q = d;
    end 
endmodule