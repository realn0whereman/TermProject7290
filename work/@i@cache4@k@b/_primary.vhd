library verilog;
use verilog.vl_types.all;
entity ICache4KB is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr_in         : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0)
    );
end ICache4KB;
