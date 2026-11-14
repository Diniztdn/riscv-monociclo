module registerfile(
    input wire clk,
    input wire we3,

    input wire [4:0] a1,
    input wire [4:0] a2,
    input wire [4:0] a3,

    input wire [31:0] wd3,

    output wire [31:0] rd1,
    output wire [31:0] rd2
);

    //Banco com 32 registradores de 32 bits.
    reg [31:0] registers [31:0];

    //Averiguando se um dos registradores utilizados é o x0 (Sempre contém o valor 0, independemente alterações). 
    assign rd1 = (a1 == 5'd0) ? 32'b0 : registers[a1];
    assign rd2 = (a2 == 5'd0) ? 32'b0 : registers[a2];

    //Uma porta de escrita sincronizada com o clock (Impedindo escrita se for o registrador x0 e se o write enable for 0).
    always @(posedge clk) begin
        if (we3 && (a3 != 5'd0)) begin
            registers[a3] <= wd3;
        end
    end

endmodule