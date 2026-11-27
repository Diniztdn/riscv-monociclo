module uladec(
    input wire [1:0] ULAOp,
    input wire [2:0] funct3,
    input wire funct7b5,
    input wire opb5,
    output reg [2:0] ULAControl
);

    always @(*) begin
        case (ULAOp)

            //LW e SW: soma.
            2'b00:
                ULAControl = 3'b000;

            //BEQ: subtração.
            2'b01:
                ULAControl = 3'b001;

            //Operações tipo R e tipo I.
            2'b10: begin
                case (funct3)

                    //ADD ou SUB (possuem o mesmo funct3, então analisamos a posição 5 do funct7 para distinguir as operações).
                    3'b000:
                        if (opb5 && funct7b5)
                            ULAControl = 3'b001;
                        else
                            ULAControl = 3'b000;

                    //SLT.
                    3'b010:
                        ULAControl = 3'b101;

                    //AND.
                    3'b111:
                        ULAControl = 3'b010;

                    //OR.
                    3'b110:
                        ULAControl = 3'b011;

                    default:
                        ULAControl = 3'b000;
                endcase
            end

            //Operação padrão.
            default:
                ULAControl = 3'b000;

        endcase
    end

endmodule