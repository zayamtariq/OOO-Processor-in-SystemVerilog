`timescale 1ns / 1ps

// trying to create a pixel clock
// that is: we want to write 25,200,000 pixels a second. 
// and i guess the assumption is we are writing a pixel every clock cycle. 
// therefore: we want all the clock cycles to fit in a second 

// basys 3 has a 100 MHz clock, 
// but we need a 25.2 MHz clock 

module Clock_252(
    input CLK, // the basys3 clock 
    output reg clock_pulse // the actual pulse of the clock     
    );
    
    reg counter; 
    
    initial begin 
        counter = 0; 
        clock_pulse = 0;
    end 
    
    always @ (posedge CLK) begin 
        if (counter == 1'd1) begin 
            clock_pulse <= ~clock_pulse;
            counter <= 0;  
        end else begin 
            counter <= counter + 1; 
        end 
    end 
    
endmodule