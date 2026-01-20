//========================================================================
// MusicMem_RTL.v
//========================================================================
// A staff-provided memory to supply memory values to play music

`ifndef MUSIC_MEM_RTL_V
`define MUSIC_MEM_RTL_V

localparam REST     = 32'h00000000;
localparam NOTE_G   = 32'h00000001;
localparam NOTE_A   = 32'h00000002;
localparam NOTE_B   = 32'h00000003;
localparam NOTE_C   = 32'h00000004;
localparam NOTE_D   = 32'h00000005;
localparam NOTE_E   = 32'h00000006;
localparam NOTE_F   = 32'h00000007;
localparam SONG_END = 32'hffffffff;

module MusicMem_RTL
(
  (* keep=1 *) input  logic        memreq_val,
  (* keep=1 *) input  logic [15:0] memreq_addr,
  (* keep=1 *) output logic [31:0] memresp_data
);

  always_comb begin
    case( memreq_addr )

      //----------------------------------------------------------------
      // Song 0
      //----------------------------------------------------------------

      16'h0000: memresp_data = NOTE_B;
      16'h0004: memresp_data = REST;
      16'h0008: memresp_data = NOTE_A;
      16'h000C: memresp_data = REST;
      16'h0010: memresp_data = NOTE_G;
      16'h0014: memresp_data = REST;
      16'h0018: memresp_data = NOTE_A;
      16'h001C: memresp_data = REST;

      16'h0020: memresp_data = NOTE_B;
      16'h0024: memresp_data = REST;
      16'h0028: memresp_data = NOTE_B;
      16'h002C: memresp_data = REST;
      16'h0030: memresp_data = NOTE_B;
      16'h0034: memresp_data = REST;
      16'h0038: memresp_data = REST;
      16'h003C: memresp_data = REST;

      16'h0040: memresp_data = NOTE_A;
      16'h0044: memresp_data = REST;
      16'h0048: memresp_data = NOTE_A;
      16'h004C: memresp_data = REST;
      16'h0050: memresp_data = NOTE_A;
      16'h0054: memresp_data = REST;
      16'h0058: memresp_data = REST;
      16'h005C: memresp_data = REST;

      16'h0060: memresp_data = NOTE_B;
      16'h0064: memresp_data = REST;
      16'h0068: memresp_data = NOTE_D;
      16'h006C: memresp_data = REST;
      16'h0070: memresp_data = NOTE_D;
      16'h0074: memresp_data = REST;
      16'h0078: memresp_data = REST;
      16'h007C: memresp_data = REST;

      16'h0080: memresp_data = NOTE_B;
      16'h0084: memresp_data = REST;
      16'h0088: memresp_data = NOTE_A;
      16'h008C: memresp_data = REST;
      16'h0090: memresp_data = NOTE_G;
      16'h0094: memresp_data = REST;
      16'h0098: memresp_data = NOTE_A;
      16'h009C: memresp_data = REST;

      16'h00A0: memresp_data = NOTE_B;
      16'h00A4: memresp_data = REST;
      16'h00A8: memresp_data = NOTE_B;
      16'h00AC: memresp_data = REST;
      16'h00B0: memresp_data = NOTE_B;
      16'h00B4: memresp_data = REST;
      16'h00B8: memresp_data = NOTE_B;
      16'h00BC: memresp_data = REST;

      16'h00C0: memresp_data = NOTE_A;
      16'h00C4: memresp_data = REST;
      16'h00C8: memresp_data = NOTE_A;
      16'h00CC: memresp_data = REST;
      16'h00D0: memresp_data = NOTE_B;
      16'h00D4: memresp_data = REST;
      16'h00D8: memresp_data = NOTE_A;
      16'h00DC: memresp_data = REST;

      16'h00E0: memresp_data = NOTE_G;
      16'h00E4: memresp_data = NOTE_G;
      16'h00E8: memresp_data = NOTE_G;
      16'h00EC: memresp_data = NOTE_G;
      16'h00F0: memresp_data = REST;
      16'h00F4: memresp_data = REST;
      16'h00F8: memresp_data = REST;
      16'h00FC: memresp_data = SONG_END;

      //----------------------------------------------------------------
      // Song 1
      //----------------------------------------------------------------

      16'h0200: memresp_data = NOTE_B;
      16'h0204: memresp_data = REST;
      16'h0208: memresp_data = NOTE_B;
      16'h020C: memresp_data = REST;
      16'h0210: memresp_data = NOTE_B;
      16'h0214: memresp_data = REST;
      16'h0218: memresp_data = REST;
      16'h021C: memresp_data = REST;

      16'h0220: memresp_data = NOTE_B;
      16'h0224: memresp_data = REST;
      16'h0228: memresp_data = NOTE_B;
      16'h022C: memresp_data = REST;
      16'h0230: memresp_data = NOTE_B;
      16'h0234: memresp_data = REST;
      16'h0238: memresp_data = REST;
      16'h023C: memresp_data = REST;

      16'h0240: memresp_data = NOTE_B;
      16'h0244: memresp_data = REST;
      16'h0248: memresp_data = NOTE_D;
      16'h024C: memresp_data = REST;
      16'h0250: memresp_data = NOTE_G;
      16'h0254: memresp_data = REST;
      16'h0258: memresp_data = NOTE_A;
      16'h025C: memresp_data = REST;

      16'h0260: memresp_data = NOTE_B;
      16'h0264: memresp_data = NOTE_B;
      16'h0268: memresp_data = NOTE_B;
      16'h026C: memresp_data = NOTE_B;
      16'h0270: memresp_data = REST;
      16'h0274: memresp_data = REST;
      16'h0278: memresp_data = REST;
      16'h027C: memresp_data = REST;

      16'h0280: memresp_data = NOTE_C;
      16'h0284: memresp_data = REST;
      16'h0288: memresp_data = NOTE_C;
      16'h028C: memresp_data = REST;
      16'h0290: memresp_data = NOTE_C;
      16'h0294: memresp_data = REST;
      16'h0298: memresp_data = NOTE_C;
      16'h029C: memresp_data = REST;

      16'h02A0: memresp_data = NOTE_C;
      16'h02A4: memresp_data = REST;
      16'h02A8: memresp_data = NOTE_B;
      16'h02AC: memresp_data = REST;
      16'h02B0: memresp_data = NOTE_B;
      16'h02B4: memresp_data = REST;
      16'h02B8: memresp_data = NOTE_B;
      16'h02BC: memresp_data = REST;

      16'h02C0: memresp_data = NOTE_D;
      16'h02C4: memresp_data = REST;
      16'h02C8: memresp_data = NOTE_D;
      16'h02CC: memresp_data = REST;
      16'h02D0: memresp_data = NOTE_C;
      16'h02D4: memresp_data = REST;
      16'h02D8: memresp_data = NOTE_A;
      16'h02DC: memresp_data = REST;

      16'h02E0: memresp_data = NOTE_G;
      16'h02E4: memresp_data = NOTE_G;
      16'h02E8: memresp_data = NOTE_G;
      16'h02EC: memresp_data = NOTE_G;
      16'h02F0: memresp_data = REST;
      16'h02F4: memresp_data = REST;
      16'h02F8: memresp_data = REST;
      16'h02FC: memresp_data = SONG_END;

      //----------------------------------------------------------------
      // Song 2
      //----------------------------------------------------------------
      // OPTIONAL: Replace note values to make a new song!

      16'h0400: memresp_data = SONG_END;
      16'h0404: memresp_data = SONG_END;
      16'h0408: memresp_data = SONG_END;
      16'h040C: memresp_data = SONG_END;
      16'h0410: memresp_data = SONG_END;
      16'h0414: memresp_data = SONG_END;
      16'h0418: memresp_data = SONG_END;
      16'h041C: memresp_data = SONG_END;

      16'h0420: memresp_data = SONG_END;
      16'h0424: memresp_data = SONG_END;
      16'h0428: memresp_data = SONG_END;
      16'h042C: memresp_data = SONG_END;
      16'h0430: memresp_data = SONG_END;
      16'h0434: memresp_data = SONG_END;
      16'h0438: memresp_data = SONG_END;
      16'h043C: memresp_data = SONG_END;

      16'h0440: memresp_data = SONG_END;
      16'h0444: memresp_data = SONG_END;
      16'h0448: memresp_data = SONG_END;
      16'h044C: memresp_data = SONG_END;
      16'h0450: memresp_data = SONG_END;
      16'h0454: memresp_data = SONG_END;
      16'h0458: memresp_data = SONG_END;
      16'h045C: memresp_data = SONG_END;

      16'h0460: memresp_data = SONG_END;
      16'h0464: memresp_data = SONG_END;
      16'h0468: memresp_data = SONG_END;
      16'h046C: memresp_data = SONG_END;
      16'h0470: memresp_data = SONG_END;
      16'h0474: memresp_data = SONG_END;
      16'h0478: memresp_data = SONG_END;
      16'h047C: memresp_data = SONG_END;

      16'h0480: memresp_data = SONG_END;
      16'h0484: memresp_data = SONG_END;
      16'h0488: memresp_data = SONG_END;
      16'h048C: memresp_data = SONG_END;
      16'h0490: memresp_data = SONG_END;
      16'h0494: memresp_data = SONG_END;
      16'h0498: memresp_data = SONG_END;
      16'h049C: memresp_data = SONG_END;

      16'h04A0: memresp_data = SONG_END;
      16'h04A4: memresp_data = SONG_END;
      16'h04A8: memresp_data = SONG_END;
      16'h04AC: memresp_data = SONG_END;
      16'h04B0: memresp_data = SONG_END;
      16'h04B4: memresp_data = SONG_END;
      16'h04B8: memresp_data = SONG_END;
      16'h04BC: memresp_data = SONG_END;

      16'h04C0: memresp_data = SONG_END;
      16'h04C4: memresp_data = SONG_END;
      16'h04C8: memresp_data = SONG_END;
      16'h04CC: memresp_data = SONG_END;
      16'h04D0: memresp_data = SONG_END;
      16'h04D4: memresp_data = SONG_END;
      16'h04D8: memresp_data = SONG_END;
      16'h04DC: memresp_data = SONG_END;

      16'h04E0: memresp_data = SONG_END;
      16'h04E4: memresp_data = SONG_END;
      16'h04E8: memresp_data = SONG_END;
      16'h04EC: memresp_data = SONG_END;
      16'h04F0: memresp_data = SONG_END;
      16'h04F4: memresp_data = SONG_END;
      16'h04F8: memresp_data = SONG_END;
      16'h04FC: memresp_data = SONG_END;

      //----------------------------------------------------------------
      // Song 17
      //----------------------------------------------------------------

      16'h2200: memresp_data = NOTE_C;
      16'h2204: memresp_data = NOTE_C;
      16'h2208: memresp_data = NOTE_C;
      16'h220C: memresp_data = NOTE_D;
      16'h2210: memresp_data = NOTE_E;
      16'h2214: memresp_data = NOTE_E;
      16'h2218: memresp_data = NOTE_E;
      16'h221C: memresp_data = NOTE_D;

      16'h2220: memresp_data = NOTE_C;
      16'h2224: memresp_data = REST;
      16'h2228: memresp_data = NOTE_A;
      16'h222C: memresp_data = REST;
      16'h2230: memresp_data = NOTE_A;
      16'h2234: memresp_data = REST;
      16'h2238: memresp_data = NOTE_G;
      16'h223C: memresp_data = REST;

      16'h2240: memresp_data = NOTE_D;
      16'h2244: memresp_data = NOTE_D;
      16'h2248: memresp_data = NOTE_D;
      16'h224C: memresp_data = NOTE_C;
      16'h2250: memresp_data = NOTE_B;
      16'h2254: memresp_data = NOTE_B;
      16'h2258: memresp_data = NOTE_C;
      16'h225C: memresp_data = NOTE_C;

      16'h2260: memresp_data = NOTE_D;
      16'h2264: memresp_data = NOTE_D;
      16'h2268: memresp_data = NOTE_D;
      16'h226C: memresp_data = NOTE_D;
      16'h2270: memresp_data = REST;
      16'h2274: memresp_data = REST;
      16'h2278: memresp_data = REST;
      16'h227C: memresp_data = REST;

      16'h2280: memresp_data = NOTE_C;
      16'h2284: memresp_data = NOTE_C;
      16'h2288: memresp_data = NOTE_C;
      16'h228C: memresp_data = NOTE_D;
      16'h2290: memresp_data = NOTE_E;
      16'h2294: memresp_data = NOTE_E;
      16'h2298: memresp_data = NOTE_E;
      16'h229C: memresp_data = NOTE_D;

      16'h22A0: memresp_data = NOTE_C;
      16'h22A4: memresp_data = REST;
      16'h22A8: memresp_data = NOTE_A;
      16'h22AC: memresp_data = REST;
      16'h22B0: memresp_data = NOTE_A;
      16'h22B4: memresp_data = REST;
      16'h22B8: memresp_data = NOTE_G;
      16'h22BC: memresp_data = REST;

      16'h22C0: memresp_data = NOTE_D;
      16'h22C4: memresp_data = NOTE_D;
      16'h22C8: memresp_data = NOTE_D;
      16'h22CC: memresp_data = NOTE_E;
      16'h22D0: memresp_data = NOTE_F;
      16'h22D4: memresp_data = NOTE_F;
      16'h22D8: memresp_data = NOTE_B;
      16'h22DC: memresp_data = NOTE_B;

      16'h22E0: memresp_data = NOTE_C;
      16'h22E4: memresp_data = NOTE_C;
      16'h22E8: memresp_data = NOTE_C;
      16'h22EC: memresp_data = NOTE_C;
      16'h22F0: memresp_data = REST;
      16'h22F4: memresp_data = REST;
      16'h22F8: memresp_data = REST;
      16'h22FC: memresp_data = REST;

      16'h2300: memresp_data = NOTE_E;
      16'h2304: memresp_data = NOTE_E;
      16'h2308: memresp_data = REST;
      16'h230C: memresp_data = NOTE_E;
      16'h2310: memresp_data = NOTE_D;
      16'h2314: memresp_data = REST;
      16'h2318: memresp_data = NOTE_D;
      16'h231C: memresp_data = REST;

      16'h2320: memresp_data = NOTE_C;
      16'h2324: memresp_data = NOTE_C;
      16'h2328: memresp_data = REST;
      16'h232C: memresp_data = NOTE_C;
      16'h2330: memresp_data = NOTE_B;
      16'h2334: memresp_data = REST;
      16'h2338: memresp_data = NOTE_B;
      16'h233C: memresp_data = REST;

      16'h2340: memresp_data = NOTE_A;
      16'h2344: memresp_data = NOTE_A;
      16'h2348: memresp_data = REST;
      16'h234C: memresp_data = NOTE_A;
      16'h2350: memresp_data = NOTE_G;
      16'h2354: memresp_data = REST;
      16'h2358: memresp_data = NOTE_C;
      16'h235C: memresp_data = REST;

      16'h2360: memresp_data = NOTE_D;
      16'h2364: memresp_data = NOTE_D;
      16'h2368: memresp_data = NOTE_D;
      16'h236C: memresp_data = NOTE_D;
      16'h2370: memresp_data = REST;
      16'h2374: memresp_data = REST;
      16'h2378: memresp_data = REST;
      16'h237C: memresp_data = REST;

      16'h2380: memresp_data = NOTE_C;
      16'h2384: memresp_data = NOTE_C;
      16'h2388: memresp_data = NOTE_C;
      16'h238C: memresp_data = NOTE_D;
      16'h2390: memresp_data = NOTE_E;
      16'h2394: memresp_data = NOTE_E;
      16'h2398: memresp_data = NOTE_E;
      16'h239C: memresp_data = NOTE_D;

      16'h23A0: memresp_data = NOTE_C;
      16'h23A4: memresp_data = REST;
      16'h23A8: memresp_data = NOTE_A;
      16'h23AC: memresp_data = REST;
      16'h23B0: memresp_data = NOTE_A;
      16'h23B4: memresp_data = REST;
      16'h23B8: memresp_data = NOTE_G;
      16'h23BC: memresp_data = REST;

      16'h23C0: memresp_data = NOTE_D;
      16'h23C4: memresp_data = NOTE_D;
      16'h23C8: memresp_data = NOTE_D;
      16'h23CC: memresp_data = NOTE_E;
      16'h23D0: memresp_data = NOTE_F;
      16'h23D4: memresp_data = NOTE_F;
      16'h23D8: memresp_data = NOTE_B;
      16'h23DC: memresp_data = NOTE_B;

      16'h23E0: memresp_data = NOTE_C;
      16'h23E4: memresp_data = NOTE_C;
      16'h23E8: memresp_data = NOTE_C;
      16'h23EC: memresp_data = NOTE_C;
      16'h23F0: memresp_data = REST;
      16'h23F4: memresp_data = REST;
      16'h23F8: memresp_data = REST;
      16'h23FC: memresp_data = SONG_END;

      default:  memresp_data = SONG_END;
    endcase

    if ( !memreq_val )
      memresp_data = 32'b0;

  end

endmodule

`endif /* MUSIC_MEM_RTL_V */

