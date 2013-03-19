library verilog;
use verilog.vl_types.all;
entity DCache4KB is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        memR            : in     vl_logic;
        memW            : in     vl_logic;
        ldstID          : in     vl_logic_vector(3 downto 0);
        addr            : in     vl_logic_vector(31 downto 0);
        Wdata           : in     vl_logic_vector(31 downto 0);
        Rdata           : out    vl_logic_vector(31 downto 0);
        ldstID_out      : out    vl_logic_vector(3 downto 0);
        ready_out       : out    vl_logic
    );
end DCache4KB;
