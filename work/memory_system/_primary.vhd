library verilog;
use verilog.vl_types.all;
entity memory_system is
    port(
        addr_in         : in     vl_logic_vector(31 downto 0);
        data_in         : in     vl_logic_vector(31 downto 0);
        rw_in           : in     vl_logic;
        id_in           : in     vl_logic_vector(3 downto 0);
        valid_in        : in     vl_logic;
        data_out        : out    vl_logic_vector(31 downto 0);
        id_out          : out    vl_logic_vector(3 downto 0);
        ready_out       : out    vl_logic;
        stall_out       : out    vl_logic
    );
end memory_system;
