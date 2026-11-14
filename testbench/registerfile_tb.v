module regfile_tb;

    reg clk;
    reg we3;

    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;

    reg [31:0] wd3;

    wire [31:0] rd1;
    wire [31:0] rd2;

    // Instanciação do banco de registradores
    registerfile uut(
        .clk(clk),
        .we3(we3),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Gerador de clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        we3 = 0;

        a1 = 0;
        a2 = 0;
        a3 = 0;

        wd3 = 0;

        // TESTE 1: Escrever 100 em x5
        we3 = 1;
        a3 = 5'd5;
        wd3 = 32'd100;

        @(posedge clk);
        #1;

        a1 = 5'd5;
        #1;

        if (rd1 === 32'd100)
            $display("Sucesso: Escrita em x5 funcionando.");
        else
            $display("Falha: Erro na escrita em x5.");

        // TESTE 2: Escrever 50 em x6
        a3 = 5'd6;
        wd3 = 32'd50;

        @(posedge clk);
        #1;

        // TESTE 3: Leitura simultanea de x5 e x6
        a1 = 5'd5;
        a2 = 5'd6;
        #1;

        if (rd1 === 32'd100 && rd2 === 32'd50)
            $display("Sucesso: Duas portas de leitura funcionando.");
        else
            $display("Falha: Erro nas portas de leitura.");

        // TESTE 4: Tentar escrever em x0
        a3 = 5'd0;
        wd3 = 32'd999;

        @(posedge clk);
        #1;

        a1 = 5'd0;
        a2 = 5'd0;
        #1;

        if (rd1 === 32'd0 && rd2 === 32'd0)
            $display("Sucesso: x0 permanece sempre zero.");
        else
            $display("Falha: x0 foi alterado.");

        // TESTE 5: Escrita desabilitada
        we3 = 0;
        a3 = 5'd6;
        wd3 = 32'd200;

        @(posedge clk);
        #1;

        a1 = 5'd6;
        #1;

        if (rd1 === 32'd50)
            $display("Sucesso: Escrita desabilitada corretamente.");
        else
            $display("Falha: O registrador foi alterado.");

        $display("--------------------------------");
        $display("Fim dos testes do banco de registradores.");

        $finish;

    end

endmodule