module sevenSegDecoder (
    input wire a, b, c, d, e, f, // initializing switches as the input
    input wire CLK, RST, EN, Key3,
    output reg [6:0] HEX0
);

    reg [6:0] segments;
    reg [3:0] count;
    reg prev_Key3; 
    reg [29:0] thirtycount;
    
    always @(posedge CLK ) begin
        if (!RST) begin
            // Reset logic
            count <= 4'b0000;
				thirtycount <= 30'b0000;
            segments <= 7'b1111111; 
            prev_Key3 <= 1'b0; 
        end else begin
            prev_Key3 <= Key3;
            
            if (EN & prev_Key3 & !Key3 & e) begin
                count <= count + 1'b1; 
					
            end
            
            if (f & e) begin
                segments <= 7'b1111111;
					 
            end else if (!f & e) begin
                case (count)
                    4'b0000: segments <= 7'b1000000; // 0
                    4'b0001: segments <= 7'b1111001; // 1
                    4'b0010: segments <= 7'b0100100; // 2
                    4'b0011: segments <= 7'b0110000; // 3
                    4'b0100: segments <= 7'b0011001; // 4
                    4'b0101: segments <= 7'b0010010; // 5
                    4'b0110: segments <= 7'b0000010; // 6
                    4'b0111: segments <= 7'b1111000; // 7
                    4'b1000: segments <= 7'b0000000; // 8
                    4'b1001: segments <= 7'b0010000; // 9
						  4'b1010: segments <= 7'b0001110; // F
						  4'b1011: segments <= 7'b1001111; // I
						  4'b1100: segments <= 7'b1000111; // L
						  4'b1101: segments <= 7'b1001111; // I
						  4'b1110: segments <= 7'b0001100; // P
                    default: segments <= 7'b1111111; // Default - All segments off
                endcase
            end else if (!f & !e) begin
                segments[0] <= (~a & ~b & ~c & d) | (b & ~c & ~d) | (a & c & d) | (a & b & ~c);
                segments[1] <= (b & ~c & d) | (~a & b & c & ~d) | (a & ~b & c) | (a & b & ~c) | (a & c & d);
                case ({d,c,b,a})
                    4'b0000: segments <= 7'b1000000; // 0
                    4'b0001: segments <= 7'b1111001; // 1
                    4'b0010: segments <= 7'b0100100; // 2
                    4'b0011: segments <= 7'b0110000; // 3
                    4'b0100: segments <= 7'b0011001; // 4
                    4'b0101: segments <= 7'b0010010; // 5
                    4'b0110: segments <= 7'b0000010; // 6
                    4'b0111: segments <= 7'b1111000; // 7
                    4'b1000: segments <= 7'b0000000; // 8
                    4'b1001: segments <= 7'b0010000; // 9
						  4'b1010: segments <= 7'b0001110; // F
						  4'b1011: segments <= 7'b1001111; // I
						  4'b1100: segments <= 7'b1000111; // L
						  4'b1101: segments <= 7'b1001111; // I
						  4'b1110: segments <= 7'b0001100; // P
                    default: segments <= 7'b1111111; // Default - All segments off
                endcase
            end else if ( f & !e)//takes input from 30 bit counter
            begin
                     if (EN) begin
                        thirtycount<= thirtycount + 1'b1;
                        if (!RST) begin
                        thirtycount<=30'b0;
                    end 
                    end
                    case (thirtycount[29:26])
                    4'b0000: segments <= 7'b1000000; // 0
                    4'b0001: segments <= 7'b1111001; // 1
                    4'b0010: segments <= 7'b0100100; // 2
                    4'b0011: segments <= 7'b0110000; // 3
                    4'b0100: segments <= 7'b0011001; // 4
                    4'b0101: segments <= 7'b0010010; // 5
                    4'b0110: segments <= 7'b0000010; // 6
                    4'b0111: segments <= 7'b1111000; // 7
                    4'b1000: segments <= 7'b0000000; // 8
                    4'b1001: segments <= 7'b0010000; // 9
                    4'b1010: segments <= 7'b0001110; // F
						  4'b1011: segments <= 7'b1001111; // I
						  4'b1100: segments <= 7'b1000111; // L
						  4'b1101: segments <= 7'b1001111; // I
						  4'b1110: segments <= 7'b0001100; // P
                    default: segments <= 7'b1111111; // Default - All segments off
                        endcase
            end  
        end
    end

    // Update HEX based on segments
    always @(segments) begin
        HEX0 <= segments;
    end
endmodule
