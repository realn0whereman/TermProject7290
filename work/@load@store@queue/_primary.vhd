library verilog;
use verilog.vl_types.all;
entity LoadStoreQueue is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        memR            : in     vl_logic;
        memW            : in     vl_logic;
        addr_in_C       : in     vl_logic_vector(31 downto 0);
        data_in_C       : in     vl_logic_vector(31 downto 0);
        cntrl_in_C      : in     vl_logic_vector(15 downto 0);
        Z_in_C          : in     vl_logic_vector(3 downto 0);
        addr_out_C      : out    vl_logic_vector(31 downto 0);
        data_out_C      : out    vl_logic_vector(31 downto 0);
        cntrl_out_C     : out    vl_logic_vector(15 downto 0);
        Z_out_C         : out    vl_logic_vector(3 downto 0);
        ready_out_C     : out    vl_logic;
        addr_out_M      : out    vl_logic_vector(31 downto 0);
        data_out_M      : out    vl_logic_vector(31 downto 0);
        rw_out_M        : out    vl_logic;
        ldstID_out_M    : out    vl_logic_vector(3 downto 0);
        valid_out_M     : out    vl_logic;
        data_in_M       : in     vl_logic_vector(31 downto 0);
        ldstID_in_M     : in     vl_logic_vector(3 downto 0);
        stall_in_M      : in     vl_logic;
        ready_in_M      : in     vl_logic;
        stall_out_C     : out    vl_logic;
        empty           : out    vl_logic
    );
end LoadStoreQueue;
