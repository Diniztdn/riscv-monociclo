module extend(
    // Os bits do opcode não são necessários.
    input wire [31:7] instr,
    input wire [1:0] immsrc,
    output reg [31:0] immext
);

    always @(*) begin
        //Replicando o bit 31 vinte vezes e depois concatenando com os 12 bits do imediato (20 + 12 = 32).
        case (immsrc)

            //Tipo I.
            2'b00:
                immext = {{20{instr[31]}}, instr[31:20]};

            //Tipo S (Stores).
            2'b01:
                immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            //Tipos B (Branches) e J(JALs): o bit menos significativo do imediato é sempre 0.
            2'b10:
                immext = {{20{instr[31]}}, instr[7],
                          instr[30:25], instr[11:8], 1'b0};
            //os campos do imediato J são reorganizados antes da concatenação.
            2'b11:
                immext = {{12{instr[31]}}, instr[19:12],
                          instr[20], instr[30:21], 1'b0};

            default:
                immext = 32'b0;

        endcase

    end

endmodule