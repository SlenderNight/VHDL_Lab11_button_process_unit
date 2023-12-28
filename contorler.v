module controler (
    clk,
    in,
    reset,
    timer_clr,
    timer_done,
    out
);
    input clk, in, reset, timer_done;
    output out, timer_clr;

    reg [1:0] state;
    //state 状态机变量
    //0：LOW状态
    //1：WAIT_HIGH状态
    //2：HIGH状态
    //3: WAIT_LOW状态
    reg timer_clr, out; 

    initial 
    begin
        //等待启动
        state = 0;
    end

    always @(posedge clk)
    begin
        if(reset)
        begin
            state = 0;
        end
        else
        begin
            if(state == 0)
            //状态0：等待按钮输入信号，停止计时，输入信号低电平
            begin
                timer_clr = 1;
                out = 0;

                if (in)
                //按钮输入高电平信号，转至下一状态
                begin
                    state = state + 1;
                end
                //else
            end
            else if(state == 1)
            //状态1：过滤按钮输入时的不稳定信号，开始计时，输出为1
            begin
                timer_clr = 0;
                out = 1;

                if(timer_done)
                //计时结束转至下一状态
                begin
                    state = state + 1;
                end
                // else
            end
            else if(state == 2)
            //状态2：按钮正常输入高电平信号，停止计时，输出为1
            begin
                timer_clr = 1;
                out = 1;

                if(~in)
                //按钮松开，转至下一状态
                begin
                    state = state + 1;
                end
                // else
            end
            else if(state == 3)
            //状态3：按钮松开，过滤不稳定输入信号，开始计时，输出为1
            begin
                timer_clr = 0;
                out = 1;

                if(timer_done)
                //计时结束，至此已完成一次按钮输入过程，重新转至1状态等待输入
                begin
                    state = 0;
                end
            end

        end
    end
    
endmodule